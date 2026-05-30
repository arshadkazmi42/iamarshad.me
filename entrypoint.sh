#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Install missing gems if needed (important when using mounted volumes)
if ! bundle check > /dev/null 2>&1; then
  echo "Installing missing gems..."
  bundle install
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"