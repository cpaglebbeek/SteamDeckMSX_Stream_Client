---
date: 2026-05-31
repo: SteamDeckMSX_Stream_Client
status: open
resume: "verder met SteamDeckMSX_Stream_Client v0.0.2 — Moonlight Flatpak install + Steam Input preset + pair.sh script"
---

# Sessie 2026-05-31 — newp SteamDeckMSX_Stream_Client (variant 2 client)

**Agent:** Claude Opus 4.7 (1M context)
**Repo:** SteamDeckMSX_Stream_Client (`cpaglebbeek/SteamDeckMSX_Stream_Client`)
**Branche:** main
**Cross-repo werk:** Meta_SteamDeckMSX, Stream_Server (pairing-protocol-paar)
**Eindstand commits:** (initial commit, hash volgt)

---

## Opdracht (samengevat)

Onderdeel van newp — deze repo is variant 2 client-side (Moonlight-Qt config + scripts op Steam Deck). Geen eigen runtime; leunt op upstream Moonlight Flatpak.

---

## Prompts en acties — chronologisch

Zie `Meta_SteamDeckMSX/prompts/2026-05-31_newp_skeleton.md` voor volledige conversatie.

### Actie — skeleton voor Stream_Client variant
README (plan v0.0.1→v0.1.0), CLAUDE.md (kleurcodes, geen eigen binary, WhatIf), .gitignore (state, keys), VERSION (`0.0.1-VampireKiller`), ARCHITECTURE.md (componentdiagram Deck-zijde, user-stream-stappen, latency-meet-tooling), CHANGELOG.md, `docs/troubleshooting.md` (vroege placeholder met verwachte Sunshine/Moonlight issues).

---

## Belangrijke keuzes deze sessie

| Keuze | Reden |
|---|---|
| Codenaam v0.0.1 = Vampire Killer | MSX2 Konami-klassieker, Client-rol symboliek |
| Geen eigen binary | Moonlight upstream is goed; we leveren config + procedures |
| Steam Input preset als artifact | Gamepad-mapping consistent maken voor MSX-titels |
| Geen Moonlight-source in repo | Upstream Flatpak consumeren |

---

## Open eindjes na deze sessie

**v0.0.2:**
- `scripts/pair.sh <host>` schrijven — eenmalige pairing met user-feedback
- `presets/msx-gamepad.vdf` — Steam Input preset (afgeleid van openMSX joystick API)
- `scripts/measure-latency.sh`

**v0.0.3:**
- `scripts/launch-msx.sh` Gaming-Mode launcher
- `.desktop` file voor "Add as Non-Steam Game"

**v0.1.0:**
- Eerste werkende stream-test (vereist Stream_Server v0.0.3+ live)

**Onafhankelijk:**
- Moonlight Flatpak versie pinnen v0.0.2 (compat-matrix bijhouden met Sunshine-versies)
