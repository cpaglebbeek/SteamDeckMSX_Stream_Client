# ARCHITECTURE — SteamDeckMSX_Stream_Client

> Variant 2 client-side. Geen eigen binary; configuratie + scripts rondom upstream Moonlight-Qt.

## Componentdiagram (Steam Deck)

```
Steam Deck (SteamOS Gaming/Desktop Mode)
│
├─ Flatpak: com.moonlight_stream.Moonlight    ← upstream, ongewijzigd
│     │
│     ├─ Pairing met HC55 (PIN-code via Sunshine web)
│     ├─ Streamt video (H.264 of HEVC decode) + audio (opus)
│     └─ Stuurt gamepad-events terug via Sunshine control-channel
│
├─ Steam (Gaming Mode)
│     │
│     ├─ Non-Steam Game shortcut: "MSX Stream"
│     │     → start: flatpak run com.moonlight_stream.Moonlight stream <host> "MSX-stream"
│     │
│     └─ Steam Input layer       ← gamepad → Moonlight → Sunshine
│
└─ Deze repo:
   ├─ scripts/pair.sh             ← v0.0.3 — eenmalige pairing
   ├─ scripts/launch-msx.sh       ← v0.0.3 — Gaming-Mode-launcher
   ├─ presets/msx-gamepad.vdf     ← v0.0.2 — Steam Input preset
   ├─ docs/troubleshooting.md     ← v0.0.1+
   └─ prompts/                    ← sessie-MD's
```

## Stream-stappen vanuit user-perspectief

1. **Eénmalig (Desktop Mode):**
   - Install Moonlight via Discover
   - Run `pair.sh horsecloud55.ddns.net` → toont PIN-instructie
   - Open `https://horsecloud55.ddns.net:47990` in browser → voer PIN in
2. **Eénmalig (Gaming Mode):**
   - Add "MSX Stream" als Non-Steam Game met de juiste launch-flags
   - Import Steam Input preset `msx-gamepad.vdf`
3. **Per spelsessie:**
   - Open Steam → Library → "MSX Stream" → A-knop
   - Moonlight start → openMSX-headless start op HC55 → stream begint
   - Spel afsluiten via Steam-knop overlay → back

## Latency-meet-tooling (v0.0.2)

`scripts/measure-latency.sh` — simpele ping + Sunshine-rtt-log-parse, output:
```
RTT to HC55:           18 ms (LAN) / 42 ms (WAN-mobile)
Stream pipeline RTT:   52 ms (LAN) / 88 ms (WAN-mobile)
Estimated I/O lag:     34 ms encode+decode+display
```

Doel: vroege detectie van degraded LAN/WAN performance.

## Niet inbegrepen

- Moonlight-binary — Flatpak upstream
- Sunshine-binary — server-side
- ROMs/BIOS — server-side

## Relatie met andere repos

| Repo | Relatie |
|------|---------|
| Meta_SteamDeckMSX | Pull docs/principes |
| SteamDeckMSX_Stream_Server | Pairing-protocol-paar |
| SteamDeckMSX_Native | Geen directe link; gebruiker kan beide installeren |
