# Quick Start — macOS
### Lyft Driver App · Android Auto · Nissan Glitch Fix

> Originally identified on **Nissan vehicles** — applicable to **any vehicle that uses Android Auto**.

---

## About This Fix — Which Devices Are Affected?

This fix was originally identified on **Nissan vehicles** — though the same issue can occur on **any vehicle that uses Android Auto**. It was also first documented for **Samsung Galaxy phones**, and that remains the most common hardware scenario. The three issues this script corrects (Samsung's Wi-Fi switching behavior, Lyft's background location being silently revoked, and Android Auto's GPS interference) appear most frequently on Samsung Galaxy hardware.

**However, you do not have to be using a Samsung phone for this to apply to you.**
Other Android phones — including Google Pixel, Motorola, and OnePlus devices — have exhibited the exact same GPS drop and background location loss symptoms when paired with a Nissan vehicle through Android Auto. If your phone isn't a Samsung but you're seeing the same problems, these fixes are worth running; the underlying ADB commands work identically across all Android phones.

**You also do not need to be driving a Nissan.** The same GPS drop and background location loss symptoms can occur on any vehicle that uses Android Auto. If you are seeing these problems with a non-Nissan vehicle, these fixes apply equally.

---

## Before You Begin — Phone Setup

The script communicates with your phone over USB using Android Debug Bridge (ADB). Before that connection is possible, two things must be enabled on your phone: **Developer Options** and **USB Debugging**. Neither is enabled by default.

### Part A — Unlock Developer Options

Developer Options is a hidden settings menu built into every Android phone. It must be unlocked before USB Debugging can be turned on.

**On Samsung Galaxy phones:**
1. Open **Settings**
2. Tap **About Phone**
3. Tap **Software Information**
4. Find **Build Number** and **tap it 7 times rapidly**
   - Around tap 4 your phone shows a countdown: *"You are 3 steps away from being a developer"*
   - After tap 7: **"You are now a developer!"** — you're done
5. If prompted, enter your PIN, pattern, or fingerprint to confirm

> Developer Options will now appear as a new entry in your main Settings list.
> On some Samsung models it shows up under **Settings › General Management** instead.

**On other Android phones** — the path to Build Number varies slightly:

| Device | Where to find Build Number |
|--------|----------------------------|
| **Google Pixel** | Settings › About Phone › **Build Number** |
| **Motorola** | Settings › About Phone › **Build Number** |
| **OnePlus** | Settings › About Phone › Version › **Build Number** |
| **LG** | Settings › About Phone › Software Info › **Build Number** |
| **Any Android 10+** | Settings › About Phone › **Build Number** |

On all of these: **tap Build Number 7 times** and watch for the *"You are now a developer!"* message.

**Build Number tapping isn't working?** Try these before giving up:
- Make sure you're tapping the **Build Number** line specifically — not the Android version, kernel version, or baseband version lines nearby
- Tap at a steady, rapid pace — not too slow, not too fast
- Some devices require you to **tap and hold** the last tap rather than a quick tap
- A small number of heavily carrier-modified firmware builds hide Developer Options differently — if none of the above works, search Google for your **exact model number + "enable developer options"** for a device-specific walkthrough

---

### Part B — Enable USB Debugging

Once Developer Options is unlocked:

1. Go back to the main **Settings** screen
2. Scroll down and tap **Developer Options**
   > On some Samsung models this appears under **Settings › General Management › Developer Options**
3. Scroll down inside Developer Options until you find **USB Debugging**
4. Toggle **USB Debugging** to **ON**
5. A dialog will appear asking *"Allow USB debugging?"* — tap **OK**

> USB Debugging stays on until you manually disable it or factory reset your phone.
> You only need to do this once.

---

### If Your Device Cannot Enable Developer Options or USB Debugging

This is uncommon, but some carrier-locked or enterprise-managed phones permanently block access to Developer Options regardless of the method used. If you've tried every approach above and Developer Options still will not unlock:

- Search Google for: **[your phone model] + "enable developer options" + [your Android version]**
- Check your device manufacturer's official support site
- Devices enrolled in a corporate or MDM (Mobile Device Management) profile may have Developer Options permanently disabled by policy — if this applies, USB Debugging cannot be enabled and **this script will not be able to run on that specific device**

**Once USB Debugging is successfully enabled**, return to the top of this guide and run the script from the beginning — it is completely safe to run more than once.

---

## What You Need Before Starting

| Requirement | Details |
|-------------|---------|
| **macOS 10.15 (Catalina) or newer** | `curl` and `unzip` are pre-installed |
| **Samsung Android phone** | Running Android 10 or newer |
| **Data-capable USB cable** | Not a charge-only cable |
| **Developer Options enabled** | Settings › About Phone › Software Information › tap **Build Number** 7 times |
| **USB Debugging enabled** | Settings › Developer Options › toggle **USB Debugging** ON |
| **Active internet connection** | Required on first run to download ADB tools (~11 MB) |

> **Note:** `curl` and `unzip` ship pre-installed with macOS. No package installation is required. If either is missing on your system, install via [Homebrew](https://brew.sh): `brew install curl unzip`

---

## Run the Script

1. **Open Terminal** — press `⌘ + Space`, type **Terminal**, press **Return**

2. **Navigate to this folder:**
   ```bash
   cd Mac_Bash
   ```
   *(If you downloaded the repo to your Desktop: `cd ~/Desktop/Lyft-AndroidAuto-Nissan-Fix/Mac_Bash`)*

3. **Make the script executable** *(first run only)*:
   ```bash
   chmod +x LyftDriver-AndroidAuto-Nissan-Glitch-Fix.sh
   ```

4. **Run the script:**
   ```bash
   ./LyftDriver-AndroidAuto-Nissan-Glitch-Fix.sh
   ```

   > **macOS Gatekeeper note:** If macOS blocks the script with *"cannot be opened because it is from an unidentified developer"*, right-click the file in Finder → **Open** → **Open** again in the confirmation dialog. After doing this once, you can run it normally from Terminal.

5. **Wait** for the Android Platform Tools to download and extract automatically
   *(Only happens on first run — takes about 30 seconds)*

6. **Read** the on-screen prep checklist, then press **Enter**

7. **Plug in your phone** via USB

8. **On your phone:** when *"Allow USB debugging?"* appears —
   - Check **"Always allow from this computer"**
   - Tap **OK**

9. **Press Enter** — the 3 fixes run automatically one at a time

10. **Review** the verification output after Fix 3

11. **Press Enter** to exit — ADB stops, tools are deleted, phone releases

---

## What the Script Fixes

| # | Fix | Why |
|---|-----|-----|
| 1 | Disable Wi-Fi "Switch to Mobile Data" | Stops Samsung from dropping cellular when the car's Wi-Fi is detected |
| 2 | Force Lyft to "Allow all the time" location | Prevents Lyft from losing background GPS |
| 3 | Disable precise GPS for Android Auto | Stops the Nissan's GPS chip from conflicting with Lyft |

---

## Verification — What to Look For

| Check | Good Result | Problem |
|-------|-------------|---------|
| Check 1 (Wi-Fi) | Both lines show `0` | Shows `1` — apply Fix 1 manually in Settings |
| Check 2 (Lyft location) | `granted=true` | `granted=false` — re-run the script |
| Check 3 (Android Auto) | `granted=false` | `granted=true` — apply Fix 3 manually in Settings |

---

## Need More Help?

See the full **[README.md](../README.md)** in the parent folder for:
- Detailed troubleshooting for every error message
- Manual fix instructions if any step fails
- Notes on whether fixes survive reboots and app updates
