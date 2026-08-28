require("dotenv").config();

const fs = require("fs");
const { Arca } = require("@arcasdk/core");

const arca = new Arca({
    cuit: Number(process.env.ARCA_CUIT),
    cert: fs.readFileSync("./certs/ZettaPrint.crt", "utf8"),
    key: fs.readFileSync("./certs/ZettaPrint.key", "utf8"),
    production: true,
    useHttpsAgent: true
});

async function main() {

    console.log("================================");
    console.log("   PAYLOAD FACTURA C - REVISION");
    console.log("================================");

    // Consultamos el último comprobante
    const ultimoComprobante =
        await arca.electronicBillingService.getLastVoucher(4, 11);

    const proximoNumero =
        Number(ultimoComprobante.cbteNro || 0) + 1;

    const importe = 66000;

    const factura = {
        CantReg: 1,

        PtoVta: 4,
        CbteTipo: 11,

        Concepto: 1,

        DocTipo: 99,
        DocNro: 0,

        CbteDesde: proximoNumero,
        CbteHasta: proximoNumero,

        CbteFch: "20260828",

        ImpTotal: importe,
        ImpTotConc: 0,
        ImpNeto: importe,
        ImpOpEx: 0,
        ImpIVA: 0,
        ImpTrib: 0,

        MonId: "PES",
        MonCotiz: 1,

        CondicionIVAReceptorId: 5
    };

    console.log("");
    console.log("Último comprobante:", ultimoComprobante.cbteNro);
    console.log("Próximo comprobante:", proximoNumero);

    console.log("");
    console.log("PAYLOAD:");
    console.dir(factura, { depth: null });

    console.log("");
    console.log("DETALLE INTERNO:");
    console.log("100 bolsas 30x30 ASAS Rojo");

    console.log("");
    console.log("================================");
    console.log("      NO SE ENVIO A ARCA");
    console.log("================================");
}

main().catch(error => {
    console.error("");
    console.error("ERROR:");
    console.error(error.message);
});