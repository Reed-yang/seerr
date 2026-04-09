#!/bin/bash
# Wrapper for Seerr that loads env vars from centralized .env file.
# Used by launchd plist to inject environment before starting Seerr.

# Ensure Homebrew binaries are in PATH (launchd uses minimal PATH)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# fnm (Fast Node Manager) — needed for Node 22 required by Seerr
eval "$(/opt/homebrew/bin/fnm env)"
fnm use 22

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$(cd "$SCRIPT_DIR/.." && pwd)/.env"

if [ -f "$ENV_FILE" ]; then
    set -a
    source "$ENV_FILE"
    set +a
fi

cd "$SCRIPT_DIR"
export NODE_ENV=production
exec node dist/index.js
