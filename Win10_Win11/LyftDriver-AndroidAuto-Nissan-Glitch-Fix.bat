@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: LYFT DRIVER APP - ANDROID AUTO: 3-STEP GLITCH FIX (NISSAN GLITCH)
:: ============================================================


:: ------------------------------------------------------------
:: STEP 0: AUTO-DOWNLOAD ANDROID PLATFORM TOOLS (IF NEEDED)
:: ------------------------------------------------------------
if not exist "%~dp0platform-tools-latest-windows\" (
    echo.
    echo ============================================================
    echo   ANDROID PLATFORM TOOLS NOT FOUND -- DOWNLOADING NOW...
    echo ============================================================
    echo.
    echo Downloading the official Android Platform Tools from Google.
    echo (Approximately 11 MB -- an active internet connection is required.)
    echo.

    curl.exe -L --fail --progress-bar -o "%~dp0platform-tools-latest-windows.zip" "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"

    if !errorlevel! neq 0 (
        echo.
        echo [ERROR] The download failed. Possible causes:
        echo.
        echo   - No active internet connection
        echo   - A firewall, VPN, or proxy is blocking the download
        echo   - Google's servers are temporarily unavailable
        echo.
        echo As a fallback, manually download the tools from:
        echo   https://developer.android.com/tools/releases/platform-tools
        echo Extract the ZIP, rename the extracted folder to:
        echo   "platform-tools-latest-windows"
        echo and place it in the same folder as this batch file.
        echo Then re-run the script.
        echo.
        if exist "%~dp0platform-tools-latest-windows.zip" del /q "%~dp0platform-tools-latest-windows.zip"
        echo Press any key to EXIT...
        pause > nul
        exit /b 1
    )

    echo.
    echo Download complete. Extracting files...
    echo.

    tar -xf "%~dp0platform-tools-latest-windows.zip" -C "%~dp0."

    if !errorlevel! neq 0 (
        echo.
        echo [ERROR] Extraction failed. The downloaded file may be incomplete or corrupt.
        echo.
        echo Deleting the partial download. Re-run the script to try again.
        echo If the problem persists, check available disk space (at least 50 MB needed).
        echo.
        if exist "%~dp0platform-tools-latest-windows.zip" del /q "%~dp0platform-tools-latest-windows.zip"
        echo Press any key to EXIT...
        pause > nul
        exit /b 1
    )

    :: The ZIP extracts to a folder named "platform-tools" -- rename it to the expected name
    ren "%~dp0platform-tools" "platform-tools-latest-windows"

    :: Delete the ZIP now that extraction is complete
    del /q "%~dp0platform-tools-latest-windows.zip"

    echo.
    echo ============================================================
    echo   PLATFORM TOOLS DOWNLOADED AND EXTRACTED SUCCESSFULLY.
    echo ============================================================
    echo.
    pause
)


:: ------------------------------------------------------------
:: STEP 1: VERIFY THE PLATFORM-TOOLS FOLDER EXISTS (SAFETY CHECK)
:: ------------------------------------------------------------
if not exist "%~dp0platform-tools-latest-windows\" (
    echo.
    echo [ERROR] The "platform-tools-latest-windows" folder was NOT found.
    echo.
    echo This is unexpected -- the auto-download should have created it.
    echo The ZIP may have extracted with an incorrect folder name, or the
    echo folder may have been moved or deleted during this session.
    echo.
    echo Try deleting any leftover "platform-tools" or
    echo "platform-tools-latest-windows" folders from this directory,
    echo then re-run the script to download a fresh copy.
    echo.
    echo Press any key to EXIT...
    pause > nul
    exit /b 1
)


