# Android checklist — Realme 5 Pro (Android 11 / Realme UI 2.0)

Agent: hand this file to the user. Everything below is phone-side.
Do the steps in order. The laptop is already configured.

## 1. Same network first
- Best: phone and laptop on the same Wi-Fi SSID (5 GHz preferred).
- Also works: phone USB tethering (it behaves like a LAN).
- Avoid public/guest Wi-Fi with client isolation.

## 2. Install the apps (F-Droid: https://f-droid.org — never random APK mirrors)
1. **KDE Connect** (`org.kde.kdeconnect_tp`) — must be ≥ 1.34.4 (security fix).
2. **LocalSend** (`org.localsend.localsend_app`).

## 3. Battery + autostart (Realme UI kills background apps)
For EACH app:
- Settings → Battery → App Battery Management / Battery optimization → Don't optimize (allow background activity).
- Settings → App Management → Auto-Start → enable.
- Open the app once → open Recents → tap the app's ⋮ menu → Lock (padlock).
- Menu names vary slightly by region build; look for "battery optimization" and "auto-start".

## 4. KDE Connect permissions + settings
- Grant: Notification access, SMS, Contacts, Phone, Storage/Files.
- Location → Allow all the time (only used for "Trusted Networks").
- KDE Connect → ⋮ → Settings → Trusted Networks → add your home Wi-Fi SSID.

## 5. Pair with the laptop
- Open KDE Connect on the phone; both devices on the same network.
- Request pairing (either side), accept on BOTH devices.
- Laptop verification (agent runs):
  - `kdeconnect-cli --refresh && kdeconnect-cli -l --id-name-only`
  - `kdeconnect-cli -d <ID> --ping` (phone should vibrate/show a ping)
  - `kdeconnect-cli --encryption-info` (expect "protocol version 8")

## 6. LocalSend
- Open on both devices; they discover each other automatically.
- Phone: set a clear device name; enable PIN if offered.
- Laptop: save folder = `~/continuity`, Quick Save = on (managed by the repo).

## 7. Wireless debugging (needed for phone screen mirroring without a cable)
- Settings → About device → Version → tap "Build number" 7 times.
- Settings → Additional settings/System → Developer options → Wireless debugging → ON.
- Leave the phone on this screen when the agent asks for pairing.
- `USB debugging` in the same screen enables the cable path (`ck-mirror --usb`).

## 8. What to report back to the agent
- Confirm each app is installed + its version (KDE Connect shows it in ⋮ → About).
- Say "paired" once step 5 is accepted.
- The agent will then run the verification gates and request the acceptance tests.
