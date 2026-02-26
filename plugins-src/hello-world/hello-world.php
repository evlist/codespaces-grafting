<?php
/**
 * Plugin bootstrap file for Local Hello World.
 *
 * SPDX-FileCopyrightText: 2025, 2026 Eric van der Vlist <vdv@dyomedea.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later OR MIT
 *
 * @package LocalHelloWorld
 */

/**
 * Plugin Name: Local Hello World
 * Plugin URI: https://github.com/evlist/codespaces-grafting
 * Description: A sample plugin for codespaces-grafting, a lightweight, shareable "live Codespace" / devcontainer scaffold, demonstrating WordPress plugin development features including shortcodes, REST API, admin notices, and WP-CLI commands.
 * Version: 1.0.0
 * Author: Eric van der Vlist
 * Author URI: https://github.com/evlist
 * License: GPL-2.0+
 * License URI: http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain: local-hello-world
 */

// If this file is called directly, abort.
if ( ! defined( 'WPINC' ) ) {
	die;
}

define( 'LOCAL_HELLO_WORLD_PLUGIN_FILE', __FILE__ );

/**
 * Activation hook
 */
function local_hello_world_activate() {
	add_option( 'local_hello_world_activated', current_time( 'mysql' ) );
	flush_rewrite_rules();
}
register_activation_hook( __FILE__, 'local_hello_world_activate' );

/**
 * Deactivation hook
 */
function local_hello_world_deactivate() {
	delete_option( 'local_hello_world_activated' );
	flush_rewrite_rules();
}
register_deactivation_hook( __FILE__, 'local_hello_world_deactivate' );

/**
 * Shortcode: [local_hello_world]
 * Displays a customizable local hello world message
 *
 * @param array $atts Shortcode attributes.
 *
 * @return string
 */
function local_hello_world_shortcode( $atts ) {
	$atts = shortcode_atts(
		array(
			'name'  => 'World',
			'class' => 'local-hello-world-message',
		),
		$atts,
		'local_hello_world'
	);

	$name  = esc_html( $atts['name'] );
	$class = esc_attr( $atts['class'] );

	return sprintf(
		'<div class="%s"><p>Hello, %s! This is a message from the Local Hello World plugin.</p></div>',
		$class,
		$name
	);
}
add_shortcode( 'local_hello_world', 'local_hello_world_shortcode' );

/**
 * REST API endpoint: /wp-json/hello/v1/ping
 * Returns a simple JSON response
 */
function local_hello_world_register_rest_route() {
	register_rest_route(
		'hello/v1',
		'/ping',
		array(
			'methods'             => 'GET',
			'callback'            => 'local_hello_world_rest_callback',
			'permission_callback' => '__return_true',
		)
	);
}
add_action( 'rest_api_init', 'local_hello_world_register_rest_route' );

/**
 * REST callback for hello/v1/ping.
 *
 * @param WP_REST_Request $request REST request.
 *
 * @return WP_REST_Response
 */
function local_hello_world_rest_callback( $request ) {
	$name = $request->get_param( 'name' );
	if ( empty( $name ) ) {
		$name = 'World';
	}

	return new WP_REST_Response(
		array(
			'success'   => true,
			'message'   => sprintf( 'Hello, %s!', sanitize_text_field( $name ) ),
			'timestamp' => current_time( 'mysql' ),
		),
		200
	);
}

/**
 * Admin notice
 * Displays a notice on the admin dashboard
 */
function local_hello_world_admin_notice() {
	$screen = get_current_screen();
	if ( 'dashboard' === $screen->id ) {
		$activated = get_option( 'local_hello_world_activated' );
		?>
		<div class="notice notice-success is-dismissible">
			<p><strong>Local Hello World Plugin:</strong> Plugin is active and running! 
			<?php if ( $activated ) : ?>
				Activated on <?php echo esc_html( date_i18n( 'F j, Y \a\t g:i a', strtotime( $activated ) ) ); ?>
			<?php endif; ?>
			</p>
		</div>
		<?php
	}
}
add_action( 'admin_notices', 'local_hello_world_admin_notice' );

/**
 * Admin bar node
 * Adds a custom node to the admin bar
 *
 * @param WP_Admin_Bar $wp_admin_bar Admin bar instance.
 *
 * @return void
 */
function local_hello_world_admin_bar_node( $wp_admin_bar ) {
	if ( ! current_user_can( 'manage_options' ) ) {
		return;
	}

	$args = array(
		'id'    => 'local-hello-world',
		'title' => '👋 Local Hello World',
		'href'  => admin_url( 'plugins.php' ),
		'meta'  => array(
			'class' => 'local-hello-world-admin-bar',
			'title' => 'Local Hello World Plugin',
		),
	);
	$wp_admin_bar->add_node( $args );

	// Add a submenu item.
	$wp_admin_bar->add_node(
		array(
			'id'     => 'local-hello-world-test',
			'parent' => 'local-hello-world',
			'title'  => 'Test REST API',
			'href'   => rest_url( 'hello/v1/ping' ),
			'meta'   => array(
				'target' => '_blank',
			),
		)
	);
}
add_action( 'admin_bar_menu', 'local_hello_world_admin_bar_node', 100 );

/**
 * Footer marker
 * Adds an HTML comment to the footer
 */
function local_hello_world_footer_marker() {
	echo '<!-- Local Hello World Plugin Active (v1.0.0) -->' . "\n";
}
add_action( 'wp_footer', 'local_hello_world_footer_marker' );
add_action( 'admin_footer', 'local_hello_world_footer_marker' );

if ( defined( 'WP_CLI' ) && WP_CLI ) {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-local-hello-world-cli-command.php';
	WP_CLI::add_command( 'local-hello-world', 'Local_Hello_World_CLI_Command' );
}

/**
 * Add inline styles for the shortcode
 */
function local_hello_world_enqueue_styles() {
	if ( ! is_admin() ) {
		wp_add_inline_style(
			'wp-block-library',
			'
            .local-hello-world-message {
                padding: 20px;
                background: #f0f0f1;
                border-left: 4px solid #2271b1;
                margin: 20px 0;
            }
            .local-hello-world-message p {
                margin: 0;
                color: #2c3338;
            }
        '
		);
	}
}
add_action( 'wp_enqueue_scripts', 'local_hello_world_enqueue_styles' );
