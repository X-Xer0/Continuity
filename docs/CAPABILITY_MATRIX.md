# CAPABILITY MATRIX — honest status for THIS setup (Hyprland Dell + Realme 5 Pro, Android 11)

| Capability | Status | Delivered by | Notes |
|---|---|---|---|
| File share phone↔laptop (any type) | ✔ works | KDE Connect share + LocalSend | both directions; no internet needed |
| Large file transfer | ✔ works | LocalSend (or KDE Connect) | max Wi-Fi speed |
| Background folder sync (photos/docs) | ✔ works | Syncthing + Syncthing-Fork | continuous, versioned |
| Notification mirroring | ✔ works | KDE Connect | shown via swaync |
| Reply to SMS from laptop | ✔ works | KDE Connect (+kdeconnect-sms) | SMS only; app must allow RemoteInput for richer replies |
| Send SMS from laptop | ✔ works | KDE Connect | via ck-menu |
| Clipboard sync text | ⚠ partial | KDE Connect | Wayland/focus limitation (KDE bug 410162); manual send via ck-menu always works |
| Remote commands phone → laptop | ✔ works | KDE Connect runcommand | allowlist enforced (safe commands only) |
| Phone as touchpad/keyboard/media remote | ✔/⚠ | KDE Connect | media+presenter fine; touchpad needs portal remote-input support |
| Ring / find phone, battery | ✔ works | KDE Connect | battery shown in app/indicator |
| Phone screen on laptop (mirror + control) | ✔ works | scrcpy over wireless adb | 1920px@60fps default |
| Copy/paste into mirrored phone | ✔ works | scrcpy | Ctrl+C/V forwarding |
| URL / text share phone↔laptop | ✔ works | KDE Connect | ck-menu "Send text" |
| Quick Share native Sharesheet interop | — deferred | (optional Phase 08) | timeboxed, deferrable; LocalSend covers the need |
| Laptop screen → phone | ✘ impossible here | — | needs vendor stack (Sidecar/DeX-class) |
| Call audio relay / RCS relay to laptop | ✘ impossible here | — | needs cloud + carrier integration (Phone Link class) |
| Auto-unlock / cross-device mouse | ✘ impossible here | — | needs Apple/vendor stack |
| AirDrop with iPhones | ✘ out of scope | — | AWDL reverse-engineering, broken/unsafe; not relevant to this pairing |
| Works off-LAN (WAN) | ✘ out of scope | — | LAN-only by design (ADR-004); phone hotspot is the fallback transport |
