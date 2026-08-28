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
    console.log("     EMISIÓN FACTURA C REAL");
    console.log("================================");

    const ptoVta = 4;
    const cbteTipo = 11;
    const importe = 66000;

    // Consultamos nuevamente el último comprobante.
    // Esto evita asumir el número.
    const ultimo =
        await arca.electronicBillingService.getLastVoucher(
            ptoVta,
            cbteTipo
        );

    const proximoNumero =
        Number(ultimo.cbteNro || 0) + 1;

    console.log("");
    console.log("Último comprobante:", ultimo.cbteNro);
    console.log("Número a solicitar:", proximoNumero);

    const factura = {
        CantReg: 1,

        PtoVta: ptoVta,
        CbteTipo: cbteTipo,

        Concepto: 1,

        // Consumidor Final sin identificación
        DocTipo: 99,
        DocNro: 0,

        CbteDesde: proximoNumero,
        CbteHasta: proximoNumero,

        CbteFch: "20260828",

        // Factura C
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
    console.log("================================");
    console.log("       FACTURA A EMITIR");
    console.log("================================");

    console.dir(factura, { depth: null });

    console.log("");
    console.log("Detalle interno:");
    console.log("100 bolsas 30x30 ASAS Rojo");

    console.log("");
    console.log("================================");
    console.log("     ENVIANDO A ARCA...");
    console.log("================================");

    const resultado =
        await arca.electronicBillingService.createInvoice(factura);

    console.log("");
    console.log("================================");
    console.log("       RESPUESTA DE ARCA");
    console.log("================================");

    console.dir(resultado, { depth: null });

    console.log("");
    console.log("================================");
    console.log("        FIN DEL PROCESO");
    console.log("================================");
}

main().catch(error => {

    console.error("");
    console.error("================================");
    console.error("          ERROR ARCA");
    console.error("================================");

    console.error("Mensaje:");
    console.error(error.message);

    if (error.stack) {
        console.error("");
        console.error(error.stack);
    }

    process.exit(1);
});