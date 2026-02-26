=== Local Hello World ===
Contributors: evlist
Tags: shortcode, rest-api, wp-cli, admin
Requires at least: 6.4
Tested up to: 6.9
Requires PHP: 8.1
Stable tag: 1.0.0
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

A sample WordPress plugin demonstrating shortcode, REST API endpoint, admin integrations, and WP-CLI commands.

== Description ==

Local Hello World is a demonstration plugin showing common WordPress extension patterns:

* Shortcode output with sanitized attributes.
* A REST API endpoint at `/wp-json/hello/v1/ping`.
* Dashboard admin notice and admin bar integration.
* Footer marker for quick activation checks.
* WP-CLI commands for greet, info, and API testing.
* Activation/deactivation hooks for basic lifecycle management.

== Installation ==

1. Upload the plugin folder to the `/wp-content/plugins/` directory.
2. Activate the plugin through the "Plugins" menu in WordPress.
3. Add `[local_hello_world]` to a post or page to test output.

== Frequently Asked Questions ==

= How do I test the REST API endpoint? =

Open `/wp-json/hello/v1/ping` on your site, or add `?name=Developer`.

= Which shortcode is available? =

Use `[local_hello_world]` or `[local_hello_world name="Developer"]`.

== Changelog ==

= 1.0.0 =
* Initial release.

== Upgrade Notice ==

= 1.0.0 =
Initial release.
