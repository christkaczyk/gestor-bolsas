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

// Obtener productos
app.get("/productos", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM productos ORDER BY id ASC");
    res.json(result.rows);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Error al obtener productos" });
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
      envio_domicilio,
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

    let precio_final = packResult.rows[0].precio_total;

    // Si es doble estampa suma 50%
    if (doble_estampa) {
      precio_final = precio_final * 1.5;
    }

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

    const ganancia_total = precio_final - costo_total;
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

    await pool.query(
      `INSERT INTO ventas (
        fecha,
        cliente_id,
        producto_id,
        cantidad,
        color_bolsa,
        color_estampa,
        doble_estampa,
        envio_domicilio,
        precio_final,
        sena,
        restante,
        fecha_entrega,
        costo_total,
        ganancia_total,
        ganancia_taller,
        ganancia_personal,
        factura,
        estado
      )
      VALUES (
        $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18
      )`,
      [
        fecha,
        cliente_id,
        producto_id,
        cantidad,
        color_bolsa,
        color_estampa,
        doble_estampa,
        envio_domicilio,
        precio_final,
        sena,
        restante,
        fecha_entrega,
        costo_total,
        ganancia_total,
        ganancia_taller,
        ganancia_personal,
        factura,
        estado
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
    const { nombre, whatsapp } = req.body;

    if (!nombre || !whatsapp) {
      return res.status(400).json({ error: "Faltan datos" });
    }

    // 1️⃣ Validar que no exista whatsapp
    const existe = await pool.query(
      "SELECT id FROM clientes WHERE whatsapp = $1",
      [whatsapp]
    );

    if (existe.rows.length > 0) {
      return res.status(400).json({ error: "Whatsapp ya registrado" });
    }

    // 2️⃣ Obtener cantidad actual de clientes
    const count = await pool.query("SELECT COUNT(*) FROM clientes");
    const numero = parseInt(count.rows[0].count) + 1;

    const numeroFormateado = numero.toString().padStart(2, "0");

    const ultimos4 = whatsapp.slice(-4);

    const archivo_codigo = `${numeroFormateado}-${ultimos4}`;

    // 3️⃣ Insertar cliente
    await pool.query(
      `INSERT INTO clientes (nombre, whatsapp, archivo_codigo)
       VALUES ($1,$2,$3)`,
      [nombre, whatsapp, archivo_codigo]
    );

    res.json({ message: "Cliente creado correctamente" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al crear cliente" });
  }
});

app.get("/precios-pack/:productoId", async (req, res) => {
  try {
    const { productoId } = req.params;

    const result = await pool.query(
      "SELECT cantidad, precio_total FROM precios_pack WHERE producto_id = $1 ORDER BY cantidad ASC",
      [productoId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener packs" });
  }
});

app.listen(process.env.PORT, () => {
  console.log("Servidor corriendo en puerto", process.env.PORT);
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


app.get("/precios-pack/:productoId", async (req, res) => {
  try {
    const { productoId } = req.params;

    const result = await pool.query(
      "SELECT cantidad, precio_total FROM precios_pack WHERE producto_id = $1 ORDER BY cantidad ASC",
      [productoId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener packs" });
  }
});

app.put("/clientes/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, whatsapp } = req.body;

    await pool.query(
      `UPDATE clientes
       SET nombre = $1,
           whatsapp = $2
       WHERE id = $3`,
      [nombre, whatsapp, id]
    );

    res.json({ message: "Cliente actualizado" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al actualizar cliente" });
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