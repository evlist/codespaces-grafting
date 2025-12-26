#!/bin/bash
# MySQL client wrapper script
# Executes MySQL commands in the database container

set -e

cd "$(dirname "$0")/.."

# Source environment variables
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Execute mysql or mysqladmin commands
docker compose exec db "$@"
