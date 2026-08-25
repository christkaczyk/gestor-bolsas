const express = require("express");
const cors = require("cors");
const pool = require("./db");
require("dotenv").config();
const path = require("path");
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "../public")));


// Ruta principal
app.get("/", (req, res) => {
  res.send("Sistema gestor de bolsas funcionando 🚀");
});

// Obtener clientes desde la base real
app.get("/clientes", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM clientes ORDER BY id ASC");
    res.json(result.rows);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Error al obtener clientes" });
  }
});


// Obtener ventas
app.get("/ventas", async (req, res) => {
  try {
    const result = await pool.query(`
  SELECT 
    ventas.*,
    clientes.nombre,
    clientes.whatsapp,
    clientes.archivo_codigo,
    productos.tamano,
    productos.tipo_asa
  FROM ventas
  JOIN clientes ON ventas.cliente_id = clientes.id
  JOIN productos ON ventas.producto_id = productos.id
  ORDER BY ventas.fecha DESC, ventas.id DESC
`);

    res.json(result.rows);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener ventas" });
  }
});

// Crear venta
app.post("/ventas", async (req, res) => {
  try {
    const {
  fecha,
  cliente_id,
  producto_id,
  cantidad,
  color_bolsa,
  color_estampa,
  doble_estampa,
  envio_monto,
  fecha_entrega,
  factura
} = req.body;

    if (!fecha || !cliente_id || !producto_id || !cantidad) {
      return res.status(400).json({ error: "Faltan datos obligatorios" });
    }

    // ================================
    // 1️⃣ BUSCAR PRECIO DEL PACK
    // ================================

    const packResult = await pool.query(
      `SELECT precio_total 
       FROM precios_pack 
       WHERE producto_id = $1 AND cantidad = $2`,
      [producto_id, cantidad]
    );

    if (packResult.rows.length === 0) {
      return res.status(400).json({ error: "Pack inválido" });
    }

    let precio_producto = Number(packResult.rows[0].precio_total);

// 🔹 Doble estampa
if (doble_estampa) {
  precio_producto = precio_producto * 1.5;
}

// 🔹 Envío separado
const envioMonto = Number(envio_monto) || 0;

// 🔹 Precio final real que paga el cliente
const precio_final = precio_producto + envioMonto;

    // ================================
    // 2️⃣ OBTENER COSTO UNITARIO
    // ================================

    const productoResult = await pool.query(
      "SELECT costo_unitario FROM productos WHERE id = $1",
      [producto_id]
    );

    const costo_unitario = productoResult.rows[0].costo_unitario;

    // Costo total según pack
    const costo_total = costo_unitario * cantidad;

    // ================================
    // 3️⃣ CALCULAR GANANCIAS
    // ================================

    const ganancia_total = precio_producto - costo_total;
    const ganancia_taller = ganancia_total * 0.05;
    const ganancia_personal = ganancia_total - ganancia_taller;

    // ================================
    // 4️⃣ CALCULAR SEÑA Y RESTANTE
    // ================================

    const sena = precio_final * 0.5;
    const restante = precio_final - sena;

    // Estado inicial
    const estado = "sena_pagada";

// ================================
// 5️⃣ INSERTAR VENTA
// ================================

// 🔥 NUEVO BLOQUE — obtener mes activo
const mesResult = await pool.query(
  "SELECT id FROM meses WHERE activo = true ORDER BY id DESC LIMIT 1"
);

if (mesResult.rows.length === 0) {
  return res.status(400).json({ error: "No hay mes activo" });
}

const mes_id = mesResult.rows[0].id;

// 🔥 TU INSERT EXISTENTE (modificado)
await pool.query(
      `INSERT INTO ventas (
        fecha,
        cliente_id,
        producto_id,
        cantidad,
        color_bolsa,
        color_estampa,
        doble_estampa,
        envio_monto,
        precio_final,
        sena,
        restante,
        fecha_entrega,
        costo_total,
        ganancia_total,
        ganancia_taller,
        ganancia_personal,
        factura,
        estado, mes_id
      )
      VALUES (
        $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19
      )`,
      [
        fecha,
        cliente_id,
        producto_id,
        cantidad,
        color_bolsa,
        color_estampa,
        doble_estampa,
        envio_monto,
        precio_final,
        sena,
        restante,
        fecha_entrega,
        costo_total,
        ganancia_total,
        ganancia_taller,
        ganancia_personal,
        factura,
        estado,mes_id
      ]
    );

    res.json({ message: "Venta creada correctamente" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al crear venta" });
  }
});

// Crear pedido con múltiples items
app.post("/pedidos", async (req, res) => {
  const client = await pool.connect();

  try {
    const {
      cliente_id,
      fecha,
      envio,
      fecha_entrega,
      items
    } = req.body;

    await client.query("BEGIN");

    // 1️⃣ Crear pedido vacío primero
    const pedidoResult = await client.query(
      `INSERT INTO pedidos (cliente_id, fecha, envio, fecha_entrega)
       VALUES ($1,$2,$3,$4)
       RETURNING id`,
      [cliente_id, fecha, envio, fecha_entrega]
    );

    const pedido_id = pedidoResult.rows[0].id;

    let total_general = 0;

    // 2️⃣ Insertar cada item
    for (const item of items) {

      const { producto_id, cantidad, color_bolsa, color_estampa, doble_estampa } = item;

      // Traer costo unitario y precio unitario
      const productoResult = await client.query(
        `SELECT costo_unitario, precio_venta_unitario
         FROM productos
         WHERE id = $1`,
        [producto_id]
      );

      const costo_unitario = Number(productoResult.rows[0].costo_unitario);
      const precio_unitario = Number(productoResult.rows[0].precio_venta_unitario);

      let precio_item = precio_unitario * cantidad;

      if (doble_estampa) {
        precio_item = precio_item * 1.5;
      }

      const costo_item = costo_unitario * cantidad;
      const ganancia_item = precio_item - costo_item;

      total_general += precio_item;

      await client.query(
        `INSERT INTO pedido_items
         (pedido_id, producto_id, cantidad, color_bolsa, color_estampa, doble_estampa, precio_item, costo_item, ganancia_item)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
        [
          pedido_id,
          producto_id,
          cantidad,
          color_bolsa,
          color_estampa,
          doble_estampa,
          precio_item,
          costo_item,
          ganancia_item
        ]
      );
    }

    // 3️⃣ Calcular seña y restante
    const sena = total_general / 2;
    const restante = total_general - sena;

    await client.query(
      `UPDATE pedidos
       SET total_general=$1, sena=$2, restante=$3
       WHERE id=$4`,
      [total_general, sena, restante, pedido_id]
    );

    await client.query("COMMIT");

    res.json({ success: true });

  } catch (error) {
    await client.query("ROLLBACK");
    console.error(error);
    res.status(500).json({ error: "Error al crear pedido" });
  } finally {
    client.release();
  }
});

// Pagar restante y marcar como entregado
app.put("/ventas/:id/pagar-restante", async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `UPDATE ventas
       SET restante = 0,
           estado = 'entregado'
       WHERE id = $1
       RETURNING *`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Venta no encontrada" });
    }

    res.json(result.rows[0]);

  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Error al pagar restante" });
  }
});

// Revertir entrega
app.put("/ventas/:id/revertir-entrega", async (req, res) => {
  try {
    const { id } = req.params;

    const venta = await pool.query(
      "SELECT precio_final FROM ventas WHERE id = $1",
      [id]
    );

    if (venta.rows.length === 0) {
      return res.status(404).json({ error: "Venta no encontrada" });
    }

    const precio_final = venta.rows[0].precio_final;
    const sena = precio_final * 0.5;
    const restante = precio_final - sena;

    const result = await pool.query(
      `UPDATE ventas
       SET restante = $1,
           estado = 'sena_pagada'
       WHERE id = $2
       RETURNING *`,
      [restante, id]
    );

    res.json(result.rows[0]);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al revertir entrega" });
  }
});

// Crear producto
app.post("/productos", async (req, res) => {
  try {
    const { tamano, tipo_asa, precio_base } = req.body;

    if (!tamano || !tipo_asa) {
      return res.status(400).json({ error: "Tamaño y tipo de asa son obligatorios" });
    }

    const result = await pool.query(
      `INSERT INTO productos (tamano, tipo_asa, precio_base)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [tamano, tipo_asa, precio_base]
    );

    res.status(201).json(result.rows[0]);

  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Error al crear producto" });
  }
});

// Crear nuevo cliente
app.post("/clientes", async (req, res) => {
  try {
    const { nombre, whatsapp, direccion, localidad } = req.body;

    if (!nombre || !whatsapp) {
      return res.status(400).json({ error: "Faltan datos" });
    }

    // Validar whatsapp único
    const existe = await pool.query(
      "SELECT id FROM clientes WHERE whatsapp = $1",
      [whatsapp]
    );

    if (existe.rows.length > 0) {
      return res.status(400).json({ error: "Whatsapp ya registrado" });
    }

    // 🔥 Obtener número único de secuencia
// Obtener número único
const seqResult = await pool.query(
  "SELECT nextval('clientes_codigo_seq') as numero"
);

const numero = seqResult.rows[0].numero;

// Formato CL-0001
const archivo_codigo = `CL-${numero.toString().padStart(4, "0")}`;

    // INSERT COMPLETO
    await pool.query(
      `INSERT INTO clientes 
       (nombre, whatsapp, archivo_codigo, direccion, localidad)
       VALUES ($1,$2,$3,$4,$5)`,
      [nombre, whatsapp, archivo_codigo, direccion || null, localidad || null]
    );

    res.status(201).json({ message: "Cliente creado correctamente" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al crear cliente" });
  }
});



app.delete("/ventas/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      "DELETE FROM ventas WHERE id = $1 RETURNING *",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Venta no encontrada" });
    }

    res.json({ message: "Venta eliminada correctamente" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al eliminar venta" });
  }
});

app.put("/ventas/:id/etapa", async (req, res) => {
  try {
    const { id } = req.params;
    const { etapa } = req.body;

    const result = await pool.query(
      `UPDATE ventas
       SET etapa = $1
       WHERE id = $2
       RETURNING *`,
      [etapa, id]
    );

    res.json(result.rows[0]);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al actualizar etapa" });
  }
});



app.listen(process.env.PORT, () => {
  console.log("Servidor corriendo en puerto", process.env.PORT);
});

// ======================================================
// INGRESOS / EGRESOS
// ======================================================


// ======================================================
// OBTENER MOVIMIENTOS
// ======================================================

app.get("/movimientos-financieros", async (req, res) => {

  try {

    const result = await pool.query(`
      SELECT *
      FROM movimientos_financieros
      ORDER BY fecha DESC, id DESC
    `);

    res.json(result.rows);

  } catch (error) {

    console.error("Error obteniendo movimientos:", error);

    res.status(500).json({
      error: "Error al obtener movimientos"
    });

  }

});


// ======================================================
// CREAR MOVIMIENTO
// ======================================================

app.post("/movimientos-financieros", async (req, res) => {

  try {

    const {
      fecha,
      tipo,
      categoria,
      descripcion,
      monto,
      medio_pago,
      cuenta,
      comprobante,
      notas
    } = req.body;


    if (!fecha || !tipo || !categoria || !monto) {

      return res.status(400).json({
        error: "Faltan datos obligatorios"
      });

    }


    if (!["ingreso", "egreso"].includes(tipo)) {

      return res.status(400).json({
        error: "Tipo de movimiento inválido"
      });

    }


    const result = await pool.query(`
      INSERT INTO movimientos_financieros
      (
        fecha,
        tipo,
        categoria,
        descripcion,
        monto,
        medio_pago,
        cuenta,
        comprobante,
        notas
      )

      VALUES
      (
        $1,$2,$3,$4,$5,$6,$7,$8,$9
      )

      RETURNING *
    `, [
      fecha,
      tipo,
      categoria,
      descripcion || null,
      Number(monto),
      medio_pago || null,
      cuenta || null,
      comprobante || null,
      notas || null
    ]);


    res.status(201).json(result.rows[0]);


  } catch (error) {

    console.error("Error creando movimiento:", error);

    res.status(500).json({
      error: "Error al crear movimiento"
    });

  }

});


// ======================================================
// EDITAR MOVIMIENTO
// ======================================================

app.put("/movimientos-financieros/:id", async (req, res) => {

  try {

    const { id } = req.params;

    const {
      fecha,
      tipo,
      categoria,
      descripcion,
      monto,
      medio_pago,
      cuenta,
      comprobante,
      notas
    } = req.body;


    const result = await pool.query(`
      UPDATE movimientos_financieros

      SET
        fecha = $1,
        tipo = $2,
        categoria = $3,
        descripcion = $4,
        monto = $5,
        medio_pago = $6,
        cuenta = $7,
        comprobante = $8,
        notas = $9,
        actualizado_en = NOW()

      WHERE id = $10

      RETURNING *
    `, [
      fecha,
      tipo,
      categoria,
      descripcion || null,
      Number(monto),
      medio_pago || null,
      cuenta || null,
      comprobante || null,
      notas || null,
      id
    ]);


    if (result.rows.length === 0) {

      return res.status(404).json({
        error: "Movimiento no encontrado"
      });

    }


    res.json(result.rows[0]);


  } catch (error) {

    console.error("Error editando movimiento:", error);

    res.status(500).json({
      error: "Error al editar movimiento"
    });

  }

});


// ======================================================
// ELIMINAR MOVIMIENTO
// ======================================================

app.delete("/movimientos-financieros/:id", async (req, res) => {

  try {

    const { id } = req.params;


    const result = await pool.query(`
      DELETE FROM movimientos_financieros
      WHERE id = $1
      RETURNING *
    `, [id]);


    if (result.rows.length === 0) {

      return res.status(404).json({
        error: "Movimiento no encontrado"
      });

    }


    res.json({
      ok: true,
      message: "Movimiento eliminado correctamente"
    });


  } catch (error) {

    console.error("Error eliminando movimiento:", error);

    res.status(500).json({
      error: "Error al eliminar movimiento"
    });

  }

});

// Actualizar estado factura
app.put("/ventas/:id/factura", async (req, res) => {
  try {
    const { id } = req.params;
    const { factura } = req.body;

    const result = await pool.query(
      `UPDATE ventas
       SET factura = $1
       WHERE id = $2
       RETURNING *`,
      [factura, id]
    );

    res.json(result.rows[0]);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al actualizar factura" });
  }
});




app.put("/clientes/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, whatsapp, direccion, localidad } = req.body;

    await pool.query(
      `UPDATE clientes
       SET nombre = $1,
           whatsapp = $2,
           direccion = $3,
           localidad = $4
       WHERE id = $5`,
      [nombre, whatsapp, direccion, localidad, id]
    );

    res.json({ message: "Cliente actualizado correctamente" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al actualizar cliente" });
  }
});

app.delete("/clientes/:id", async (req, res) => {
  try {
    await pool.query("DELETE FROM clientes WHERE id = $1", [req.params.id]);
    res.json({ ok: true });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al eliminar cliente" });
  }
});

app.get("/clientes/:id/ventas", async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
  `SELECT 
      ventas.*,
      productos.tamano
   FROM ventas
   JOIN productos ON ventas.producto_id = productos.id
   WHERE ventas.cliente_id = $1
   ORDER BY ventas.fecha DESC`,
  [id]
);

    res.json(result.rows);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener historial" });
  }
});

