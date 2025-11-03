@echo off
title APK Signer & Aligner - Instant Install Ready
echo =========================================
echo      APK SIGNING AND ALIGNMENT TOOL
echo =========================================
echo.

:: --- SETUP YOUR PATHS HERE ---
set SIGNDIR=C:\Users\Francis Osae Otopah\Desktop\SIGNING
set BUILD_TOOLS=C:\Users\Francis Osae Otopah\AppData\Local\Android\Sdk\build-tools\36.1.0
set KEYSTORE=%SIGNDIR%\my-release-key.jks
set ALIAS=my-key-alias
set STOREPASS=123456
:: ------------------------------

echo Enter the name of your unsigned APK (e.g. myapp.apk):
set /p APK_NAME=
echo.

set INPUT_APK=%SIGNDIR%\%APK_NAME%
set OUTPUT_APK=%SIGNDIR%\signed_%APK_NAME%
set ALIGNED_APK=%SIGNDIR%\aligned_%APK_NAME%

if not exist "%INPUT_APK%" (
    echo ERROR: APK file "%INPUT_APK%" not found.
    pause
    exit /b
)

echo Signing APK...
"%BUILD_TOOLS%\apksigner.bat" sign ^
    --ks "%KEYSTORE%" ^
    --ks-key-alias %ALIAS% ^
    --ks-pass pass:%STOREPASS% ^
    --key-pass pass:%STOREPASS% ^
    --out "%OUTPUT_APK%" "%INPUT_APK%"

if %errorlevel% neq 0 (
    echo ERROR: Signing failed.
    pause
    exit /b
)

echo.
echo Aligning APK for faster installation...
"%BUILD_TOOLS%\zipalign.exe" -f -v 4 "%OUTPUT_APK%" "%ALIGNED_APK%"

if %errorlevel% neq 0 (
    echo ERROR: Alignment failed.
    pause
    exit /b
)

echo.
echo Verifying final APK...
"%BUILD_TOOLS%\apksigner.bat" verify --verbose --print-certs "%ALIGNED_APK%"
echo.
echo =========================================
echo ✅ Process complete!
echo Signed and aligned APK ready at:
echo %ALIGNED_APK%
echo =========================================
pause
