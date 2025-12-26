#!/bin/bash
# MySQL client wrapper - executes mysql commands inside the db container

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Navigate to project root
cd "$PROJECT_ROOT"

# Load environment variables
if [ -f .devcontainer/.env ]; then
    export $(grep -v '^#' .devcontainer/.env | xargs)
fi

# Execute mysql in the db container
docker compose -f .devcontainer/docker-compose.yml exec db mysql \
    -u"${MYSQL_USER:-wordpress}" \
    -p"${MYSQL_PASSWORD:-wordpress}" \
    "${MYSQL_DATABASE:-wordpress}" \
    "$@"