app.get("/clientes/:id/ventas", async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `SELECT *
       FROM ventas
       WHERE cliente_id = $1
       ORDER BY fecha DESC`,
      [id]
    );

    res.json(result.rows);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener historial" });
  }
});

app.get("/clientes-ranking", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        clientes.id,
        clientes.nombre,
        clientes.whatsapp,
        clientes.archivo_codigo,
        COUNT(ventas.id) AS cantidad_compras
      FROM clientes
      LEFT JOIN ventas ON clientes.id = ventas.cliente_id
      GROUP BY clientes.id
      ORDER BY cantidad_compras DESC
      LIMIT 10
    `);

    res.json(result.rows);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener ranking" });
  }
});

// ======================================================
// RANKING DE CLIENTES POR GANANCIA
// ======================================================

app.get("/clientes-ranking-ganancia", async (req, res) => {
  try {

    const result = await pool.query(`
      SELECT
        clientes.id,
        clientes.nombre,
        clientes.whatsapp,
        clientes.archivo_codigo,

        COUNT(ventas.id) AS cantidad_compras,

        COALESCE(SUM(ventas.cantidad), 0) AS bolsas_vendidas,

        COALESCE(SUM(ventas.precio_final), 0) AS facturacion,

        COALESCE(SUM(ventas.ganancia_personal), 0) AS ganancia

      FROM clientes

      INNER JOIN ventas
        ON clientes.id = ventas.cliente_id

      GROUP BY
        clientes.id,
        clientes.nombre,
        clientes.whatsapp,
        clientes.archivo_codigo

      ORDER BY ganancia DESC

      LIMIT 20
    `);

    res.json(result.rows);

  } catch (error) {

    console.error("Error obteniendo ranking de clientes:", error);

    res.status(500).json({
      error: "Error al obtener ranking de clientes"
    });

  }
});

app.get("/productos", async (req, res) => {
  const result = await pool.query(`
    SELECT id, tamano, tipo_asa, costo_unitario
    FROM productos
    WHERE activo = true
    ORDER BY
  split_part(UPPER(tamano), 'X', 1)::integer,
  split_part(UPPER(tamano), 'X', 2)::integer,
  CASE
    WHEN UPPER(tipo_asa) = 'RINON' THEN 1
    WHEN UPPER(tipo_asa) = 'ASAS' THEN 2
    ELSE 3
  END
  `);
  res.json(result.rows);
});

app.get("/precios-pack/:id", async (req, res) => {
  const productoId = req.params.id;

  const result = await pool.query(`
    SELECT cantidad, precio_total
    FROM precios_pack
    WHERE producto_id = $1
    ORDER BY cantidad
  `, [productoId]);

  res.json(result.rows);
});


// ==========================================
// GUARDAR TODOS LOS PRECIOS DE LA PLANILLA
// ==========================================

// ==========================================
// GUARDAR TODOS LOS PRECIOS DE LA PLANILLA
// + HISTORIAL DE CAMBIOS
// ==========================================

app.put("/config/guardar-todos", async (req, res) => {

  const { productos } = req.body;

  if (!Array.isArray(productos)) {
    return res.status(400).json({
      error: "Formato de datos inválido"
    });
  }

  const client = await pool.connect();

  try {

    await client.query("BEGIN");

    // ==========================================
    // OBTENER ESTADO ACTUAL ANTES DE MODIFICAR
    // ==========================================

    const productosActuales = await client.query(`
      SELECT
        p.id,
        p.tamano,
        p.tipo_asa,
        p.costo_unitario,
        pp.cantidad,
        pp.precio_total
      FROM productos p
      LEFT JOIN precios_pack pp
        ON pp.producto_id = p.id
      WHERE p.activo = true
      ORDER BY p.id, pp.cantidad
    `);


    // ==========================================
    // MAPA DE VALORES ACTUALES
    // ==========================================

    const actuales = {};

    productosActuales.rows.forEach(row => {

      if (!actuales[row.id]) {

        actuales[row.id] = {
          nombre: `${row.tamano} ${row.tipo_asa}`,
          costo_unitario: Number(row.costo_unitario),
          packs: {}
        };

      }

      if (row.cantidad !== null) {

        actuales[row.id].packs[row.cantidad] =
          Number(row.precio_total);

      }

    });


    // ==========================================
    // DETECTAR CAMBIOS
    // ==========================================

    const cambiosCosto = [];
    const cambiosPacks = [];

    let totalPacks = 0;
    let packsModificados = 0;


    // Contar cantidad total de packs existentes

    Object.values(actuales).forEach(producto => {

      totalPacks += Object.keys(producto.packs).length;

    });


    // ==========================================
    // COMPARAR TODO
    // ==========================================

    for (const producto of productos) {

      const actual = actuales[producto.producto_id];

      if (!actual) continue;


      // ------------------------------------------
      // COSTO UNITARIO
      // ------------------------------------------

      const nuevoCosto =
        Number(producto.costo_unitario);

      const costoAnterior =
        Number(actual.costo_unitario);

      if (Math.abs(nuevoCosto - costoAnterior) > 0.001) {

        cambiosCosto.push({
          producto_id: producto.producto_id,
          producto: actual.nombre,
          anterior: costoAnterior,
          nuevo: nuevoCosto
        });

      }


      // ------------------------------------------
      // PACKS
      // ------------------------------------------

      for (const pack of producto.packs) {

        const cantidad = Number(pack.cantidad);

        const nuevoPrecio =
          Number(pack.precio_total);

        const precioAnterior =
          Number(actual.packs[cantidad] ?? 0);


        if (Math.abs(nuevoPrecio - precioAnterior) > 0.001) {

          packsModificados++;

          cambiosPacks.push({
            producto_id: producto.producto_id,
            producto: actual.nombre,
            pack: cantidad,
            anterior: precioAnterior,
            nuevo: nuevoPrecio
          });

        }

      }

    }


    // ==========================================
    // GENERAR RESUMEN
    // ==========================================

    const resumenes = [];


    // ------------------------------------------
    // TODOS LOS PACKS MODIFICADOS
    // ------------------------------------------

    if (
      totalPacks > 0 &&
      packsModificados === totalPacks
    ) {

      resumenes.push(
        "Se aumentaron todos los precios de los packs"
      );

    } else {

      // ------------------------------------------
      // PACKS INDIVIDUALES
      // ------------------------------------------

      if (cambiosPacks.length > 0) {

        cambiosPacks.forEach(cambio => {

          resumenes.push(
            `Se modificó Pack ${cambio.pack} — ${cambio.producto}`
          );

        });

      }

    }


    // ------------------------------------------
    // COSTOS UNITARIOS
    // ------------------------------------------

    cambiosCosto.forEach(cambio => {

      resumenes.push(
        `Se modificó el costo unitario — ${cambio.producto}`
      );

    });


    // ==========================================
    // GUARDAR CAMBIOS EN PRODUCTOS
    // ==========================================

    for (const producto of productos) {

      await client.query(`
        UPDATE productos
        SET costo_unitario = $1
        WHERE id = $2
      `, [
        producto.costo_unitario,
        producto.producto_id
      ]);


      // ------------------------------------------
      // GUARDAR PACKS
      // ------------------------------------------

      for (const pack of producto.packs) {

        await client.query(`
          UPDATE precios_pack
          SET precio_total = $1,
              updated_at = NOW()
          WHERE producto_id = $2
            AND cantidad = $3
        `, [
          pack.precio_total,
          producto.producto_id,
          pack.cantidad
        ]);

      }

    }


    // ==========================================
    // GUARDAR EN HISTORIAL
    // ==========================================

    if (resumenes.length > 0) {

      await client.query(`
        INSERT INTO historial_precios
        (
          detalle,
          cambios
        )
        VALUES ($1, $2)
      `, [

        resumenes.join(" | "),

        JSON.stringify({
          costos: cambiosCosto,
          packs: cambiosPacks
        })

      ]);

    }


    // ==========================================
    // CONFIRMAR
    // ==========================================

    await client.query("COMMIT");


    res.json({
      ok: true,
      message: "Todos los precios fueron guardados correctamente"
    });


  } catch (error) {

    await client.query("ROLLBACK");

    console.error(
      "Error guardando configuración:",
      error
    );

    res.status(500).json({
      error: "Error al guardar los precios"
    });


  } finally {

    client.release();

  }

});

// ==========================================
// OBTENER HISTORIAL DE PRECIOS
// ==========================================

app.get("/config/historial-precios", async (req, res) => {

  try {

    const result = await pool.query(`
      SELECT
        id,
        fecha_hora,
        detalle,
        cambios
      FROM historial_precios
      ORDER BY fecha_hora DESC, id DESC
    `);

    res.json(result.rows);

  } catch (error) {

    console.error(
      "Error obteniendo historial de precios:",
      error
    );

    res.status(500).json({
      error: "Error al obtener historial de precios"
    });

  }

});



app.post("/meses", async (req, res) => {
  try {
    const { nombre } = req.body;

    // Desactivar mes anterior
    await pool.query("UPDATE meses SET activo = false WHERE activo = true");

    const result = await pool.query(
      `INSERT INTO meses (nombre, fecha_inicio, activo)
       VALUES ($1, NOW(), true)
       RETURNING *`,
      [nombre]
    );

    res.json(result.rows[0]);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al crear mes" });
  }
});

app.put("/ventas/:id/fecha-entrega", async (req, res) => {
  try {

    const { id } = req.params;
    const { fecha_entrega } = req.body;

    const result = await pool.query(
      `UPDATE ventas
       SET fecha_entrega = $1
       WHERE id = $2
       RETURNING *`,
      [fecha_entrega, id]
    );

    res.json(result.rows[0]);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al actualizar fecha de entrega" });
  }
});

// Guardar código de seguimiento
app.put("/ventas/:id/seguimiento", async (req, res) => {
  try {

    const { id } = req.params;
    const { codigo } = req.body;

    const result = await pool.query(
      `UPDATE ventas
       SET codigo_seguimiento = $1
       WHERE id = $2
       RETURNING *`,
      [codigo, id]
    );

    res.json(result.rows[0]);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al guardar seguimiento" });
  }
});

app.put("/ventas/:id/precio", async (req, res) => {
  try {
    const { id } = req.params;
    const { nuevo_precio } = req.body;

    // 1️⃣ Obtener venta actual
    const ventaRes = await pool.query(
      "SELECT cantidad, costo_total FROM ventas WHERE id = $1",
      [id]
    );

    if (ventaRes.rows.length === 0) {
      return res.status(404).json({ error: "Venta no encontrada" });
    }

    const venta = ventaRes.rows[0];

    // 2️⃣ Recalcular valores
    const precio_final = Number(nuevo_precio);
    const sena = precio_final * 0.5;
    const restante = precio_final - sena;

    const ganancia_total = precio_final - venta.costo_total;
    const ganancia_taller = ganancia_total * 0.05;
    const ganancia_personal = ganancia_total - ganancia_taller;

    // 3️⃣ Actualizar
    const result = await pool.query(
      `UPDATE ventas
       SET precio_final=$1,
           sena=$2,
           restante=$3,
           ganancia_total=$4,
           ganancia_taller=$5,
           ganancia_personal=$6
       WHERE id=$7
       RETURNING *`,
      [
        precio_final,
        sena,
        restante,
        ganancia_total,
        ganancia_taller,
        ganancia_personal,
        id
      ]
    );

    res.json(result.rows[0]);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al actualizar precio" });
  }
});