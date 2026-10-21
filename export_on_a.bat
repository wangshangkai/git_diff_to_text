@echo off
setlocal EnableExtensions

set "OUT=%~1"
if not defined OUT set "OUT=staged.patch"

git diff --cached --binary --full-index > "%OUT%"
if errorlevel 1 (
  echo [ERROR] Failed to write: %OUT%
  exit /b 1
)

for %%A in ("%OUT%") do if %%~zA==0 echo [WARN] No staged changes.

echo Patch written to: %OUT%
echo Changed files:
git diff --cached --name-status
endlocal
