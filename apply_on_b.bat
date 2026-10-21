@echo off
setlocal EnableExtensions

set "PATCH=%~1"
if not defined PATCH set "PATCH=staged.patch"

if not exist "%PATCH%" (
  echo [ERROR] Patch file not found: %PATCH%
  exit /b 1
)

git apply --check "%PATCH%"
if errorlevel 1 (
  echo [ERROR] Patch check failed: %PATCH%
  exit /b 1
)

git apply "%PATCH%"
if errorlevel 1 (
  echo [ERROR] Failed to apply: %PATCH%
  exit /b 1
)

echo Applied: %PATCH%
endlocal
