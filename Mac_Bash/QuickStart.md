# Quick Start — macOS
### Lyft Driver App · Android Auto · Nissan Glitch Fix

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
