#!/usr/bin/env bash
# deploy_to_remote.sh – Überträgt den Excel-MCP-Server auf 192.168.55.15 und startet ihn.
# Voraussetzung: SSH-Zugriff auf 192.168.55.15 (Key-Auth empfohlen)
#
# Nutzung:
#   ./deploy_to_remote.sh [user]          # user=root wenn nicht angegeben
#   ./deploy_to_remote.sh pi              # z. B. für Raspberry Pi

set -euo pipefail

REMOTE_USER="${1:-root}"
REMOTE_HOST="192.168.55.15"
REMOTE_DIR="/home/${REMOTE_USER}/excel-mcp-server"
SSH="ssh ${REMOTE_USER}@${REMOTE_HOST}"

echo "==> Übertrage Quellcode nach ${REMOTE_HOST}:${REMOTE_DIR} ..."
rsync -avz --delete \
  --exclude '.venv' \
  --exclude '__pycache__' \
  --exclude '*.pyc' \
  --exclude '.git' \
  --exclude 'excel_files' \
  "$(dirname "$0")/" \
  "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

echo "==> Baue Image und starte Container ..."
$SSH bash -s <<REMOTE
  set -euo pipefail
  cd ${REMOTE_DIR}
  docker compose -f docker-compose.yml up -d --build
  echo "==> Container-Status:"
  docker compose -f docker-compose.yml ps
REMOTE

echo ""
echo "✓ Fertig. Server läuft auf http://${REMOTE_HOST}:8002/mcp"
echo ""
echo "Claude-Code-Registrierung (einmalig ausführen):"
echo "  claude mcp add --scope user --transport http excel http://${REMOTE_HOST}:8002/mcp"
