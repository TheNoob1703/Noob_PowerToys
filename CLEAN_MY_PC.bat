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
msg * "Thanks for optimising o¡your computer, open this utility period one week to one month to keep your coputer in good shap"
exit
