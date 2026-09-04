# Changelog

All notable changes to this project will be documented here.

## [Unreleased] – Local Fork

### Based on
Original project by **haris-musa** –
[github.com/haris-musa/excel-mcp-server](https://github.com/haris-musa/excel-mcp-server).
All credit for the core implementation goes to the original author.

---

> ⚠️ **SECURITY WARNING – Single-user deployment only**
>
> This fork is designed and tested for **a single trusted user** on a private network.
> The following issues must be resolved before exposing this server to multiple users
> or any public/semi-public network:
>
> - **No user isolation**: all users share the same file directory (`EXCEL_FILES_PATH`).
>   Any user can read, overwrite, or delete any other user's files.
> - **Single shared API key**: `MCP_API_KEY` is one secret for all callers — there is
>   no per-user authentication or authorisation.
> - **No rate limiting or quotas**: a single client can exhaust disk space or CPU.
>
> **TODO before multi-user use:**
> - [ ] Per-user subdirectories (e.g. `<EXCEL_FILES_PATH>/<user-id>/`)
> - [ ] Per-user tokens (OAuth2/JWT via `mcp.settings.auth`)
> - [ ] Add TLS termination (nginx/Caddy) in front of the server
> - [ ] Add rate limiting and disk quota per user

---

### Added

#### File upload/download HTTP endpoints (`src/excel_mcp/server.py`)
Three custom HTTP routes for transferring Excel files without shared filesystem access:

- **`POST /upload`** – multipart/form-data upload (`curl -F "file=@data.xlsx" http://host:8002/upload`)
- **`GET  /download/<filename>`** – streams the file back as octet-stream
- **`GET  /files`** – lists all available XLSX files on the server

The uploaded filename can be passed directly to all other Excel MCP tools.

#### Optional API key protection (`MCP_API_KEY`)
Set `MCP_API_KEY` environment variable to require an `X-API-Key` header on all
`/upload`, `/download`, and `/files` requests. If unset, endpoints are unprotected.
