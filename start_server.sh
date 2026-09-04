#!/usr/bin/env bash
#
# Startet den Excel-MCP-Server (haris-musa) im streamable-HTTP-Modus.
# Beendet zuvor einen evtl. laufenden Prozess auf dem Port.
#
# Nutzung:
#   ./start_server.sh            # Standard-Port 8002
#   ./start_server.sh 8080       # eigener Port
#
# WICHTIG (HTTP-Modus): Alle Excel-Dateien müssen unterhalb von
# EXCEL_FILES_PATH liegen und werden RELATIV dazu angesprochen
# (z. B. "reports/q1.xlsx"). Absolute Pfade werden abgelehnt.
#
set -euo pipefail

# In das Verzeichnis dieses Skripts wechseln
cd "$(dirname "$0")"

PORT="${1:-8002}"
HOST="${FASTMCP_HOST:-0.0.0.0}"
VENV=".venv"
FILES_DIR="${EXCEL_FILES_PATH:-$(pwd)/excel_files}"

# --- venv sicherstellen + Paket installieren --------------------------------
if [ ! -d "$VENV" ]; then
  echo "==> Kein venv gefunden. Erstelle $VENV ..."
  python3 -m venv "$VENV"
  # shellcheck disable=SC1091
  source "$VENV/bin/activate"
  pip install -q --upgrade pip
  echo "==> Installiere excel-mcp-server (editierbar aus lokalem Quellcode) ..."
  pip install -q -e .
else
  # shellcheck disable=SC1091
  source "$VENV/bin/activate"
fi

# --- Datei-Verzeichnis sicherstellen ---------------------------------------
mkdir -p "$FILES_DIR"
echo "==> EXCEL_FILES_PATH: $FILES_DIR"

# --- Port freimachen --------------------------------------------------------
PIDS="$(lsof -ti tcp:"$PORT" || true)"
if [ -n "$PIDS" ]; then
  echo "==> Beende Prozess(e) auf Port $PORT: $PIDS"
  # shellcheck disable=SC2086
  kill $PIDS 2>/dev/null || true
  sleep 1
  PIDS="$(lsof -ti tcp:"$PORT" || true)"
  if [ -n "$PIDS" ]; then
    # shellcheck disable=SC2086
    kill -9 $PIDS 2>/dev/null || true
  fi
else
  echo "==> Port $PORT ist frei."
fi

# --- Server starten ---------------------------------------------------------
echo "==> Starte Excel-MCP-Server auf http://$HOST:$PORT/mcp"
export EXCEL_FILES_PATH="$FILES_DIR"
export FASTMCP_HOST="$HOST"
export FASTMCP_PORT="$PORT"
exec excel-mcp-server streamable-http
