# wp-plugin-codespace
A codespace to debug WordPress plugins

This codespace is providing a ready to use WordPress installation which can use used to debug plugins.

## Requirements

* WordPress and MySQL containers (versions provided as env vars, default = latest)
* The WP container should include wp-cli
* Both containers should be accessible through docker commands from the devcontainer.
* Devcontainer should include shell scripts to execute wp-cli commands (in the WP container) and mysql cli commands (in the MySQL container).
* Devcontainer should include a shell script to complete the WP installation and configuration through wp-cli (database creation, language setup, plugins installtion, ...) based on env vars.
* A local directory with the source code of a plugin should be mounted in the WP container.
* WP should be configured to work with the codespace forwarded port.
* This codespace in for development and testing only and should not be usedin prodoction.
