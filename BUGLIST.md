# BUGLIST — SteamDeckMSX_Stream_Client

> Per `Meta_Master/templates/BUGLIST_TEMPLATE.md`. Kleurcodes: Groen / Geel / Rood / Loop.

## Open

_(nog geen — v0.0.1 is alleen skeleton, geen scripts of presets)_

## Opgelost

_(leeg)_

## Terugkerende patronen

_(in te vullen vanaf v0.0.2 zodra pair.sh + Steam Input preset bestaan en zijn getest)_

## Verwacht (van upstream Moonlight / Sunshine community)

Zie `docs/troubleshooting.md` voor de bekende issue-categorieën die we vanaf v0.0.2-tests gaan dekken:
- Pairing-failures (firewall, DNS)
- Zwart scherm (Sunshine virtual-display config)
- Audio-desync (sample-rate, PipeWire vs Pulse)
- Gamepad-passthrough conflicts met Steam Input
- Hoge latency (CPU-load HC55, x264-preset)
- Gaming Mode crash (oudere SteamOS)

## Cross-repo bug-referenties

Zie `Meta_Master/BUGS_GLOBAL.md`. Relevant voor deze client:
- **FEATURE/Steam Input** — gamepad-binding conflicts (gedeeld met Native variant)
- **DEPLOY/Flatpak** — Moonlight Flatpak-version drift t.o.v. Sunshine-server-version
