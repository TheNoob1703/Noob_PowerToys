@echo off
REM Check if administrator privileges are running
fsutil dirty query %systemdrive% >nul 2>nul
if %errorlevel% neq 0 (
    echo Requesting administrator permissions...
    set "params=%*"
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~sdp0%~nx0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

REM Start the script once administrator privileges are granted
:menu
cls
color 0A
echo =======================================
echo Date: %date%   Time: %time%
echo Hello %username%, welcome to the menu
echo =======================================
echo 1. Clean temporary files
echo 2. View/Clear DNS cache
echo 3. Enable TRIM for SSD and NVME
echo 4. Repair Windows
echo 5. Kill Microsoft Recall
echo 6. Exit
echo =======================================
set /p option="Select an option: "

REM Evaluate the selected option
if "%option%"=="1" goto option1
if "%option%"=="2" goto option2
if "%option%"=="3" goto option3
if "%option%"=="4" goto option4
if "%option%"=="5" goto option5
if "%option%"=="6" goto exit_script

REM If the option is invalid, return to the menu
echo Invalid option. Please try again.
pause
goto menu

:option1
cls
color 0A
echo Running temporary file cleanup...
rmdir /s /q "C:\Windows\Temp"
rmdir /s /q "C:\Users\%username%\AppData\Local\Temp"
rmdir /s /q "C:\Windows\Prefetch"
start cleanmgr

REM Create a VBScript for the message box
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox.vbs"
echo objShell.Popup "Cleanup completed", 2, "System Status", 64 >> "%temp%\messagebox.vbs"

REM Run the VBScript
cscript //nologo "%temp%\messagebox.vbs"
del "%temp%\messagebox.vbs" 2>nul

goto menu

:option2
cls
color 0A
echo =======================================
echo         View/Clear DNS Cache
echo =======================================
echo 1. View DNS cache
echo 2. Clear DNS cache
echo 3. Return to the main menu
echo =======================================
set /p dnsoption="Select an option: "

if "%dnsoption%"=="1" goto view_dns
if "%dnsoption%"=="2" goto clear_dns
if "%dnsoption%"=="3" goto menu

REM If the option is invalid, return to the submenu
echo Invalid option. Please try again.
pause
goto option2

:view_dns
cls
color 0A
echo Displaying DNS cache and saving to C:\dns.txt...
ipconfig /displaydns > C:\dns.txt
if %errorlevel%==0 (
    echo The DNS cache was successfully saved to C:\dns.txt.
) else (
    echo Error displaying the DNS cache.
)
pause
goto option2

:clear_dns
cls
color 0A
echo Clearing the DNS cache...
ipconfig /flushdns
if %errorlevel%==0 (
    echo The DNS cache has been cleared successfully.
) else (
    echo Error clearing the DNS cache.
)
pause
goto option2

:option3
cls
color 0A
echo Checking current TRIM status...
fsutil behavior query DisableDeleteNotify
echo Enabling TRIM for SSD and NVME drives...
fsutil behavior set DisableDeleteNotify 0
echo Running disk performance test...
winsat disk >nul 2>&1

REM Create a VBScript for the message box
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox_trim.vbs"
echo objShell.Popup "TRIM Enabled", 2, "System Status", 64 >> "%temp%\messagebox_trim.vbs"

REM Run the VBScript
cscript //nologo "%temp%\messagebox_trim.vbs"
del "%temp%\messagebox_trim.vbs" 2>nul

goto menu

:option4
cls
color 0A
echo =============================================
echo  Repairing Windows, please wait...
echo =============================================

REM Run sfc /scannow
echo Running: sfc /scannow
sfc /scannow

REM Run DISM /Online /Cleanup-Image /CheckHealth
echo Running: DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /CheckHealth

REM Run DISM /Online /Cleanup-Image /ScanHealth
echo Running: DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /ScanHealth

REM Run DISM /Online /Cleanup-Image /RestoreHealth
echo Running: DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /RestoreHealth

REM Create a VBScript for the message box
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox_repair.vbs"
echo objShell.Popup "Your Windows has been repaired", 2, "System Status", 64 >> "%temp%\messagebox_repair.vbs"

REM Run the VBScript
cscript //nologo "%temp%\messagebox_repair.vbs"
del "%temp%\messagebox_repair.vbs" 2>nul

goto menu

:option5
cls
color 0A
echo =======================================
echo  Killing Microsoft Recall...
echo =======================================
echo Trying to terminate Microsoft Recall process...
taskkill /f /im recall.exe >nul 2>nul
if %errorlevel%==0 (
    echo The Microsoft Recall process has been successfully stopped.
) else (
    echo Error trying to kill the Microsoft Recall process.
)

REM Create a VBScript for the message box
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\messagebox_recall.vbs"
echo objShell.Popup "Windows recall has been removed", 2, "System Status", 64 >> "%temp%\messagebox_recall.vbs"

REM Run the VBScript
cscript //nologo "%temp%\messagebox_recall.vbs"
del "%temp%\messagebox_recall.vbs" 2>nul

goto menu

:exit_script
cls
color 0A
echo Exiting the program. See you soon.
timeout /t 3 /nobreak >nul
exit
