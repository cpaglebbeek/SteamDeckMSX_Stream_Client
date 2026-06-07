#!/usr/bin/env bash
# measure-latency.sh — eenvoudige RTT-meting tegen SteamDeckMSX Stream Server.
# Doel: ruwe inschatting van netwerk-bijdrage aan eind-tot-eind stream-latency.
#
# Niet bedoeld als kwaliteits-meting (gebruik daarvoor Moonlight's eigen
# `Performance Overlay` of `iperf3` tussen Deck en HC55).
#
# Gebruik:
#   measure-latency.sh horsecloud55.ddns.net
#   measure-latency.sh horsecloud55.ddns.net --count 20
#   measure-latency.sh horsecloud55.ddns.net --tcp-only

set -euo pipefail

host=""
count=10
tcp_only=0

usage() {
  cat <<EOF
measure-latency.sh — RTT-meting tegen SteamDeckMSX Stream Server.

Gebruik:
  measure-latency.sh <host> [--count N] [--tcp-only]

Opties:
  --count N    Aantal samples (default: 10)
  --tcp-only   Alleen TCP-handshake-meting (skip ICMP-ping)
  -h, --help   Deze hulp

Uitvoer:
  - ICMP-ping min/avg/max/mdev (tenzij --tcp-only)
  - TCP-handshake (Sunshine 47984) min/avg/max
  - Verdict t.o.v. budget (60-80 ms eindtotaal, netwerk-deel ≤30 ms)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --count)    count="$2"; shift 2 ;;
    --tcp-only) tcp_only=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *)
      if [[ -z "${host}" ]]; then host="$1"; shift
      else echo "te veel argumenten" >&2; exit 2; fi
      ;;
  esac
done

if [[ -z "${host}" ]]; then echo "host ontbreekt" >&2; usage; exit 2; fi

printf 'measure-latency.sh  target=%s  samples=%d\n' "${host}" "${count}"
printf -- '--------------------------------------------------------------\n'

# ----- ICMP ping --------------------------------------------------------------
if [[ ${tcp_only} -eq 0 ]]; then
  printf 'ICMP-ping...\n'
  if ! ping_out="$(ping -c "${count}" -i 0.2 -W 2 "${host}" 2>&1)"; then
    printf '  FAIL — geen ping-respons (%s)\n' "${host}"
  else
    printf '%s\n' "${ping_out}" | tail -2
  fi
  printf '\n'
fi

# ----- TCP-handshake naar Sunshine HTTPS-poort -------------------------------
printf 'TCP-handshake naar 47984 (Sunshine HTTPS)...\n'
total=0
samples=0
min_ms=999999
max_ms=0
for i in $(seq 1 "${count}"); do
  start_ns="$(date +%s%N 2>/dev/null || gdate +%s%N)"
  if (timeout 3 bash -c "cat </dev/tcp/${host}/47984" >/dev/null 2>&1); then
    end_ns="$(date +%s%N 2>/dev/null || gdate +%s%N)"
    delta_ms=$(( (end_ns - start_ns) / 1000000 ))
    total=$(( total + delta_ms ))
    samples=$(( samples + 1 ))
    if (( delta_ms < min_ms )); then min_ms=${delta_ms}; fi
    if (( delta_ms > max_ms )); then max_ms=${delta_ms}; fi
    printf '  sample %2d: %4d ms\n' "${i}" "${delta_ms}"
  else
    printf '  sample %2d: TIMEOUT\n' "${i}"
  fi
done

if (( samples > 0 )); then
  avg_ms=$(( total / samples ))
  printf -- '--------------------------------------------------------------\n'
  printf 'TCP    min=%d ms  avg=%d ms  max=%d ms  (%d/%d samples)\n' \
    "${min_ms}" "${avg_ms}" "${max_ms}" "${samples}" "${count}"

  # Verdict — budget netwerk-RTT ≤30ms
  if (( avg_ms <= 15 )); then
    printf 'VERDICT: ZEER GOED (≤15ms). Streamen probleemloos verwacht.\n'
  elif (( avg_ms <= 30 )); then
    printf 'VERDICT: GOED (≤30ms). Stream-latency-budget gehaald.\n'
  elif (( avg_ms <= 50 )); then
    printf 'VERDICT: ACCEPTABEL (≤50ms). Lichte vertraging merkbaar in snelle games.\n'
  else
    printf 'VERDICT: SLECHT (>50ms). Netwerk dominant in budget — controleer route.\n'
  fi
else
  printf 'TCP    geen samples geslaagd\n'
  exit 1
fi
