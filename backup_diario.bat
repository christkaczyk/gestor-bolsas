@echo off

REM === CONFIGURACION ===
set DB_NAME=gestor_bolsas
set DB_USER=postgres
set BACKUP_PATH=Z:\gestor-bolsas\backups

REM === FECHA Y HORA ===
for /f %%i in ('powershell -command "Get-Date -Format yyyy_MM_dd_HH_mm"') do set FECHA=%%i

set PGPASSWORD=admin123

REM === BACKUP ===
"C:\Program Files\PostgreSQL\18\bin\pg_dump.exe" -U %DB_USER% %DB_NAME% > "%BACKUP_PATH%\gestor_bolsas_backup_%FECHA%.sql"

echo Backup completado!
pause