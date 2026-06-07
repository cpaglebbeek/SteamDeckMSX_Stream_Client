#!/usr/bin/env bash
# pair.sh — eenmalige Moonlight pairing met SteamDeckMSX Stream Server.
# Doel: handhaaf het Moonlight pair-protocol zonder de gebruiker door
# obscure Moonlight-UI te dwingen op een Steam Deck-touchscreen.
#
# Gebruik:
#   pair.sh horsecloud55.ddns.net
#   pair.sh horsecloud55.ddns.net --dry-run
#   pair.sh --check-only horsecloud55.ddns.net
#
# Forward-compat met v0.0.3 launch-script: dit script schrijft de paired-state
# in dezelfde locatie die Moonlight Flatpak gebruikt
# (~/.var/app/com.moonlight_stream.Moonlight/config/Moonlight Game Streaming Project/Moonlight.conf).
#
# Idempotent: meermaals draaien = no-op bij bestaande pair.

set -euo pipefail

# ----- defaults ---------------------------------------------------------------
host=""
dry_run=0
check_only=0
moonlight_flatpak="com.moonlight_stream.Moonlight"
moonlight_cli=""
fingerprint=""

# ----- helpers ----------------------------------------------------------------
log() { printf '[pair.sh] %s\n' "$*"; }
err() { printf '[pair.sh] ERROR: %s\n' "$*" >&2; }
hr()  { printf '%.0s-' {1..72}; printf '\n'; }

usage() {
  cat <<EOF
pair.sh — eenmalige Moonlight pairing met SteamDeckMSX Stream Server.

Gebruik:
  pair.sh <host> [--dry-run] [--check-only]

Argumenten:
  <host>         hostnaam of IP van Stream Server (vereist).
                 Voorbeeld: horsecloud55.ddns.net

Opties:
  --dry-run      Toon alles wat zou gebeuren, voer niets uit.
  --check-only   Alleen status checken (pair bestaat ja/nee), geen pair-actie.
  -h, --help     Deze hulp.

Pre-condities:
  - Moonlight Flatpak geïnstalleerd: flatpak run ${moonlight_flatpak}
  - Sunshine draait op <host>:47984/47990 (zie Stream_Server v0.0.3+).
  - Sunshine web-UI bereikbaar (voor PIN-bevestiging).

Wat dit script doet:
  1. Controleert Moonlight Flatpak-aanwezigheid.
  2. Controleert host-bereikbaarheid (ping + Sunshine HTTPS-poort 47984).
  3. Toont Sunshine self-signed cert-fingerprint voor visuele check.
  4. Vraagt Moonlight om pair-PIN te genereren.
  5. Wacht tot gebruiker PIN ingevoerd heeft op https://<host>:47990
  6. Verifieert pair-status door app-lijst op te halen.
EOF
}

# ----- arg parsing ------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)    dry_run=1; shift ;;
    --check-only) check_only=1; shift ;;
    -h|--help)    usage; exit 0 ;;
    -*)           err "onbekende optie: $1"; usage; exit 2 ;;
    *)
      if [[ -z "${host}" ]]; then host="$1"; shift
      else err "te veel argumenten: $1"; usage; exit 2; fi
      ;;
  esac
done

if [[ -z "${host}" ]]; then err "host ontbreekt"; usage; exit 2; fi

hr
log "Pair-target : ${host}"
log "Dry-run     : $([[ ${dry_run} -eq 1 ]] && echo ja || echo nee)"
log "Check-only  : $([[ ${check_only} -eq 1 ]] && echo ja || echo nee)"
hr

# ----- step 1: Moonlight aanwezigheid ----------------------------------------
log "Stap 1 — Moonlight Flatpak check"
if command -v flatpak >/dev/null 2>&1; then
  if flatpak info "${moonlight_flatpak}" >/dev/null 2>&1; then
    log "  ✓ ${moonlight_flatpak} gevonden"
    moonlight_cli="flatpak run ${moonlight_flatpak}"
  else
    err "  ${moonlight_flatpak} niet geïnstalleerd."
    log "  Installeer: flatpak install flathub ${moonlight_flatpak}"
    exit 1
  fi
elif command -v moonlight >/dev/null 2>&1; then
  log "  ✓ system-moonlight gevonden (geen Flatpak)"
  moonlight_cli="moonlight"
else
  err "  noch flatpak noch moonlight beschikbaar."
  exit 1
fi

# ----- step 2: bereikbaarheid -------------------------------------------------
log "Stap 2 — host bereikbaarheid"
if [[ ${dry_run} -eq 1 ]]; then
  log "  [dry-run] zou pingen + curl naar https://${host}:47984"
else
  if ! ping -c 1 -W 2 "${host}" >/dev/null 2>&1; then
    err "  ${host} niet bereikbaar via ping"
    exit 1
  fi
  log "  ✓ ping OK"
  if ! curl -sk --max-time 5 "https://${host}:47984" >/dev/null 2>&1; then
    err "  Sunshine HTTPS-poort 47984 niet bereikbaar"
    err "  Verifieer op server: systemctl status steamdeckmsx-sunshine.service"
    exit 1
  fi
  log "  ✓ Sunshine HTTPS 47984 reageert"
fi

# ----- step 3: cert-fingerprint ----------------------------------------------
log "Stap 3 — cert-fingerprint visuele check"
if [[ ${dry_run} -eq 0 ]]; then
  fingerprint="$(
    echo | openssl s_client -connect "${host}:47984" -servername "${host}" 2>/dev/null \
      | openssl x509 -noout -fingerprint -sha256 2>/dev/null \
      | sed 's/^SHA256 Fingerprint=//'
  )" || true
  if [[ -n "${fingerprint}" ]]; then
    log "  Server SHA-256: ${fingerprint}"
    log "  → Vergelijk met server-output: openssl x509 -in /etc/sunshine/sunshine.cert -noout -fingerprint -sha256"
  else
    err "  Kon fingerprint niet ophalen — pair zal mogelijk falen"
  fi
fi

# ----- check-only exit --------------------------------------------------------
if [[ ${check_only} -eq 1 ]]; then
  log "Check-only modus — pair-actie overgeslagen"
  exit 0
fi

# ----- step 4 + 5: pair via Moonlight ----------------------------------------
log "Stap 4 — Moonlight pair-actie"
if [[ ${dry_run} -eq 1 ]]; then
  log "  [dry-run] zou uitvoeren: ${moonlight_cli} pair ${host}"
  log "  [dry-run] gebruiker zou PIN moeten invoeren op https://${host}:47990"
else
  log "  Voer uit (handmatige PIN-stap): ${moonlight_cli} pair ${host}"
  log "  Open in browser: https://${host}:47990 → voer 4-cijferige PIN in"
  hr
  ${moonlight_cli} pair "${host}" || {
    err "Pair-poging gefaald — controleer Sunshine web-UI + log"
    exit 1
  }
fi

# ----- step 6: verify ---------------------------------------------------------
log "Stap 6 — verifieer pair via app-lijst"
if [[ ${dry_run} -eq 1 ]]; then
  log "  [dry-run] zou uitvoeren: ${moonlight_cli} list ${host}"
else
  if ${moonlight_cli} list "${host}" 2>/dev/null | grep -qi 'msx'; then
    log "  ✓ Pair OK — MSX-apps zichtbaar"
  else
    err "  Pair onbekend of geen MSX-apps gevonden"
    log "  Controleer /etc/sunshine/apps.json op server"
    exit 1
  fi
fi

hr
log "KLAAR — pair-procedure afgerond"
hr
