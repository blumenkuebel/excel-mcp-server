# Excel MCP Server

Based on [excel-mcp-server](https://github.com/haris-musa/excel-mcp-server) by **haris-musa** – all credit for the core implementation goes to the original author.

## Setup

```bash
./start_server.sh
```

The script creates a `.venv`, installs the package via `pip install -e .`, and starts the server on port **8002**.

## Deployment to Docker host

```bash
./deploy_to_remote.sh user
```

## MCP Registration

```bash
# Docker / remote
claude mcp add --scope user --transport http excel http://<docker-host>:8002/mcp

# Local
claude mcp add --scope user --transport http excel http://127.0.0.1:8002/mcp
```

## File Paths

All `.xlsx` files must be placed under `EXCEL_FILES_PATH` (default: `excel-mcp-server/excel_files/` on the host, `/app/excel_files` in the container). Pass **relative** paths to all tools (e.g. `reports/q1.xlsx`). Absolute paths and directory traversal are rejected.

## File Transfer

The server runs in Docker and **cannot access local file paths** (e.g. `/Users/…`). XLSX files must be uploaded via HTTP before they can be used with MCP tools.

Files are stored in `/app/excel_files` inside the container (mapped to `/mnt/dockershare/excel`).

```bash
# Upload (required before any tool that takes a filepath)
curl -s -H "X-API-Key: $MCP_API_KEY" -F "file=@data.xlsx" http://<docker-host>:8002/upload
# → returns JSON with "filename": "data.xlsx"

# Download
curl -H "X-API-Key: $MCP_API_KEY" http://<docker-host>:8002/download/data.xlsx -o data.xlsx

# List files
curl -H "X-API-Key: $MCP_API_KEY" http://<docker-host>:8002/files
```

### Workflow for agents

1. Upload the local file via `curl -s -H "X-API-Key: $MCP_API_KEY" -F "file=@/path/to/file.xlsx" http://<docker-host>:8002/upload`
2. Use the returned `filename` (e.g. `"data.xlsx"`) as `filepath` with all Excel tools
3. Do NOT try to read or unzip XLSX files locally — always upload via curl first

## API Key

Set `MCP_API_KEY` in the container environment to require `X-API-Key` on all `/upload`, `/download`, and `/files` requests. If unset, endpoints are unprotected.

See `docker-compose.yml` for the placeholder and `CHANGELOG.md` for security notes.

## License

MIT
