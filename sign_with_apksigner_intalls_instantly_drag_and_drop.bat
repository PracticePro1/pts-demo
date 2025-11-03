@echo off
title APK Signer & Aligner - Drag & Drop Version
echo =========================================
echo         AUTO SIGN + ALIGN APK
echo =========================================
echo.

REM --- Check for file argument (drag-and-drop) ---
if "%~1"=="" (
    echo Please drag your unsigned APK onto this file to sign it.
    pause
    exit /b
)

REM --- Paths ---
set "APK_PATH=%~1"
set "APK_DIR=%~dp1"
set "APK_NAME=%~nx1"
set "SIGNDIR=C:\Users\Francis Osae Otopah\Desktop\SIGNING"
set "KEYSTORE=%SIGNDIR%\my-release-key.jks"
set "ALIAS=my-key-alias"
set "SIGNED_APK=%SIGNDIR%\signed_%APK_NAME%"
set "ALIGNED_APK=%SIGNDIR%\aligned_%APK_NAME%"
set "BUILDTOOLS=C:\Users\Francis Osae Otopah\AppData\Local\Android\Sdk\build-tools\36.1.0"

echo Input APK: %APK_PATH%
echo.

REM --- Sign APK ---
echo Signing APK with apksigner...
"%BUILDTOOLS%\apksigner.bat" sign ^
    --ks "%KEYSTORE%" ^
    --ks-key-alias "%ALIAS%" ^
    --out "%SIGNED_APK%" ^
    "%APK_PATH%"
if errorlevel 1 (
    echo.
    echo ERROR: Signing failed.
    pause
    exit /b
)
echo.
echo APK signed successfully: %SIGNED_APK%

REM --- Align APK ---
echo Aligning APK for faster installation...
"%BUILDTOOLS%\zipalign.exe" -v 4 "%SIGNED_APK%" "%ALIGNED_APK%"
if errorlevel 1 (
    echo.
    echo ERROR: Zipalign failed.
    pause
    exit /b
)

REM --- Verify APK ---
echo.
echo Verifying signed and aligned APK...
"%BUILDTOOLS%\apksigner.bat" verify --verbose "%ALIGNED_APK%"
if errorlevel 1 (
    echo.
    echo WARNING: Verification issue detected.
    pause
    exit /b
)

echo.
echo =========================================
echo ✅ Process complete!
echo Ready-to-install APK:
echo %ALIGNED_APK%
echo =========================================
pause
