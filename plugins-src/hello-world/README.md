# Hello World Plugin

A sample WordPress plugin demonstrating various WordPress development features.

## Features

This plugin demonstrates:

- **Shortcode**: `[hello_world]` shortcode with parameters
- **REST API**: `/wp-json/hello/v1/ping` endpoint
- **Admin Features**: Admin notices and admin bar integration
- **Footer Marker**: HTML comment in footer
- **WP-CLI Commands**: Custom WP-CLI commands
- **Hooks**: Activation and deactivation hooks

## Usage

### Shortcode

Use the `[hello_world]` shortcode in any post or page:

```
[hello_world]
```

With optional parameters:

```
[hello_world name="Alice" style="fancy"]
```

**Parameters:**
- `name` (optional): The name to greet (default: "World")
- `style` (optional): Custom style attribute (default: "default")

### REST API

Test the REST API endpoint:

```bash
curl http://localhost:8080/wp-json/hello/v1/ping
```

Or visit in your browser:
```
http://localhost:8080/wp-json/hello/v1/ping
```

**Response:**
```json
{
  "message": "Hello World! Plugin is working.",
  "timestamp": "2024-01-01 12:00:00",
  "version": "1.0.0"
}
```

### WP-CLI Commands

The plugin registers custom WP-CLI commands:

#### Greet Command

```bash
# From the workspace container
.devcontainer/bin/wp.sh hello-world greet

# With a custom name
.devcontainer/bin/wp.sh hello-world greet Alice
```

#### Status Command

Check plugin status:

```bash
.devcontainer/bin/wp.sh hello-world status
```

This will show:
- Plugin version
- Shortcode registration status
- REST endpoint registration status

### Admin Features

When logged in as an administrator:

1. **Admin Bar**: Look for the "👋 Hello World" item in the admin bar
2. **Admin Notices**: Plugin activation notice and info messages on the plugins page
3. **Footer Marker**: An HTML comment is added to both frontend and admin footers

## Testing

### Test Shortcode

1. Create a new post or page
2. Add the shortcode `[hello_world]`
3. Publish and view the page
4. You should see "Hello, World! 👋"

### Test REST API

Using curl:
```bash
curl http://localhost:8080/wp-json/hello/v1/ping
```

Using the helper script:
```bash
# From workspace container
curl $(docker compose -f .devcontainer/docker-compose.yml port wordpress 80)/wp-json/hello/v1/ping
```

### Test WP-CLI

```bash
# Test greet command
.devcontainer/bin/wp.sh hello-world greet

# Test status command
.devcontainer/bin/wp.sh hello-world status
```

### Test Footer Marker

View page source (frontend or admin) and look for:
```html
<!-- Hello World Plugin v1.0.0 - Active -->
```

## Development

This plugin is designed for development and testing in a WordPress Codespace environment.

### File Structure

```
hello-world/
├── hello-world.php    # Main plugin file
└── README.md          # This file
```

### Debugging

The plugin logs activation and deactivation events to the WordPress debug log. Enable debugging in `wp-config.php`:

```php
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
```

Then check the log:
```bash
.devcontainer/bin/wp.sh eval 'echo WP_CONTENT_DIR . "/debug.log";'
```

## License

GPL-2.0+
