# CHANGELOG — SteamDeckMSX_Stream_Client

## v0.0.3-werk (2026-07-22) — launcher + .desktop klaar; Deck-test wacht op hardware

> Server-kant is LIVE (Stream_Server v0.1.0-Gradius, HC55). Extern geverifieerd:
> `/serverinfo` op :47989 antwoordt met hostname SteamDeckMSX-HC55. Poort :47984
> reset een kale curl bewust (client-cert na pairing) — geen firewall-issue.

- `scripts/launch-msx.sh` — Gaming-Mode launcher, `--app=CBIOS|Nemesis1|Nemesis2|BubbleBobble|MetalGear`,
  1280x800@60, 12 Mbps, `--quit-after`; app-namen 1-op-1 met server apps.json v0.1.0.
  Bash 3.2-compatibel (case-mapping i.p.v. associative array) → op Mac getest:
  --list, onbekende key (exit 2), ontbrekende Flatpak (exit 1)
- `presets/SteamDeckMSX-Stream.desktop` — "Add Non-Steam Game"-entry, default Nemesis (Gradius)
- Nog open (vereist fysieke Deck): Moonlight Flatpak install, pair.sh PIN-flow
  (via ssh-tunnel :47990, zie Stream_Server deploy/state.md), latency-meting,
  vdf-import, visuele preset-verificatie → dan pas versie-bump naar v0.1.0

## v0.0.2-Salamander (2026-06-07) — Pair-script + latency-meet + Steam Input preset (oranje)

> Alle scripts geschreven maar **niet getest op Steam Deck** (vereist Stream_Server
> v0.0.3+ live op HC55 + Deck SSH). Live-test verschuift naar apart resume-item.

### scripts/pair.sh — Moonlight pair-procedure
- `scripts/pair.sh` (~140 regels, bash strict-mode) — eenmalige pair-flow:
  1. Moonlight Flatpak-aanwezigheid check (fallback: system-moonlight)
  2. Host-bereikbaarheid (ping + curl naar `https://<host>:47984`)
  3. Cert-fingerprint visuele check (server SHA-256 vs `/etc/sunshine/sunshine.cert`)
  4. `moonlight pair <host>` aanroep
  5. Verifieer pair via `moonlight list <host>` (zoekt "msx"-app)
- **Idempotent**: bestaande pair = no-op.
- **`--dry-run` flag**: toont alles wat zou gebeuren, voert niets uit.
- **`--check-only` flag**: alleen status (no pair-actie).
- Bash strict-mode: `set -euo pipefail`.

### scripts/measure-latency.sh — RTT-meting
- `scripts/measure-latency.sh` (~90 regels) — netwerk-bijdrage stream-latency:
  - ICMP-ping min/avg/max/mdev (kan met `--tcp-only` overgeslagen worden)
  - TCP-handshake naar Sunshine-poort 47984, N samples (default 10)
  - **Verdict-tabel**: ≤15ms = ZEER GOED, ≤30ms = GOED (budget), ≤50ms = ACCEPTABEL, >50ms = SLECHT
- **Niet** bedoeld als kwaliteits-meting — verwijst naar Moonlight Performance Overlay + iperf3 voor diepere analyse.
- Bash strict-mode + portable nanosecond-time (`date +%s%N` met `gdate`-fallback voor macOS-dev).

### presets/msx-gamepad.vdf — Steam Input preset
- `presets/msx-gamepad.vdf` (~80 regels) — generieke MSX-gamepad-mapping:
  - D-pad ↑↓←→ → cursor-keys (openMSX joystick passthrough)
  - A → Space (Fire-1), B → LCtrl (Fire-2)
  - X → F5 (quick-save), Y → F8 (quick-load)
  - L1 → F2 (vorige game), R1 → F3 (volgende game) — koppelt met `apps.json`
  - L2 → F11 (slow-motion), R2 → F12 (fast-forward)
  - Select → F1 (openMSX OSD), Start → PAUSE (resume/pause)
- Lokalisatie: english + dutch labels.
- Conventie: preset gaat uit van openMSX 21.0 default key-bindings.
  Cross-machine-aanpassingen via `~/.openMSX/share/keymap.txt`, niet via dit vdf.

### Wat NIET in deze release
- **Geen live-test op Steam Deck** — vereist Stream_Server v0.0.3+ live (apart resume-item).
- **Geen launch-script** (`scripts/launch-msx.sh`) — verschuift naar v0.0.3 (Gaming-Mode launcher).
- **Geen `.desktop`-file** voor "Add as Non-Steam Game" — v0.0.3.
- **Geen Moonlight Flatpak-versie pin** in compat-matrix — v0.0.3.
- **Geen visuele verificatie van vdf-preset** in Steam Input UI op Deck — apart open-item.

### Codenaam — Salamander
Konami MSX 1986. Vervolg op Gradius. Koppelt symbolisch met Stream_Server v0.0.2-Parodius (ook Gradius-vervolg) — Client en Server zijn een spel-paar.

### Kleurcode: ORANJE (+0.1.0)
Nieuw script-skelet (`scripts/`) + nieuwe Steam Input preset (`presets/`). Conform `CLAUDE.md` § Color-Coded: nieuwe scripts + preset = oranje (was groen in skeleton-fase; nu functionele toevoegingen).

## v0.0.1-VampireKiller (2026-05-31) — Skeleton

- Initiële repo-structuur (newp)
- README, LICENSE (AGPL-3.0), CLAUDE.md, ARCHITECTURE.md
- Geen scripts, geen presets — alleen plan + docs
