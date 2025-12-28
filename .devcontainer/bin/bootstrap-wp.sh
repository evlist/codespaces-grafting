#!/usr/bin/env bash
set -euo pipefail

# Env defaults (can be overridden by devcontainer.json containerEnv)
DB_NAME="${WP_DB_NAME:-wordpress}"
DB_USER="${WP_DB_USER:-wordpress}"
DB_PASS="${WP_DB_PASS:-wordpress}"
DB_HOST="${WP_DB_HOST:-127.0.0.1}"

TITLE="${WP_TITLE:-Codespace Dev}"
ADMIN_USER="${WP_ADMIN_USER:-admin}"
ADMIN_PASS="${WP_ADMIN_PASS:-admin}"
ADMIN_EMAIL="${WP_ADMIN_EMAIL:-admin@example.com}"

PLUGIN_SLUG="${PLUGIN_SLUG:-hello-world}"
DOCROOT="/var/www/html"
WORKSPACE="/workspaces/wp-plugin-codespace"

echo "[bootstrap] Starting MariaDB..."
# Initialize DB if missing
if [ ! -d /var/lib/mysql/mysql ]; then
  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql >/dev/null
fi
# Start MariaDB
mysqld_safe --datadir=/var/lib/mysql >/tmp/mysqld.log 2>&1 &

# Wait for DB
for i in {1..40}; do
  if mysqladmin ping --silent >/dev/null 2>&1; then break; fi
  sleep 0.5
done

echo "[bootstrap] Ensuring database and user..."
mysql -uroot <<SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

echo "[bootstrap] Preparing WordPress docroot at ${DOCROOT}..."
# Download WP if docroot looks empty
if [ -z "$(ls -A "$DOCROOT" 2>/dev/null || true)" ] || [ ! -f "$DOCROOT/wp-load.php" ]; then
  sudo -u www-data wp core download --path="$DOCROOT" --force
fi

# Configure wp-config.php
if [ ! -f "$DOCROOT/wp-config.php" ]; then
  sudo -u www-data wp config create \
    --path="$DOCROOT" \
    --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost="$DB_HOST" \
    --skip-check
fi

# Install site if not installed
if ! sudo -u www-data wp core is-installed --path="$DOCROOT" >/dev/null 2>&1; then
  sudo -u www-data wp core install \
    --path="$DOCROOT" \
    --url="http://localhost:8080" \
    --title="$TITLE" \
    --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL"
fi

echo "[bootstrap] Linking workspace plugin and mu-plugins..."
mkdir -p "$DOCROOT/wp-content/plugins" "$DOCROOT/wp-content"
# Link plugin source
if [ -d "$WORKSPACE/plugins-src/$PLUGIN_SLUG" ]; then
  ln -sfn "$WORKSPACE/plugins-src/$PLUGIN_SLUG" "$DOCROOT/wp-content/plugins/$PLUGIN_SLUG"
fi
# Link mu-plugins directory (replace with symlink)
if [ -d "$WORKSPACE/.devcontainer/wp-content/mu-plugins" ]; then
  rm -rf "$DOCROOT/wp-content/mu-plugins" || true
  ln -sfn "$WORKSPACE/.devcontainer/wp-content/mu-plugins" "$DOCROOT/wp-content/mu-plugins"
fi

echo "[bootstrap] Starting Apache..."
apache2ctl -D FOREGROUND >/tmp/apache.log 2>&1 &

# Optional: flush permalinks
sudo -u www-data wp rewrite flush --path="$DOCROOT" || true

echo "[bootstrap] Done. Visit http://localhost:8080"