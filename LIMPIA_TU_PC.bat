set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
@echo off "borrar temporales"
rmdir /s /q "C:\Windows\Temp"
rmdir /s /q "C:\Users\%username%\AppData\Local\Temp
rmdir /s /q "C:\Windows\Prefetch"
start cleanmgr
pause
start ccleaner
pause
start dfrgui
msg * "Gracias por optimizar tu sistema, abre esta utilidad cada semana como minimo y maximo 1 mes para mantener tu PC en un optimo estado de rendimiento"
exit
