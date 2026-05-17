# Lyft Driver App — Android Auto: 3-Step Glitch Fix (Nissan Glitch)
### Lyft > Nissan Display > Android Auto Glitch Repair Automated Script

Automatically patches three known issues on Samsung Android phones that cause the **Lyft Driver** app to lose background location or drop GPS while connected to Nissan vehicles — all via USB using Google's official **Android Debug Bridge (ADB)** tool. No rooting, no unlocking, no manual downloads, and no manual Settings navigation required. Just plug in your phone and run the script.

---

## Table of Contents

- [Available Scripts](#available-scripts)
- [What This Script Does](#what-this-script-does)
- [Prerequisites](#prerequisites)
- [Step-by-Step Instructions](#step-by-step-instructions)
- [Understanding the Verification Output](#understanding-the-verification-output)
- [Common Errors & Troubleshooting](#common-errors--troubleshooting)
- [Notes & Caveats](#notes--caveats)

---

## What This Script Does

| # | Fix | Why It Helps |
|---|-----|--------------|
| **1** | **Disable Wi-Fi "Switch to Mobile Data"** | Stops Samsung's Intelligent Wi-Fi from silently abandoning your cellular data when it detects the car's weak dash Wi-Fi signal |
| **2** | **Force Lyft to "Allow all the time" location** | Grants all three location permissions (fine, coarse, and background) so Lyft can never be silently downgraded to "While using the app" |
| **3** | **Disable precise GPS for Android Auto** | Forces Android Auto to use cell-tower location instead of the Nissan's hardware GPS chip, preventing signal conflicts with Lyft's positioning |

> All three fixes are applied automatically in sequence. The script then **verifies** each fix was successful before exiting.

---

## Available Scripts

| Platform | Script | Folder |
|----------|--------|--------|
| **Windows 10 / 11** | `Fix_Lyft_Background_Location.bat` | `Win10_Win11/` |
| **Linux / Bash** | `Fix_Lyft_Background_Location.sh` | `Linux_Bash/` |

> Both scripts perform identical fixes. Choose the one that matches your operating system.

---

## Prerequisites

You will need **all** of the following before running the script.

### 1 — Android Platform Tools *(downloaded automatically)*

**No action required.** The script automatically downloads (~11 MB) and extracts the correct platform tools for your OS directly from Google the first time it runs.

| Platform | Download URL |
|----------|--------------|
| **Windows** | `https://dl.google.com/android/repository/platform-tools-latest-windows.zip` |
| **Linux** | `https://dl.google.com/android/repository/platform-tools-latest-linux.zip` |

- The tools are downloaded next to the script, used for the fixes, and **deleted automatically** when the script finishes — your folder stays clean
- If the tools folder is already present, the download step is skipped
- Requires an **active internet connection** on first run
- **Linux only:** requires `curl` and `unzip` to be installed (see Troubleshooting if either is missing)

> **Antivirus warning (Windows):** Some antivirus programs flag ADB executables as potentially unwanted software.
> If `adb.exe` is blocked or quarantined after extraction, add the `platform-tools-latest-windows\`
> folder to your antivirus exclusion list and re-run the script — the tools will re-download automatically.

---

### 2 — A Data-Capable USB Cable

- **Charge-only** cables carry power but no data signal — they will not work
- Use the cable that came with your phone, or any USB cable explicitly rated for **data transfer**
- If the script shows no device detected, try a different cable first

---

### 3 — Developer Options (must be enabled on your phone)

1. Go to **Settings › About Phone › Software Information**
2. Tap **Build Number** 7 times in rapid succession
3. Your phone will display: *"You are now a developer!"*

> **Doesn't work?** On some Samsung models, **Build Number** is located directly under
> **Settings › About Phone** rather than in Software Information. If it still doesn't respond,
> search Google for your exact model number + *"enable Developer Options"*.

---

### 4 — USB Debugging (must be enabled on your phone)

1. Go to **Settings › Developer Options**
2. Toggle **USB Debugging** to **ON**

---

## Step-by-Step Instructions

### 🖥️ Windows 10 / 11

1. Open the `Win10_Win11\` folder and **double-click** `Fix_Lyft_Background_Location.bat`
   - If a *"Windows protected your PC"* SmartScreen prompt appears, click **More info → Run anyway**
   - This warning appears because the file is unsigned, not because it is unsafe
2. The script **automatically downloads** the Android Platform Tools (~11 MB) if not already present — wait for the download and extraction to complete
3. Read the on-screen phone prep checklist and confirm your phone is ready
4. **Connect your phone to your PC via USB**
5. **On your phone's screen:** when the *"Allow USB debugging?"* dialog appears —
   - Check **"Always allow from this computer"**
   - Tap **OK**
6. Press any key to begin — all 3 fixes run automatically, one at a time
7. After each fix, the script pauses so you can review the output before continuing
8. After Fix 3, automatic **verification checks** run — review the results on screen
9. Press any key to exit — the ADB server stops and the platform tools folder is deleted automatically

---

### 🐧 Linux / Bash

1. Open a terminal and navigate to the `Linux_Bash/` folder:
   ```bash
   cd Linux_Bash
   ```
2. Make the script executable *(first run only)*:
   ```bash
   chmod +x Fix_Lyft_Background_Location.sh
   ```
3. Run the script:
   ```bash
   ./Fix_Lyft_Background_Location.sh
   ```
4. The script **automatically downloads** the Android Platform Tools (~11 MB) if not already present — wait for the download and extraction to complete
5. Read the on-screen phone prep checklist and confirm your phone is ready
6. **Connect your phone to your PC via USB**
7. **On your phone's screen:** when the *"Allow USB debugging?"* dialog appears —
   - Check **"Always allow from this computer"**
   - Tap **OK**
8. Press **Enter** to begin — all 3 fixes run automatically, one at a time
9. After each fix, the script pauses so you can review the output before continuing
10. After Fix 3, automatic **verification checks** run — review the results on screen
11. Press **Enter** to exit — the ADB server stops and the platform tools folder is deleted automatically

> ⚠️ **Do not unplug your phone during the script.** Wait for the final *"safe to unplug"* message.

---

## Understanding the Verification Output

After all 3 fixes are applied, the script queries your phone directly to confirm each change stuck.

### Check 1 — Wi-Fi Settings
Both lines should display `0`:
```
0
0
```
- `0` = setting is **disabled** ✓
- `1` = setting is still **enabled** — apply Fix 1 manually (see Troubleshooting)
- `null` = your firmware doesn't use this key — apply Fix 1 manually (see Troubleshooting)

---

### Check 2 — Lyft Background Location
Look for `granted=true`:
```
android.permission.ACCESS_BACKGROUND_LOCATION: granted=true
```
- `granted=true` = permission is active ✓
- `granted=false` or **no output** = the permission did not apply — re-run the script

---

### Check 3 — Android Auto Precise Location
Look for `granted=false`:
```
android.permission.ACCESS_FINE_LOCATION: granted=false
```
- `granted=false` = precise GPS is revoked ✓
- `granted=true` = the permission was not revoked — apply Fix 3 manually (see Troubleshooting)

---

## Common Errors & Troubleshooting

### ❌ `Permission denied` when running the script *(Linux only)*
**The script file is not marked as executable.**
- Run: `chmod +x Fix_Lyft_Background_Location.sh`
- Then launch with: `./Fix_Lyft_Background_Location.sh`

---

### ❌ `unzip: command not found` *(Linux only)*
**The `unzip` utility is not installed on your system.**
- Install it with your package manager:
  - Ubuntu / Debian: `sudo apt install unzip`
  - Fedora / RHEL: `sudo dnf install unzip`
  - Arch: `sudo pacman -S unzip`
- Re-run the script after installing

---

### ❌ `curl: command not found` *(Linux only)*
**The `curl` utility is not installed on your system.**
- Install it with your package manager:
  - Ubuntu / Debian: `sudo apt install curl`
  - Fedora / RHEL: `sudo dnf install curl`
  - Arch: `sudo pacman -S curl`
- Re-run the script after installing

---

### ❌ Download fails — *"The download failed"*
**The script could not retrieve the platform tools ZIP from Google.**
- Confirm your PC has an active internet connection
- A corporate firewall, VPN, or proxy may be blocking `dl.google.com` — try disabling it temporarily and re-running
- As a fallback: download manually from `https://developer.android.com/tools/releases/platform-tools`, extract the ZIP, rename the extracted folder to `platform-tools-latest-windows`, place it next to the batch file, and re-run

---

### ❌ Extraction fails — *"Extraction failed"*
**The downloaded ZIP could not be extracted.**
- The download may have been interrupted, producing an incomplete file — delete `platform-tools-latest-windows.zip` from the script's folder (if present) and re-run
- Ensure you have at least 50 MB of free disk space on the drive
- Antivirus software may have interfered mid-extraction — see the Antivirus entry below

---

### ❌ "no devices/emulators found"
**The phone was not detected.**
- Ensure **USB Debugging** is enabled on the phone
- Try a different USB cable (data cable, not charge-only)
- Try a different USB port on your PC
- Make sure your phone screen is **unlocked**
- Disconnect and reconnect the USB cable, then re-run the script

---

### ❌ Device shows as "unauthorized"
**The phone is waiting for you to approve the connection.**
- Check your phone's screen — tap **Allow USB debugging**
- Check **"Always allow from this computer"** so it doesn't ask again
- If the dialog already dismissed, unplug and replug the cable to trigger it again

---

### ❌ `pm grant` fails / security exception on Fix 2
**The Lyft Driver app may not be installed, or has a different package name.**
- Confirm the **Lyft Driver** app is installed — the package `me.lyft.driver` is the **driver** app only
- The regular **Lyft rider** app uses a different package name and is not affected by this script
- If you uninstalled and reinstalled Lyft Driver recently, make sure it fully installed before running

---

### ❌ `pm revoke` fails / no output on Fix 3
**Android Auto may not be installed, or the permission was already revoked.**
- This is not a critical error — if the permission is already revoked, Fix 3 is already in effect
- If Android Auto is not installed, skip this fix entirely — it does not apply
- To apply manually: **Settings › Apps › Android Auto › Permissions › Location › toggle off "Use precise location"**

---

### ⚠️ Check 1 shows `null` instead of `0`
**Your Samsung firmware version does not use these specific settings keys.**
- The script ran without error, but Fix 1 may not have taken effect via ADB on your device
- **Manual fix (permanent):** Settings › Connections › Wi-Fi › ⋮ (three dots) › Advanced **or** Intelligent Wi-Fi › toggle **Switch to Mobile Data** to **OFF**
- This manual toggle persists across reboots

---

### ⚠️ Check 1 shows `0` now but resets to `1` after a reboot
**Samsung firmware restores certain global settings on reboot.**
- Disable "Switch to Mobile Data" manually using the steps above — that setting is stored differently and will persist

---

### ❌ "error: more than one device/emulator"
**More than one Android device is connected via USB.**
- Unplug all other USB-connected Android devices
- Run the script again with only your Lyft phone connected

---

### ❌ Antivirus deleted or blocked `adb.exe`
**The antivirus quarantined the ADB executables during extraction.**
- Open your antivirus settings and add the `platform-tools-latest-windows\` folder to the **exclusion / whitelist**
- Re-run the script — the tools will be **re-downloaded and extracted automatically**

---

### ⚠️ Fixes reset after a Lyft Driver app update
**App updates can revert runtime permissions back to their install-time defaults.**
- This is normal Android behavior — no data is lost
- Simply **re-run this script** after any Lyft Driver app update

---

### ⚠️ Running on Android 9 or older
**`ACCESS_BACKGROUND_LOCATION` as a separate permission only exists on Android 10+.**
- On Android 9 and older, the `pm grant` command for background location will fail silently or with an error
- **Manual fix:** Settings › Apps › Lyft › Permissions › Location › set to **"Allow all the time"**

---

### ⚠️ ADB connection drops mid-script
**The USB connection was interrupted while a command was running.**
- This can happen if the cable is jostled, the phone locks its screen, or the phone prompts for a notification
- Re-run the script from the beginning — all fixes are safe to apply more than once

---

## Notes & Caveats

**Safe to unplug after the script?**
Yes. Android phones connected via ADB do **not** require a "safely remove hardware" step the way USB flash drives do. ADB is a debugging protocol — it does not mount the phone as a file system. The script stops the ADB server cleanly via `adb kill-server`, but physically unplugging the cable at any point is safe for your phone and data.

---

**Are the platform tools cleaned up after the script?**
Yes. After the script completes, the platform tools folder and all its contents are **automatically deleted** — no manual cleanup needed:

- **Windows:** `platform-tools-latest-windows\`
- **Linux:** `platform-tools-latest-linux/` (contains `platform-tools/adb` inside)

If you re-run the script in the future, the tools are re-downloaded automatically.

---

**Do the fixes survive a reboot?**
| Fix | Survives Reboot? |
|-----|-----------------|
| Fix 1 — Wi-Fi switch setting | **Maybe** — depends on Samsung firmware; disable manually in Settings for guaranteed persistence |
| Fix 2 — Lyft location permissions | **Yes** — persists until Lyft Driver is updated or reinstalled |
| Fix 3 — Android Auto location | **Yes** — persists until Android Auto is updated or reinstalled |

---

**Does this affect the regular Lyft rider app?**
No. Fix 2 only targets the package `me.lyft.driver` (Lyft Driver app). The consumer Lyft rider app is a separate package and is untouched.

---

**Does this require root access?**
No. All three fixes use standard Android permission management over ADB — Google's official developer toolset that ships built-in on every Android phone. No rooting, no bootloader unlocking, no custom recovery required.

---

**Does this void my warranty?**
No. Enabling Developer Options and USB Debugging is a standard, documented Android feature. Using ADB to modify app permissions is within normal developer use. These changes can all be reversed manually through Settings.

---

*Available for Windows (`Win10_Win11/Fix_Lyft_Background_Location.bat`) and Linux (`Linux_Bash/Fix_Lyft_Background_Location.sh`) — platform tools are downloaded automatically (~11 MB, requires internet on first run); compatible with Samsung Galaxy phones running Android 10 or newer.*
