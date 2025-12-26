#!/bin/bash
# WP-CLI wrapper - executes wp-cli commands inside the WordPress container

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Navigate to project root
cd "$PROJECT_ROOT"

# Execute wp-cli in the wordpress container
docker compose -f .devcontainer/docker-compose.yml exec -u www-data wordpress wp "$@"
