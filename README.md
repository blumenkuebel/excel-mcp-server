# Excel MCP Server

Based on [excel-mcp-server](https://github.com/haris-musa/excel-mcp-server) by **haris-musa** – all credit for the core implementation goes to the original author.

## Setup

```bash
./start_server.sh
```

The script creates a `.venv`, installs the package via `pip install -e .`, and starts the server on port **8002**.

## MCP Registration

```bash
# Docker / remote
claude mcp add --scope user --transport http excel http://192.168.55.15:8002/mcp

# Local
claude mcp add --scope user --transport http excel http://127.0.0.1:8002/mcp
```

## File Paths

All `.xlsx` files must be placed under `EXCEL_FILES_PATH` (default: `excel-mcp-server/excel_files/` on the host, `/app/excel_files` in the container). Pass **relative** paths to all tools (e.g. `reports/q1.xlsx`). Absolute paths and directory traversal are rejected.

## File Transfer

```bash
# Upload
curl -H "X-API-Key: $KEY" -F "file=@data.xlsx" http://192.168.55.15:8002/upload

# Download
curl -H "X-API-Key: $KEY" http://192.168.55.15:8002/download/data.xlsx -o data.xlsx

# List files
curl -H "X-API-Key: $KEY" http://192.168.55.15:8002/files
```

## API Key

Set `MCP_API_KEY` in the container environment to require `X-API-Key` on all `/upload`, `/download`, and `/files` requests. If unset, endpoints are unprotected.

See `docker-compose.yml` for the placeholder and `CHANGELOG.md` for security notes.

## License

MIT
