# CLAUDE.md — SteamDeckMSX_Stream_Client

> Variant 2 client-side. Configuratie + scripts voor Moonlight op de Steam Deck. Erft regels van `Meta_Master/CLAUDE.md`.

## Rol

Geen eigen binary; configuratie + procedures rondom upstream Moonlight-Qt (Flatpak `com.moonlight_stream.Moonlight`).

## Codenaam-thema

MSX-game-helden. v0.0.1 = **Vampire Killer**. Vrije pool: zie Meta-repo CLAUDE.md.

## Feature & Bugfix Protocol (Color-Coded)

**Nieuwe Feature:**
- **Groen** — Doc-toevoeging, troubleshooting-entry → +0.0.1
- **Oranje** — Nieuw script of nieuwe Steam Input preset → +0.1.0
- **Rood** — Vervanging Moonlight door andere client (bv. Sunshine-eigen-client) → +1.0.0

**Bugfix:**
- **Groen** — Tekstfout in pairing-instructie
- **Geel** — Script-bug (pad fout, gamepad-mapping fout)
- **Rood** — Upstream-Moonlight-incompatibiliteit → architectuur-heroriëntatie

**RCA verplicht.**

## WhatIf Protocol

Verplicht. Bij scripts: dry-run-mode default in v0.0.3+.

## Niet-scope

- Moonlight-source-fork — gebruik upstream
- Andere clients dan Moonlight — uit scope (al ondersteunt Sunshine ook GameStream-clients algemeen)
- Stream-server-config — zie Stream_Server repo

## Sessie-MD's

`prompts/YYYY-MM-DD_<slug>.md` met frontmatter. Verplicht per Meta_Master protocol.
