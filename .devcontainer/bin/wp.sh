#!/bin/bash
# WP-CLI wrapper script
# Executes wp-cli commands in the WordPress container

set -e

cd "$(dirname "$0")/.."

docker compose exec wordpress wp --path=/var/www/html --allow-root "$@"
