<?php
/**
 * WP-CLI command implementation for Local Hello World.
 *
 * @package LocalHelloWorld
 */

/**
 * WP-CLI command class for Local Hello World.
 */
class Local_Hello_World_CLI_Command {
	/**
	 * Prints a greeting message.
	 *
	 * ## OPTIONS
	 *
	 * [<name>]
	 * : The name to greet.
	 * ---
	 * default: World
	 * ---
	 *
	 * ## EXAMPLES
	 *
	 *     wp local-hello-world greet
	 *     wp local-hello-world greet "Developer"
	 *
	 * @when after_wp_load
	 *
	 * @param array $args Positional arguments.
	 * @param array $_assoc_args Associative arguments.
	 *
	 * @return void
	 */
	public function greet( $args, $_assoc_args ) {
		unset( $_assoc_args );

		$name = isset( $args[0] ) ? $args[0] : 'World';
		WP_CLI::success( sprintf( 'Hello, %s!', $name ) );
	}

	/**
	 * Shows plugin information.
	 *
	 * ## EXAMPLES
	 *
	 *     wp local-hello-world info
	 *
	 * @when after_wp_load
	 *
	 * @param array $_args Positional arguments.
	 * @param array $_assoc_args Associative arguments.
	 *
	 * @return void
	 */
	public function info( $_args, $_assoc_args ) {
		unset( $_args, $_assoc_args );

		$plugin_data = get_plugin_data( LOCAL_HELLO_WORLD_PLUGIN_FILE );
		WP_CLI::line( 'Plugin Information:' );
		WP_CLI::line( '- Name: ' . $plugin_data['Name'] );
		WP_CLI::line( '- Version: ' . $plugin_data['Version'] );
		WP_CLI::line( '- Description: ' . $plugin_data['Description'] );

		$activated = get_option( 'local_hello_world_activated' );
		if ( $activated ) {
			WP_CLI::line( '- Activated: ' . $activated );
		}

		WP_CLI::success( 'Plugin is active and working!' );
	}

	/**
	 * Tests the REST API endpoint.
	 *
	 * ## OPTIONS
	 *
	 * [--name=<name>]
	 * : The name to include in the request.
	 * ---
	 * default: CLI
	 * ---
	 *
	 * ## EXAMPLES
	 *
	 *     wp local-hello-world test-api
	 *     wp local-hello-world test-api --name="Developer"
	 *
	 * @when after_wp_load
	 *
	 * @param array $_args Positional arguments.
	 * @param array $assoc_args Associative arguments.
	 *
	 * @return void
	 */
	public function test_api( $_args, $assoc_args ) {
		$name = isset( $assoc_args['name'] ) ? $assoc_args['name'] : 'CLI';
		$url  = rest_url( 'hello/v1/ping?name=' . rawurlencode( $name ) );

		WP_CLI::line( 'Testing REST API endpoint...' );
		WP_CLI::line( 'URL: ' . $url );

		$response = wp_remote_get( $url );

		if ( is_wp_error( $response ) ) {
			WP_CLI::error( 'API request failed: ' . $response->get_error_message() );
		}

		$body = json_decode( wp_remote_retrieve_body( $response ), true );

		if ( isset( $body['success'] ) && $body['success'] ) {
			WP_CLI::success( 'API Response: ' . $body['message'] );
			WP_CLI::line( 'Timestamp: ' . $body['timestamp'] );
		} else {
			WP_CLI::error( 'Unexpected API response' );
		}
	}
}