:: ------------------------------------------------------------
:: STEP 2: VERIFY ADB.EXE EXISTS INSIDE THAT FOLDER
:: ------------------------------------------------------------
if not exist "%~dp0platform-tools-latest-windows\adb.exe" (
    echo.
    echo [ERROR] "adb.exe" was NOT found inside the "platform-tools-latest-windows" folder.
    echo.
    echo The platform tools do not appear to be properly extracted in that folder.
    echo This is most commonly caused by Antivirus software blocking, quarantining,
    echo or silently deleting the platform tool executables during extraction.
    echo.
    echo   TO FIX: Open your Antivirus settings and add an exception for this folder,
    echo   or temporarily disable real-time protection, then re-extract the
    echo   platform-tools ZIP so the files are NOT blocked or removed. Run this script again.
    echo.
    echo Press any key to EXIT...
    pause > nul
    exit /b 1
)


:: ------------------------------------------------------------
:: STEP 3: PHONE SETUP INSTRUCTIONS
:: ------------------------------------------------------------
echo.
echo ============================================================
echo   BEFORE CONTINUING -- PREPARE YOUR ANDROID PHONE:
echo ============================================================
echo.
echo  1. ENABLE DEVELOPER OPTIONS (if not already done):
echo.
echo     On most Samsung Galaxy phones:
echo       Settings ^> About Phone ^> Software Information
echo       -- Tap "Build Number" 7 times rapidly --
echo       Your phone will display: "You are now a developer!"
echo.
echo  2. ENABLE USB DEBUGGING:
echo       Settings ^> Developer Options ^> Toggle ON "USB Debugging"
echo.
echo  NOTE: If tapping Build Number does NOT unlock Developer Options,
echo  or the "USB Debugging" option is missing from your menu, please
echo  consult Google for instructions specific to your device and Android version.
echo.
echo ============================================================
echo.
echo ============================================================
echo   THIS SCRIPT WILL AUTOMATICALLY APPLY 3 FIXES:
echo ============================================================
echo   Fix 1: Disable Wi-Fi "Switch to Mobile Data"  (Samsung)
echo   Fix 2: Force Lyft location to "Allow all the time"
echo   Fix 3: Disable precise location for Android Auto
echo ============================================================
echo.
echo Press any key to BEGIN ALL 3 FIXES...
pause > nul


:: ------------------------------------------------------------
:: STEP 4: CONFIGURE PATH TO ADB
:: ------------------------------------------------------------
set "ADB_DIR=%~dp0platform-tools-latest-windows"
set "PATH=%ADB_DIR%;%PATH%"

echo.
echo ----------------------------------------------------
echo ACTIVE PATH CONFIGURED TO: %ADB_DIR%
echo ----------------------------------------------------


:: ------------------------------------------------------------
:: STEP 5: VERIFY PHONE CONNECTION STATUS
:: ------------------------------------------------------------
echo Checking for connected Android devices via USB...
adb.exe devices
echo.
echo NOTE: Check your phone's screen right now.
echo If it asks to "Allow USB debugging?", check "Always allow" and press OK.
echo.
pause


:: ------------------------------------------------------------
:: FIX 1 OF 3: DISABLE WI-FI "SWITCH TO MOBILE DATA" (SAMSUNG)
:: ------------------------------------------------------------
echo.
echo Disabling Wi-Fi "Switch to Mobile Data" (Intelligent Wi-Fi)...
echo This prevents your phone from abandoning cellular data when it
echo detects a weak or phantom Wi-Fi signal (e.g., from the car dash).
echo.

:: Disable the Wi-Fi watchdog that silently drops cellular when Wi-Fi appears poor
adb.exe shell settings put global wifi_watchdog_on 0

:: Disable the "Switch to Mobile Data" toggle under Samsung Intelligent Wi-Fi
adb.exe shell settings put global wifi_switch_to_cell 0

echo.
echo ----------------------------------------------------
echo FIX 1 APPLIED: Wi-Fi mobile data auto-switching disabled.
echo ----------------------------------------------------
echo.
pause


:: ------------------------------------------------------------
:: FIX 2 OF 3: FORCE "ALWAYS ALLOW" LOCATION PERMISSIONS FOR LYFT
:: ------------------------------------------------------------
echo.
echo Applying "Allow all the time" location rules to Lyft Driver...
echo.

