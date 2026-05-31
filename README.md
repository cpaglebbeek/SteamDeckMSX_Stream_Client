# SteamDeckMSX_Stream_Client

**Variant 2 — client-side** van het [SteamDeckMSX](https://github.com/cpaglebbeek/Meta_SteamDeckMSX) ecosysteem. Configuratie + scripts om een Steam Deck als Moonlight-client te koppelen aan [SteamDeckMSX_Stream_Server](https://github.com/cpaglebbeek/SteamDeckMSX_Stream_Server) op HorseCloud55.

## Status

- **Versie:** v0.0.1-VampireKiller (skeleton)
- **Geen eigen runtime** — leunt op upstream Moonlight-Qt Flatpak. Deze repo levert: pairing-procedure, Steam Input-presets, troubleshooting-docs, latency-meet-script.

## Plan

1. **v0.0.1** — Skeleton + pairing-procedure-docs (deze release)
2. **v0.0.2** — Moonlight-config-snippets (`moonlight.conf` template) + Steam Input gamepad-preset
3. **v0.0.3** — `launch-msx.sh` shortcut-script + .desktop file voor Steam Deck "Add as Non-Steam Game"
4. **v0.1.0** — Eerste werkende stream getest

## Niet inbegrepen

- Moonlight-Qt source (gebruik upstream Flatpak: `com.moonlight_stream.Moonlight`)
- Sunshine source (zie Stream_Server)

## Setup-shortcut (v0.0.3 voorzien)

```bash
# Op Steam Deck Desktop Mode:
flatpak install com.moonlight_stream.Moonlight
git clone https://github.com/cpaglebbeek/SteamDeckMSX_Stream_Client ~/SteamDeckMSX_Stream_Client
~/SteamDeckMSX_Stream_Client/scripts/pair.sh horsecloud55.ddns.net
```

## Licentie

AGPL-3.0 — zie [LICENSE](LICENSE).
