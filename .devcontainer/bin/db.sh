#!/bin/bash
# MySQL client wrapper script
# Executes MySQL commands in the database container

set -e

cd "$(dirname "$0")/.."

# Source environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Execute mysql or mysqladmin commands
docker compose exec db "$@"
