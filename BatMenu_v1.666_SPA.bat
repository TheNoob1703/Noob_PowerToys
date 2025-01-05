@echo off
REM Comprobamos si se estan ejecutando permisos de administrador
fsutil dirty query %systemdrive% >nul 2>nul
if %errorlevel% neq 0 (
    echo Pidiendo permisos de administrador...
    set "params=%*"
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~sdp0%~nx0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

REM Comienzo del script una vez que tiene permisos de administrador
:menu
cls
color 0A
echo =======================================
echo Fecha: %date%   Hora: %time%
echo Hola %username%, bienvenido al menu
echo =======================================
echo 1. Limpiar archivos temporales
echo 2. Ver/Borrar cache DNS
echo 3. Activar TRIM para SSD y NVME
echo 4. Reparar Windows
echo 5. Matar Microsoft Recall
echo 6. Salir
echo =======================================
set /p opcion="Selecciona una opcion: "

REM Evaluamos la opcion ingresada
if "%opcion%"=="1" goto opcion1
if "%opcion%"=="2" goto opcion2
if "%opcion%"=="3" goto opcion3
if "%opcion%"=="4" goto opcion4
if "%opcion%"=="5" goto opcion5
if "%opcion%"=="6" goto salir

REM Si la opcion no es valida, volvemos al menu
echo Opcion no valida. Intentalo de nuevo.
pause
goto menu

:opcion1
cls
color 0A
echo Ejecutando limpieza de archivos temporales...
rmdir /s /q "C:\Windows\Temp"
rmdir /s /q "C:\Users\%username%\AppData\Local\Temp"
rmdir /s /q "C:\Windows\Prefetch"
start cleanmgr

REM Crear un script de VBScript para la caja de mensaje
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox.vbs"
echo objShell.Popup "Limpieza completada", 2, "Estado del sistema", 64 >> "%temp%\messagebox.vbs"

REM Ejecutar el script de VBScript
cscript //nologo "%temp%\messagebox.vbs"
del "%temp%\messagebox.vbs" 2>nul

goto menu

:opcion2
cls
color 0A
echo =======================================
echo         Ver/Borrar cache DNS
echo =======================================
echo 1. Ver cache DNS
echo 2. Borrar cache DNS
echo 3. Volver al menu principal
echo =======================================
set /p dnsopcion="Selecciona una opcion: "

if "%dnsopcion%"=="1" goto ver_dns
if "%dnsopcion%"=="2" goto borrar_dns
if "%dnsopcion%"=="3" goto menu

REM Si la opcion no es valida, volvemos al submenu
echo Opcion no valida. Intentalo de nuevo.
pause
goto opcion2

:ver_dns
cls
color 0A
echo Mostrando cache DNS y guardando en C:\dns.txt...
ipconfig /displaydns > C:\dns.txt
if %errorlevel%==0 (
    echo La cache DNS se guardo exitosamente en C:\dns.txt.
) else (
    echo Error al mostrar la cache DNS.
)
pause
goto opcion2

:borrar_dns
cls
color 0A
echo Borrando la cache DNS...
ipconfig /flushdns
if %errorlevel%==0 (
    echo La cache DNS se ha borrado correctamente.
) else (
    echo Error al borrar la cache DNS.
)
pause
goto opcion2

:opcion3
cls
color 0A
echo Verificando estado actual de TRIM...
fsutil behavior query DisableDeleteNotify
echo Habilitando TRIM para discos SSD y NVME...
fsutil behavior set DisableDeleteNotify 0
echo Ejecutando prueba de rendimiento de disco...
winsat disk >nul 2>&1

REM Crear un script de VBScript para la caja de mensaje
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox_trim.vbs"
echo objShell.Popup "TRIM Habilitado", 2, "Estado del sistema", 64 >> "%temp%\messagebox_trim.vbs"

REM Ejecutar el script de VBScript
cscript //nologo "%temp%\messagebox_trim.vbs"
del "%temp%\messagebox_trim.vbs" 2>nul

goto menu

:opcion4
cls
color 0A
echo =============================================
echo  Reparando Windows, por favor espere...
echo =============================================

REM Ejecutar sfc /scannow
echo Ejecutando: sfc /scannow
sfc /scannow

REM Ejecutar DISM /Online /Cleanup-Image /CheckHealth
echo Ejecutando: DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /CheckHealth

REM Ejecutar DISM /Online /Cleanup-Image /ScanHealth
echo Ejecutando: DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /ScanHealth

REM Ejecutar DISM /Online /Cleanup-Image /RestoreHealth
echo Ejecutando: DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /RestoreHealth

REM Crear un script de VBScript para la caja de mensaje
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox_repair.vbs"
echo objShell.Popup "Su Windows ha sido reparado", 2, "Estado del sistema", 64 >> "%temp%\messagebox_repair.vbs"

REM Ejecutar el script de VBScript
cscript //nologo "%temp%\messagebox_repair.vbs"
del "%temp%\messagebox_repair.vbs" 2>nul

goto menu

:opcion5
cls
color 0A
echo =======================================
echo  Matar Microsoft Recall...
echo =======================================
echo Intentando finalizar el proceso de Microsoft Recall...
taskkill /f /im recall.exe >nul 2>nul
if %errorlevel%==0 (
    echo El proceso de Microsoft Recall ha sido detenido exitosamente.
) else (
    echo Error al intentar matar el proceso de Microsoft Recall.
)

REM Crear un script de VBScript para la caja de mensaje
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox_recall.vbs"
echo objShell.Popup "Windows recall ha sido eliminado", 2, "Estado del sistema", 64 >> "%temp%\messagebox_recall.vbs"

REM Ejecutar el script de VBScript
cscript //nologo "%temp%\messagebox_recall.vbs"
del "%temp%\messagebox_recall.vbs" 2>nul

goto menu

:salir
cls
color 0A
echo Saliendo del programa. ¡Hasta pronto!
pause
exit

goto menu

:opcion5
cls
echo =======================================
echo  Matar Microsoft Recall...
echo =======================================
echo Intentando finalizar el proceso de Microsoft Recall...
taskkill /f /im recall.exe >nul 2>nul
if %errorlevel%==0 (
    echo El proceso de Microsoft Recall ha sido detenido exitosamente.
) else (
    echo Error al intentar matar el proceso de Microsoft Recall.
)

REM Crear un script de VBScript para la caja de mensaje
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox_recall.vbs"
echo objShell.Popup "Windows recall ha sido eliminado", 2, "Estado del sistema", 64 >> "%temp%\messagebox_recall.vbs"

REM Ejecutar el script de VBScript
cscript //nologo "%temp%\messagebox_recall.vbs"
del "%temp%\messagebox_recall.vbs" 2>nul

goto menu

:salir
cls
echo Saliendo del programa. Hasta pronto.
pause
exit
