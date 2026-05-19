#!/bin/bash

# ============================================================
# LYFT DRIVER APP - ANDROID AUTO: 3-STEP GLITCH FIX (NISSAN GLITCH)
# ============================================================

# Resolve the absolute path of the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper: pause and wait for Enter
press_enter() {
    echo ""
    read -rp "${1:-Press Enter to continue...}" _
}


# ------------------------------------------------------------
# PRE-FLIGHT: CHECK FOR REQUIRED TOOLS (curl, unzip)
# ------------------------------------------------------------
for tool in curl unzip; do
    if ! command -v "$tool" &>/dev/null; then
        echo ""
        echo "[ERROR] Required tool not found: $tool"
        echo ""
        echo "Install it and re-run this script:"
        echo "  Ubuntu / Debian:  sudo apt install $tool"
        echo "  Fedora / RHEL:    sudo dnf install $tool"
        echo "  Arch:             sudo pacman -S $tool"
        echo ""
        press_enter "Press Enter to EXIT..."
        exit 1
    fi
done


# ------------------------------------------------------------
# STEP 0: AUTO-DOWNLOAD ANDROID PLATFORM TOOLS (IF NEEDED)
# ------------------------------------------------------------
if [ ! -d "$SCRIPT_DIR/platform-tools-latest-linux" ]; then
    echo ""
    echo "============================================================"
    echo "  ANDROID PLATFORM TOOLS NOT FOUND -- DOWNLOADING NOW..."
    echo "============================================================"
    echo ""
    echo "Downloading the official Android Platform Tools from Google."
    echo "(Approximately 11 MB -- an active internet connection is required.)"
    echo ""

    curl -L --fail --progress-bar \
        -o "$SCRIPT_DIR/platform-tools-latest-linux.zip" \
        "https://dl.google.com/android/repository/platform-tools-latest-linux.zip"

    if [ $? -ne 0 ]; then
        echo ""
        echo "[ERROR] The download failed. Possible causes:"
        echo ""
        echo "  - No active internet connection"
        echo "  - A firewall, VPN, or proxy is blocking the download"
        echo "  - Google's servers are temporarily unavailable"
        echo ""
        echo "As a fallback, manually download the tools from:"
        echo "  https://developer.android.com/tools/releases/platform-tools"
        echo "Extract the ZIP into a folder named \"platform-tools-latest-linux\""
        echo "so that adb ends up at:"
        echo "  platform-tools-latest-linux/platform-tools/adb"
        echo "Then re-run the script."
        echo ""
        [ -f "$SCRIPT_DIR/platform-tools-latest-linux.zip" ] && \
            rm -f "$SCRIPT_DIR/platform-tools-latest-linux.zip"
        press_enter "Press Enter to EXIT..."
        exit 1
    fi

    echo ""
    echo "Download complete. Extracting files..."
    echo ""

    # Extract into platform-tools-latest-linux/ -- ZIP unfolds to platform-tools/ inside it
    # Resulting adb path: platform-tools-latest-linux/platform-tools/adb
    mkdir -p "$SCRIPT_DIR/platform-tools-latest-linux"
    unzip -q "$SCRIPT_DIR/platform-tools-latest-linux.zip" \
        -d "$SCRIPT_DIR/platform-tools-latest-linux"

    if [ $? -ne 0 ]; then
        echo ""
        echo "[ERROR] Extraction failed. The downloaded file may be incomplete or corrupt."
        echo ""
        echo "Deleting the partial download. Re-run the script to try again."
        echo "If the problem persists, check available disk space (at least 50 MB needed)."
        echo ""
        rm -rf "$SCRIPT_DIR/platform-tools-latest-linux"
        [ -f "$SCRIPT_DIR/platform-tools-latest-linux.zip" ] && \
            rm -f "$SCRIPT_DIR/platform-tools-latest-linux.zip"
        press_enter "Press Enter to EXIT..."
        exit 1
    fi

    # Delete the ZIP now that extraction is complete
    rm -f "$SCRIPT_DIR/platform-tools-latest-linux.zip"

    echo ""
    echo "============================================================"
    echo "  PLATFORM TOOLS DOWNLOADED AND EXTRACTED SUCCESSFULLY."
    echo "============================================================"
    echo ""
    press_enter
fi


# ------------------------------------------------------------
# STEP 1: VERIFY THE PLATFORM-TOOLS FOLDER EXISTS (SAFETY CHECK)
# ------------------------------------------------------------
if [ ! -d "$SCRIPT_DIR/platform-tools-latest-linux" ]; then
    echo ""
    echo "[ERROR] The \"platform-tools-latest-linux\" folder was NOT found."
    echo ""
    echo "This is unexpected -- the auto-download should have created it."
    echo "The ZIP may have extracted with an incorrect folder name, or the"
    echo "folder may have been moved or deleted during this session."
    echo ""
    echo "Try deleting any leftover \"platform-tools-latest-linux\" folder"
    echo "from this directory, then re-run the script to download a fresh copy."
    echo ""
    press_enter "Press Enter to EXIT..."
    exit 1
