# Troubleshooting — SteamDeckMSX_Stream_Client

> Vroege placeholder; uit te breiden vanaf v0.0.2 zodra eerste echte stream is gestest.

## Verwachte issues op basis van Sunshine/Moonlight community-rapporten

### Pairing lukt niet — Moonlight ziet HC55 niet
- **Check 1:** ping `horsecloud55.ddns.net` vanaf Deck
- **Check 2:** poort 47984 TCP open vanaf Deck? `nc -zv horsecloud55.ddns.net 47984`
- **Check 3:** Hetzner firewall + ufw op HC55 hebben Sunshine-poorten ge-allowlist

### Stream start maar zwart scherm
- Sunshine-config: `output_name` moet matchen met de virtuele display van openMSX-headless
- Sunshine-log: `journalctl -u steamdeckmsx-sunshine.service -f`

### Audio-desync (>200ms)
- Sunshine `audio_sink` instelling — proberen PipeWire i.p.v. PulseAudio
- `samplerate` op 48000 forceren (openMSX default = 44100, Sunshine herresamplet)

### Gamepad werkt niet
- Steam Input preset niet geactiveerd? Steam → Controller Settings → MSX-stream → "Browse Configs"
- Moonlight gamepad-passthrough aan? Settings → "Background gamepad input"

### Hoge latency (>100ms LAN)
- HC55 CPU-load: `top` — Sunshine + openMSX moeten samen <2 cores piek doen
- `systemd CPUQuota=200%` actief op `steamdeckmsx-sunshine.service`?
- x264 preset = `superfast` + `zerolatency`?

### Steam Deck Gaming Mode crash bij start
- Bekend issue Moonlight Flatpak + Gaming Mode in oudere SteamOS-versies. Upgrade naar SteamOS 3.5+.
