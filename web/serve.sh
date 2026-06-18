#!/bin/bash
# Serve the built bug-bounties web app over HTTP and open it.
#
# Why this exists: the Astro build is STATIC (dist/client/) with ABSOLUTE
# asset paths (/_astro/...). Opening dist/client/index.html via file:// breaks
# (assets 404 against the filesystem root → blank page). It must be served over
# HTTP. This script does that.
#
# Usage:  ./serve.sh [port]     (default 4321)

set -e
PORT="${1:-4321}"
DIR="$(cd "$(dirname "$0")" && pwd)/dist/client"

if [ ! -f "$DIR/index.html" ]; then
  echo "No build found. Run:  bun run build"
  exit 1
fi

echo "Serving $DIR on http://localhost:$PORT"
# sirv is already a dependency; --single serves SPA-style fallbacks.
( sleep 1 && open "http://localhost:$PORT" ) &
exec bunx --bun sirv-cli "$DIR" --port "$PORT" --single