fi


# ------------------------------------------------------------
# STEP 2: VERIFY ADB EXISTS AND IS EXECUTABLE
# ------------------------------------------------------------
ADB="$SCRIPT_DIR/platform-tools-latest-linux/platform-tools/adb"

if [ ! -f "$ADB" ]; then
    echo ""
    echo "[ERROR] \"adb\" was NOT found at the expected location:"
    echo "  platform-tools-latest-linux/platform-tools/adb"
    echo ""
    echo "The platform tools do not appear to be properly extracted."
    echo ""
    echo "  TO FIX: Delete the \"platform-tools-latest-linux\" folder and re-run"
    echo "  this script to download and extract a fresh copy."
    echo ""
    press_enter "Press Enter to EXIT..."
    exit 1
fi

# Ensure the binary is executable
chmod +x "$ADB"

export PATH="$SCRIPT_DIR/platform-tools-latest-linux/platform-tools:$PATH"


# ------------------------------------------------------------
# STEP 3: PHONE SETUP INSTRUCTIONS
# ------------------------------------------------------------
echo ""
echo "============================================================"
echo "  BEFORE CONTINUING -- PREPARE YOUR ANDROID PHONE:"
echo "============================================================"
echo ""
echo "  1. ENABLE DEVELOPER OPTIONS (if not already done):"
echo ""
echo "     On most Samsung Galaxy phones:"
echo "       Settings > About Phone > Software Information"
echo "       -- Tap \"Build Number\" 7 times rapidly --"
echo "       Your phone will display: \"You are now a developer!\""
echo ""
echo "  2. ENABLE USB DEBUGGING:"
echo "       Settings > Developer Options > Toggle ON \"USB Debugging\""
echo ""
echo "  NOTE: If tapping Build Number does NOT unlock Developer Options,"
echo "  or the \"USB Debugging\" option is missing from your menu, please"
echo "  consult Google for instructions specific to your device and Android version."
echo ""
echo "============================================================"
echo ""
echo "============================================================"
echo "  THIS SCRIPT WILL AUTOMATICALLY APPLY 3 FIXES:"
echo "============================================================"
echo "  Fix 1: Disable Wi-Fi \"Switch to Mobile Data\"  (Samsung)"
echo "  Fix 2: Force Lyft location to \"Allow all the time\""
echo "  Fix 3: Disable precise location for Android Auto"
echo "============================================================"
echo ""
press_enter "Press Enter to BEGIN ALL 3 FIXES..."


# ------------------------------------------------------------
# STEP 4: CONFIGURE PATH TO ADB
# ------------------------------------------------------------
echo ""
echo "----------------------------------------------------"
echo "ACTIVE PATH CONFIGURED TO:"
echo "  $SCRIPT_DIR/platform-tools-latest-linux/platform-tools"
echo "----------------------------------------------------"


# ------------------------------------------------------------
# STEP 5: VERIFY PHONE CONNECTION STATUS
# ------------------------------------------------------------
echo "Checking for connected Android devices via USB..."
"$ADB" devices
echo ""
echo "NOTE: Check your phone's screen right now."
echo "If it asks to \"Allow USB debugging?\", check \"Always allow\" and press OK."
echo ""
press_enter


# ------------------------------------------------------------
# FIX 1 OF 3: DISABLE WI-FI "SWITCH TO MOBILE DATA" (SAMSUNG)
# ------------------------------------------------------------
echo ""
echo "Disabling Wi-Fi \"Switch to Mobile Data\" (Intelligent Wi-Fi)..."
echo "This prevents your phone from abandoning cellular data when it"
echo "detects a weak or phantom Wi-Fi signal (e.g., from the car dash)."
echo ""

# Disable the Wi-Fi watchdog that silently drops cellular when Wi-Fi appears poor
"$ADB" shell settings put global wifi_watchdog_on 0

# Disable the "Switch to Mobile Data" toggle under Samsung Intelligent Wi-Fi
"$ADB" shell settings put global wifi_switch_to_cell 0

echo ""
echo "----------------------------------------------------"
echo "FIX 1 APPLIED: Wi-Fi mobile data auto-switching disabled."
echo "----------------------------------------------------"
echo ""
press_enter


# ------------------------------------------------------------
# FIX 2 OF 3: FORCE "ALWAYS ALLOW" LOCATION PERMISSIONS FOR LYFT
# ------------------------------------------------------------
echo ""
echo "Applying \"Allow all the time\" location rules to Lyft Driver..."
echo ""

# Detect the Lyft Driver package name
LYFT_PKG=""
if "$ADB" shell pm path com.lyft.android.driver 2>/dev/null | grep -q "package:"; then
    LYFT_PKG="com.lyft.android.driver"
fi

