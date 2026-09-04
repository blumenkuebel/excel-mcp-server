# Changelog

All notable changes to this project will be documented here.

## [Unreleased] – Local Fork

### Based on
Original project by **haris-musa** –
[github.com/haris-musa/excel-mcp-server](https://github.com/haris-musa/excel-mcp-server).
All credit for the core implementation goes to the original author.

---

### Added

#### File upload/download tools (`src/excel_mcp/server.py`)
Two new MCP tools to transfer Excel files between client and server without requiring
shared filesystem access:

- **`upload_excel(filename, content_base64)`** – saves a base64-encoded `.xlsx` file
  into `EXCEL_FILES_PATH` on the server; the file can then be used by all other tools
  via its filename.
- **`download_excel(filename)`** – reads an Excel file from `EXCEL_FILES_PATH` and
  returns it as a JSON string with `filename`, `content_base64`, and `size_bytes`,
  so the client can save it locally.

This mirrors the deployment topology: the server runs in Docker and the client
(Claude) has no direct access to the server's filesystem.
