# WordPress Plugin Codespace

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/evlist/wp-plugin-codespace)

A ready-to-use GitHub Codespace for WordPress plugin development and debugging. This environment provides a fully configured WordPress installation with MySQL, WP-CLI, and helper scripts to streamline plugin development.

## 🚀 Quick Start

1. **Open in Codespaces**: Click the badge above or use the "Code" → "Create codespace on main" button
2. **Wait for setup**: The devcontainer will automatically install and configure WordPress (2-3 minutes)
3. **Access WordPress**: Open the forwarded port 8080 in your browser
4. **Login**: Use credentials `admin` / `admin` to access the admin panel
5. **Start developing**: Your plugin source code in `plugins-src/hello-world` is automatically mounted and activated

## 📋 Features

- **Docker Compose Setup**: WordPress, MySQL, and workspace containers
- **WP-CLI Integration**: Execute WordPress commands with helper scripts
- **MySQL Client Access**: Direct database access from the workspace
- **Automatic Installation**: Idempotent setup script configures WordPress on first run
- **Port Forwarding**: WordPress accessible via Codespaces preview (port 8080)
- **Plugin Mounting**: Local plugin directory automatically mounted in WordPress
- **Sample Plugin**: "Hello World" plugin included with examples of:
  - Shortcodes
  - REST API endpoints
  - Admin bar integration
  - WP-CLI commands
  - Activation/deactivation hooks

## 🛠️ Configuration

Environment variables can be customized in `.devcontainer/.env`:

### WordPress & MySQL Versions
```bash
WP_VERSION=latest          # WordPress version
MYSQL_VERSION=8.0          # MySQL version
```

### Database Configuration
```bash
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD=wordpress
```

### WordPress Site Configuration
```bash
WP_HOST_PORT=8080
WP_SITE_URL=http://localhost:8080
WP_SITE_TITLE=WordPress Plugin Development
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin
WP_ADMIN_EMAIL=admin@example.com
WP_LOCALE=en_US
```

### Plugin Configuration
```bash
WP_PLUGINS=                # Comma-separated list of plugins to install from WordPress.org
PLUGIN_SLUG=hello-world    # Local plugin directory name in plugins-src/
```

## 📁 Project Structure

```
wp-plugin-codespace/
├── .devcontainer/
│   ├── devcontainer.json       # Codespaces configuration
│   ├── docker-compose.yml      # Multi-container setup
│   ├── Dockerfile              # WordPress container with WP-CLI
│   ├── .env                    # Environment variables
│   └── bin/
│       ├── wp.sh               # WP-CLI wrapper script
│       ├── db.sh               # MySQL client wrapper script
│       └── wp-install.sh       # WordPress installation script
└── plugins-src/
    └── hello-world/            # Sample plugin (mounted in WordPress)
        ├── hello-world.php
        └── README.md
```

## 🔧 Helper Scripts

### WP-CLI Commands

Execute WP-CLI commands in the WordPress container:

```bash
# Basic usage
.devcontainer/bin/wp.sh <command>

# Examples
.devcontainer/bin/wp.sh plugin list
.devcontainer/bin/wp.sh user list
.devcontainer/bin/wp.sh post create --post_title="Test Post" --post_status=publish
.devcontainer/bin/wp.sh hello-world greet
```

### MySQL Client

Access the MySQL database:

```bash
# Interactive shell
.devcontainer/bin/db.sh

# Execute query
.devcontainer/bin/db.sh -e "SHOW TABLES;"
```

### WordPress Installation

Re-run the installation script (idempotent):

```bash
bash .devcontainer/bin/wp-install.sh
```

## 🔌 Developing Your Plugin

### Using the Sample Plugin

The included "Hello World" plugin demonstrates common WordPress features:

1. **Shortcode**: Add `[hello_world name="Alice"]` to any post/page
2. **REST API**: Visit `/wp-json/hello/v1/ping` to test the endpoint
3. **WP-CLI**: Run `.devcontainer/bin/wp.sh hello-world status`
4. **Admin Bar**: Look for "👋 Hello World" in the admin toolbar

See `plugins-src/hello-world/README.md` for detailed usage.

### Creating Your Own Plugin

1. Create a new directory in `plugins-src/`:
   ```bash
   mkdir -p plugins-src/my-plugin
   ```

2. Update `.devcontainer/.env`:
   ```bash
   PLUGIN_SLUG=my-plugin
   ```

3. Create your plugin file:
   ```bash
   touch plugins-src/my-plugin/my-plugin.php
   ```

4. Rebuild the devcontainer or restart it to mount the new plugin

5. Activate your plugin:
   ```bash
   .devcontainer/bin/wp.sh plugin activate my-plugin
   ```

## 🐛 Debugging

### View WordPress Logs

```bash
.devcontainer/bin/wp.sh eval 'echo WP_CONTENT_DIR . "/debug.log";'
docker compose -f .devcontainer/docker-compose.yml exec wordpress tail -f /var/www/html/wp-content/debug.log
```

### Check Container Status

```bash
docker compose -f .devcontainer/docker-compose.yml ps
```

### Restart Services

```bash
docker compose -f .devcontainer/docker-compose.yml restart wordpress
```

### Access Container Shell

```bash
# WordPress container
docker compose -f .devcontainer/docker-compose.yml exec wordpress bash

# Database container
docker compose -f .devcontainer/docker-compose.yml exec db bash
```

## 🔐 Security Note

**This environment is for development and testing only.** Do not use in production. Default credentials are intentionally simple for development convenience.

## 📚 Additional Resources

- [WordPress Plugin Handbook](https://developer.wordpress.org/plugins/)
- [WP-CLI Commands](https://developer.wordpress.org/cli/commands/)
- [WordPress REST API](https://developer.wordpress.org/rest-api/)
- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)

## 📄 License

This project is licensed under the GPL-2.0+ License - see the [LICENSE](LICENSE) file for details.
