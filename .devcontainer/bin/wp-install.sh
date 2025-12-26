#!/bin/bash
# WordPress installation and configuration script
# This script is idempotent and can be run multiple times

set -e

echo "==> Starting WordPress installation and configuration..."

cd "$(dirname "$0")/.."

# Source environment variables
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Set defaults
WP_SITE_URL=${WP_SITE_URL:-http://localhost:8080}
WP_TITLE=${WP_TITLE:-WordPress Plugin Development}
WP_ADMIN_USER=${WP_ADMIN_USER:-admin}
WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD:-admin}
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-admin@example.com}
WP_LOCALE=${WP_LOCALE:-en_US}
PLUGIN_SLUG=${PLUGIN_SLUG:-hello-world}

# Wait for database to be ready
echo "==> Waiting for database to be ready..."
MAX_ATTEMPTS=60
ATTEMPT=0
until docker compose exec -T db mysqladmin ping -h localhost --silent 2>/dev/null; do
    ATTEMPT=$((ATTEMPT + 1))
    if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
        echo "ERROR: Database failed to become ready in time"
        exit 1
    fi
    echo "Waiting for database... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
    sleep 2
done

echo "==> Database is ready!"

# Wait for WordPress container to be ready
echo "==> Waiting for WordPress container to be ready..."
ATTEMPT=0
until docker compose exec -T wordpress curl -f http://localhost >/dev/null 2>&1; do
    ATTEMPT=$((ATTEMPT + 1))
    if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
        echo "ERROR: WordPress container failed to become ready in time"
        exit 1
    fi
    echo "Waiting for WordPress... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
    sleep 2
done

echo "==> WordPress container is ready!"

# Check if WordPress is already installed
if docker compose exec -T wordpress wp --path=/var/www/html --allow-root core is-installed 2>/dev/null; then
    echo "==> WordPress is already installed, skipping core installation"
else
    echo "==> Installing WordPress..."
    docker compose exec -T wordpress wp --path=/var/www/html --allow-root core install \
        --url="$WP_SITE_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
    echo "==> WordPress installed successfully!"
fi

# Install and activate language if not en_US
if [ "$WP_LOCALE" != "en_US" ]; then
    echo "==> Setting up language: $WP_LOCALE..."
    docker compose exec -T wordpress wp --path=/var/www/html --allow-root language core install "$WP_LOCALE" || true
    docker compose exec -T wordpress wp --path=/var/www/html --allow-root site switch-language "$WP_LOCALE" || true
fi

# Set permalinks
echo "==> Setting permalink structure..."
docker compose exec -T wordpress wp --path=/var/www/html --allow-root rewrite structure '/%postname%/' --hard

# Ensure admin user exists
echo "==> Ensuring admin user exists..."
if ! docker compose exec -T wordpress wp --path=/var/www/html --allow-root user get "$WP_ADMIN_USER" >/dev/null 2>&1; then
    docker compose exec -T wordpress wp --path=/var/www/html --allow-root user create \
        "$WP_ADMIN_USER" \
        "$WP_ADMIN_EMAIL" \
        --user_pass="$WP_ADMIN_PASSWORD" \
        --role=administrator
fi

# Install and activate additional plugins from WP_PLUGINS
if [ -n "$WP_PLUGINS" ]; then
    echo "==> Installing additional plugins: $WP_PLUGINS..."
    IFS=',' read -ra PLUGINS <<< "$WP_PLUGINS"
    for plugin in "${PLUGINS[@]}"; do
        plugin=$(echo "$plugin" | xargs) # Trim whitespace
        if [ -n "$plugin" ]; then
            echo "Installing plugin: $plugin"
            docker compose exec -T wordpress wp --path=/var/www/html --allow-root plugin install "$plugin" --activate || true
        fi
    done
fi

# Activate local plugin
if [ -n "$PLUGIN_SLUG" ] && [ -d "../plugins-src/$PLUGIN_SLUG" ]; then
    echo "==> Activating local plugin: $PLUGIN_SLUG..."
    docker compose exec -T wordpress wp --path=/var/www/html --allow-root plugin activate "$PLUGIN_SLUG" || true
fi

# Ensure proper ownership
echo "==> Setting proper file permissions..."
docker compose exec -T wordpress chown -R www-data:www-data /var/www/html

echo ""
echo "=========================================="
echo "WordPress installation completed!"
echo "=========================================="
echo "Site URL: $WP_SITE_URL"
echo "Admin URL: $WP_SITE_URL/wp-admin"
echo "Username: $WP_ADMIN_USER"
echo "Password: $WP_ADMIN_PASSWORD"
echo "=========================================="
echo ""
