# Changelog

All notable changes to this project will be documented here.

## [Unreleased] – Local Fork

### Based on
Original project by **haris-musa** –
[github.com/haris-musa/excel-mcp-server](https://github.com/haris-musa/excel-mcp-server).
All credit for the core implementation goes to the original author.

---

### Added

#### File upload/download HTTP endpoints (`src/excel_mcp/server.py`)
Three custom HTTP routes for transferring Excel files without shared filesystem access:

- **`POST /upload`** – multipart/form-data upload (`curl -F "file=@data.xlsx" http://host:8002/upload`)
- **`GET  /download/<filename>`** – streams the file back as octet-stream
- **`GET  /files`** – lists all available XLSX files on the server

The uploaded filename can be passed directly to all other Excel MCP tools.
