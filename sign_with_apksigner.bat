@echo off
setlocal

:: -----------------------------------------------------------
::  ANDROID APK SIGNER SCRIPT (Using apksigner)
:: -----------------------------------------------------------

:: Folder where your files are stored
set SIGNDIR=C:\Users\Francis Osae Otopah\Desktop\SIGNING

:: Path to apksigner tool (using your latest build-tools version)
set APKSIGNER="C:\Users\Francis Osae Otopah\AppData\Local\Android\Sdk\build-tools\36.1.0\apksigner.bat"

:: Keystore details
set KEYSTORE=%SIGNDIR%\my-release-key.jks
set ALIAS=my-key-alias
set KEY_PASS=123456

echo.
echo =========================================
echo     APK SIGNING USING apksigner TOOL
echo =========================================
echo.

:: Ask for APK file name
set /p APK_NAME=Enter the name of your unsigned APK (e.g. myapp.apk): 

:: Build paths
set INPUT_APK=%SIGNDIR%\%APK_NAME%
set OUTPUT_APK=%SIGNDIR%\signed_%APK_NAME%

echo.
echo Signing APK: %APK_NAME%
echo -----------------------------------------

%APKSIGNER% sign ^
--ks "%KEYSTORE%" ^
--ks-key-alias %ALIAS% ^
--ks-pass pass:%KEY_PASS% ^
--key-pass pass:%KEY_PASS% ^
--out "%OUTPUT_APK%" ^
"%INPUT_APK%"

if %errorlevel% neq 0 (
    echo ERROR: Signing failed.
    pause
    exit /b
)

echo.
echo Verifying signature...
echo -----------------------------------------
%APKSIGNER% verify --verbose "%OUTPUT_APK%"

if %errorlevel% neq 0 (
    echo ERROR: Verification failed.
    pause
    exit /b
)

echo.
echo =========================================
echo ✅ Signing completed successfully!
echo Output file: %OUTPUT_APK%
echo =========================================
pause
