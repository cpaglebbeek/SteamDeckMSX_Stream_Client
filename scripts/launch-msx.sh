#!/usr/bin/env bash
# launch-msx.sh — Gaming-Mode launcher voor SteamDeckMSX stream via Moonlight.
# Start direct een MSX-app op de Stream Server zonder Moonlight-UI-navigatie.
#
# Gebruik:
#   launch-msx.sh                          # default host + C-BIOS shell
#   launch-msx.sh --app=Nemesis1           # Nemesis (Gradius) op default host
#   launch-msx.sh --app=Nemesis2 horsecloud55.ddns.net
#   launch-msx.sh --list                   # toon app-keuzes
#
# App-namen corresponderen met Stream_Server deploy/sunshine/apps.json
# (v0.1.0-Gradius, 5 entries). Bij wijziging server-side: hier bijwerken.
#
# Pre-conditie: eenmalige pairing gedaan via pair.sh (zie prompts/ + Stream_Server
# deploy/state.md — PIN via ssh-tunnel naar :47990).

set -euo pipefail

default_host="horsecloud55.ddns.net"
moonlight_flatpak="com.moonlight_stream.Moonlight"

# Steam Deck native: 1280x800. Bitrate conservatief voor residential upload HC55.
resolution="1280x800"
fps=60
bitrate=12000   # kbps; 720p60-budget, x264 ultrafast server-side

app_key="CBIOS"
host=""

declare -A apps=(
  [CBIOS]="MSX — C-BIOS shell (default)"
  [Nemesis1]="MSX1 — Nemesis (Gradius)"
  [Nemesis2]="MSX2 — Nemesis (SCC audio test)"
  [BubbleBobble]="MSX1 — Bubble Bobble"
  [MetalGear]="MSX2 — Metal Gear"
)

usage() {
  cat <<EOF
launch-msx.sh — start MSX-stream in Moonlight (Gaming Mode-vriendelijk).

Gebruik: launch-msx.sh [--app=<key>] [--list] [host]

Keys: ${!apps[*]}
Default host: ${default_host}
EOF
}

for arg in "$@"; do
  case "${arg}" in
    --app=*) app_key="${arg#--app=}" ;;
    --list)  for k in "${!apps[@]}"; do printf '%-14s %s\n' "${k}" "${apps[${k}]}"; done; exit 0 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Onbekende optie: ${arg}" >&2; usage; exit 2 ;;
    *) host="${arg}" ;;
  esac
done

host="${host:-${default_host}}"

if [[ -z "${apps[${app_key}]:-}" ]]; then
  echo "Onbekende app-key '${app_key}'. Kies uit: ${!apps[*]}" >&2
  exit 2
fi

if ! flatpak info "${moonlight_flatpak}" >/dev/null 2>&1; then
  echo "Moonlight Flatpak ontbreekt. Installeer: flatpak install flathub ${moonlight_flatpak}" >&2
  exit 1
fi

exec flatpak run "${moonlight_flatpak}" stream "${host}" "${apps[${app_key}]}" \
  --resolution "${resolution}" --fps "${fps}" --bitrate "${bitrate}" \
  --quit-after
