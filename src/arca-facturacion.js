const fs = require("fs");
const { Arca } = require("@arcasdk/core");

const arca = new Arca({
    cuit: Number(process.env.ARCA_CUIT),
    cert: fs.readFileSync("./certs/ZettaPrint.crt", "utf8"),
    key: fs.readFileSync("./certs/ZettaPrint.key", "utf8"),
    production: true,
    useHttpsAgent: true
});

async function emitirFacturaC({
    importe,
    detalle
}) {
    if (!importe || importe <= 0) {
        throw new Error("El importe debe ser mayor a 0.");
    }

    if (!detalle || !detalle.trim()) {
        throw new Error("El detalle de la factura es obligatorio.");
    }

    // Punto de venta de ZettaPrint
    const ptoVta = 4;

    // Factura C
    const cbteTipo = 11;

    // Consumidor Final
    const docTipo = 99;
    const docNro = 0;

    // Producto
    const concepto = 1;

    // Consultamos el último comprobante
    const ultimo = await arca.electronicBillingService.getLastVoucher(
        ptoVta,
        cbteTipo
    );

    const proximoNumero = Number(ultimo.cbteNro || 0) + 1;

    const hoy = new Date();

    const fecha =
        hoy.getFullYear().toString() +
        String(hoy.getMonth() + 1).padStart(2, "0") +
        String(hoy.getDate()).padStart(2, "0");

    const payload = {
        CantReg: 1,

        PtoVta: ptoVta,
        CbteTipo: cbteTipo,

        Concepto: concepto,

        DocTipo: docTipo,
        DocNro: docNro,

        CbteDesde: proximoNumero,
        CbteHasta: proximoNumero,

        CbteFch: fecha,

        ImpTotal: Number(importe),
        ImpTotConc: 0,
        ImpNeto: Number(importe),
        ImpOpEx: 0,
        ImpIVA: 0,
        ImpTrib: 0,

        MonId: "PES",
        MonCotiz: 1,

        CondicionIVAReceptorId: 5
    };

    console.log("================================");
    console.log("     FACTURA C A EMITIR");
    console.log("================================");

    console.dir(payload, { depth: null });

    const resultado =
        await arca.electronicBillingService.createInvoice(payload);

    return resultado;
}

module.exports = {
    emitirFacturaC
};