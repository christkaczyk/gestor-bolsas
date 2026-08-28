require('dotenv').config();
const fs = require('fs');
const { Arca } = require('@arcasdk/core');

async function main() {
    console.log('======================================');
    console.log(' TEST CONEXION ARCA - ZETTAPRINT');
    console.log('======================================');

    const arca = new Arca({
        cuit: Number(process.env.ARCA_CUIT),
        cert: fs.readFileSync('./certs/ZettaPrint.crt', 'utf8'),
        key: fs.readFileSync('./certs/ZettaPrint.key', 'utf8'),
        production: true
    });

    console.log('\n[1/2] Consultando estado del servidor ARCA...');

    const status = await arca.electronicBillingService.getServerStatus();

    console.log('\n========== RESPUESTA ARCA ==========');
    console.dir(status, { depth: null });
    console.log('====================================');

    console.log('\n[OK] Conexion con ARCA funcionando.');
}

main().catch(error => {
    console.error('\n[ERROR] No se pudo conectar con ARCA.');
    console.error('\nMensaje:', error.message);

    if (error.stack) {
        console.error('\nStack:');
        console.error(error.stack);
    }

    process.exit(1);
});
