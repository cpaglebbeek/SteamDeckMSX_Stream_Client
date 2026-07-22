#!/usr/bin/env bash
# deck-enable-ssh.sh — eenmalige Deck-setup: SSH-key + sshd aan.
# Draaien OP de Steam Deck (Desktop Mode → Konsole):
#   curl -s https://horsecloud55.ddns.net/steam/deck.sh | bash
# Vraagt 1x je sudo-wachtwoord (stel eerst een wachtwoord in met `passwd` als je die nog niet hebt).
set -euo pipefail

PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEd7ST22ld/FeI3DRpoqLI2E/HdVSvVuonJBXS2zpqE2 claude-code@macbook-christian"

mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/authorized_keys" && chmod 600 "$HOME/.ssh/authorized_keys"
grep -qF "$PUBKEY" "$HOME/.ssh/authorized_keys" || echo "$PUBKEY" >> "$HOME/.ssh/authorized_keys"
echo "[deck-setup] SSH-key geïnstalleerd."

if ! systemctl is-active -q sshd; then
    echo "[deck-setup] sshd aanzetten (sudo-wachtwoord nodig)…"
    sudo systemctl enable --now sshd
fi
echo "[deck-setup] sshd: $(systemctl is-active sshd)"
ip -4 -o addr show up scope global | awk '{print "[deck-setup] IP: " $4}'
echo "[deck-setup] KLAAR — meld het IP aan Claude."