:: Grant Fine (Precise) Foreground Location
adb.exe shell pm grant me.lyft.driver android.permission.ACCESS_FINE_LOCATION

:: Grant Coarse (Approximate) Foreground Location
adb.exe shell pm grant me.lyft.driver android.permission.ACCESS_COARSE_LOCATION

:: Grant Background Location (forces the "Allow all the time" flag)
adb.exe shell pm grant me.lyft.driver android.permission.ACCESS_BACKGROUND_LOCATION

echo.
echo ----------------------------------------------------
echo FIX 2 APPLIED: Lyft background location permissions granted.
echo ----------------------------------------------------
echo.
pause


:: ------------------------------------------------------------
:: FIX 3 OF 3: DISABLE PRECISE LOCATION FOR ANDROID AUTO
:: ------------------------------------------------------------
echo.
echo Disabling "Use precise location" for Android Auto...
echo This forces Android Auto to rely on cell-tower location only,
echo preventing the Nissan Sentra's hardware GPS chip from conflicting
echo with Lyft's location detection.
echo.

:: Revoke fine (GPS/precise) location from Android Auto
:: -- leaves only coarse (cell-tower) location active
adb.exe shell pm revoke com.google.android.projection.gearhead android.permission.ACCESS_FINE_LOCATION

echo.
echo ----------------------------------------------------
echo FIX 3 APPLIED: Android Auto precise location disabled.
echo ----------------------------------------------------
echo.
pause


:: ------------------------------------------------------------
:: STEP 7: VERIFY ALL 3 FIXES WERE APPLIED SUCCESSFULLY
:: ------------------------------------------------------------
echo.
echo ============================================================
echo   VERIFICATION -- REVIEW EACH RESULT BELOW:
echo ============================================================
echo.
echo [CHECK 1] Wi-Fi "Switch to Mobile Data" -- both values should read: 0
echo ----------------------------------------------------
adb.exe shell settings get global wifi_watchdog_on
adb.exe shell settings get global wifi_switch_to_cell
echo.

echo [CHECK 2] Lyft background location -- look for: granted=true
echo ----------------------------------------------------
adb.exe shell dumpsys package me.lyft.driver | findstr /i "BACKGROUND_LOCATION"
echo.

echo [CHECK 3] Android Auto precise location -- look for: granted=false
echo ----------------------------------------------------
adb.exe shell dumpsys package com.google.android.projection.gearhead | findstr /i "ACCESS_FINE_LOCATION"
echo.
echo ============================================================
echo   If any result looks incorrect, re-run this script or
echo   apply that fix manually in phone Settings.
echo   (See README.md in this folder for full troubleshooting.)
echo ============================================================
echo.
pause


:: ------------------------------------------------------------
:: STEP 8: SAFELY CLOSE THE ADB CONNECTION
:: ------------------------------------------------------------
echo.
echo Terminating the ADB server and releasing your phone...
echo.
echo NOTE: Unlike USB flash drives, Android phones connected via ADB
echo do NOT require a formal "safe removal" step. The phone can be
echo unplugged at any time without risk to your data or device.
echo Stopping the ADB server simply closes the software connection cleanly.
echo.
adb.exe kill-server
echo.
echo ADB server stopped. Your phone has been released.


:: ------------------------------------------------------------
:: STEP 9: CLEAN UP -- REMOVE DOWNLOADED PLATFORM TOOLS
:: ------------------------------------------------------------
echo.
echo Removing the platform tools folder and all its contents...

if exist "%~dp0platform-tools-latest-windows\" (
    rd /s /q "%~dp0platform-tools-latest-windows"
)

:: Remove ZIP file if somehow still present
if exist "%~dp0platform-tools-latest-windows.zip" (
    del /q "%~dp0platform-tools-latest-windows.zip"
)

echo Platform tools removed. Your directory is clean.
echo.
echo ============================================================
echo   ALL 3 FIXES APPLIED, VERIFIED, AND COMPLETE.
echo   Platform tools have been removed from this folder.
echo   You may safely unplug your phone and close this window.
echo ============================================================
pause
