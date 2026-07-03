@echo off
setlocal

cd /d "%~dp0"

if not exist "%~dp0sign-mdl.ps1" (
  echo sign-mdl.ps1 was not found next to this launcher.
  echo.
  pause
  exit /b 1
)

where powershell.exe >nul 2>nul
if errorlevel 1 (
  echo Windows PowerShell was not found.
  echo Windows PowerShell 5.1 or newer is required.
  echo.
  pause
  exit /b 1
)

set "SCRIPT_PAUSE_ARG="
if "%PEARL_NO_CMD_PAUSE%"=="1" set "SCRIPT_PAUSE_ARG=-NoPause"

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0sign-mdl.ps1" %SCRIPT_PAUSE_ARG% %*
exit /b %ERRORLEVEL%