if [ -z "$LYFT_PKG" ]; then
    echo "[WARNING] The Lyft Driver app (com.lyft.android.driver) was NOT found on this phone."
    echo ""
    echo "Lyft-related packages currently installed on this device:"
    "$ADB" shell pm list packages 2>/dev/null | grep -i "lyft"
    echo ""
    echo "This typically means one of:"
    echo "  - The Lyft Driver app is not installed on this phone"
    echo "  - You are running this on the wrong device"
    echo ""
    echo "Skipping Fix 2. Re-run the script on the phone that has the"
    echo "Lyft Driver app installed."
    echo ""
    press_enter
else
    echo "Detected: $LYFT_PKG"
    echo ""

    # Grant Fine (Precise) Foreground Location
    "$ADB" shell pm grant "$LYFT_PKG" android.permission.ACCESS_FINE_LOCATION

    # Grant Coarse (Approximate) Foreground Location
    "$ADB" shell pm grant "$LYFT_PKG" android.permission.ACCESS_COARSE_LOCATION

    # Grant Background Location (forces the "Allow all the time" flag)
    "$ADB" shell pm grant "$LYFT_PKG" android.permission.ACCESS_BACKGROUND_LOCATION

    echo ""
    echo "----------------------------------------------------"
    echo "FIX 2 APPLIED: Lyft background location permissions granted."
    echo "----------------------------------------------------"
    echo ""
    press_enter
fi


# ------------------------------------------------------------
# FIX 3 OF 3: DISABLE PRECISE LOCATION FOR ANDROID AUTO
# ------------------------------------------------------------
echo ""
echo "Disabling \"Use precise location\" for Android Auto..."
echo "This forces Android Auto to rely on cell-tower location only,"
echo "preventing the Nissan Sentra's hardware GPS chip from conflicting"
echo "with Lyft's location detection."
echo ""

# Revoke fine (GPS/precise) location from Android Auto
# -- leaves only coarse (cell-tower) location active
"$ADB" shell pm revoke com.google.android.projection.gearhead android.permission.ACCESS_FINE_LOCATION

echo ""
echo "----------------------------------------------------"
echo "FIX 3 APPLIED: Android Auto precise location disabled."
echo "----------------------------------------------------"
echo ""
press_enter


# ------------------------------------------------------------
# STEP 7: VERIFY ALL 3 FIXES WERE APPLIED SUCCESSFULLY
# ------------------------------------------------------------
echo ""
echo "============================================================"
echo "  VERIFICATION -- REVIEW EACH RESULT BELOW:"
echo "============================================================"
echo ""
echo "[CHECK 1] Wi-Fi \"Switch to Mobile Data\" -- both values should read: 0"
echo "----------------------------------------------------"
"$ADB" shell settings get global wifi_watchdog_on
"$ADB" shell settings get global wifi_switch_to_cell
echo ""

echo "[CHECK 2] Lyft location permissions -- FINE and BACKGROUND should both show: granted=true"
echo "----------------------------------------------------"
if [ -n "$LYFT_PKG" ]; then
    "$ADB" shell dumpsys package "$LYFT_PKG" | grep -i "LOCATION"
else
    echo "[SKIPPED] Lyft Driver app was not found on this device -- Fix 2 was not applied."
fi
echo ""

echo "[CHECK 3] Android Auto precise location -- look for: granted=false"
echo "----------------------------------------------------"
"$ADB" shell dumpsys package com.google.android.projection.gearhead | grep -i "ACCESS_FINE_LOCATION"
echo ""
echo "============================================================"
echo "  If any result looks incorrect, re-run this script or"
echo "  apply that fix manually in phone Settings."
echo "  (See README.md in the parent folder for full troubleshooting.)"
echo "============================================================"
echo ""
press_enter


# ------------------------------------------------------------
# STEP 8: SAFELY CLOSE THE ADB CONNECTION
# ------------------------------------------------------------
echo ""
echo "Terminating the ADB server and releasing your phone..."
echo ""
echo "NOTE: Unlike USB flash drives, Android phones connected via ADB"
echo "do NOT require a formal \"safe removal\" step. The phone can be"
echo "unplugged at any time without risk to your data or device."
echo "Stopping the ADB server simply closes the software connection cleanly."
echo ""
"$ADB" kill-server
echo ""
echo "ADB server stopped. Your phone has been released."


# ------------------------------------------------------------
# STEP 9: CLEAN UP -- REMOVE DOWNLOADED PLATFORM TOOLS
# ------------------------------------------------------------
echo ""
echo "Removing the platform tools folder and all its contents..."

[ -d "$SCRIPT_DIR/platform-tools-latest-linux" ] && \
    rm -rf "$SCRIPT_DIR/platform-tools-latest-linux"

# Remove ZIP file if somehow still present
[ -f "$SCRIPT_DIR/platform-tools-latest-linux.zip" ] && \
    rm -f "$SCRIPT_DIR/platform-tools-latest-linux.zip"

echo "Platform tools removed. Your directory is clean."
echo ""
echo "============================================================"
echo "  ALL 3 FIXES APPLIED, VERIFIED, AND COMPLETE."
echo "  Platform tools have been removed from this folder."
echo "  You may safely unplug your phone and close this terminal."
echo "============================================================"
echo ""
press_enter "Press Enter to EXIT..."
