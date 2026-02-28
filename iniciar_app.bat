@echo off

cd /d Z:\gestor-bolsas

start cmd /k "npm start"

timeout /t 5 > nul

start http://localhost:3000