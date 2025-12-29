# Single-container dev image with Apache, MariaDB, PHP, WP-CLI, and GitHub CLI
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

ENV DEBIAN_FRONTEND=noninteractive

# Apache + MariaDB + PHP + extensions + prerequisites (includes Xdebug)
RUN apt-get update && apt-get install -y \
    apache2 mariadb-server \
    php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-xdebug \
    curl jq less unzip ca-certificates gnupg && \
    a2enmod rewrite && \
    \
    # Install GitHub CLI (gh) - requires adding repo then another apt-get update
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && apt-get install -y gh && \
    \
    rm -rf /var/lib/apt/lists/*

# WP-CLI
RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Apache conf: allow .htaccess in /var/www/html
RUN printf "<Directory /var/www/html>\n  AllowOverride All\n  Require all granted\n</Directory>\n" \
      > /etc/apache2/conf-available/wordpress.conf && \
    a2enconf wordpress

# Ensure docroot exists and owned by www-data
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Xdebug configuration (no apt operations here)
RUN PHPV="$(ls -1 /etc/php | head -n1)" && \
    mkdir -p /etc/php/${PHPV}/apache2/conf.d /etc/php/${PHPV}/cli/conf.d && \
    printf '%s\n' \
      'zend_extension=xdebug' \
      'xdebug.mode=debug,develop' \
      'xdebug.start_with_request=yes' \
      'xdebug.discover_client_host=1' \
      'xdebug.client_port=9003' \
      'xdebug.log=/tmp/xdebug.log' \
      > /etc/php/${PHPV}/apache2/conf.d/99-xdebug.ini && \
    cp /etc/php/${PHPV}/apache2/conf.d/99-xdebug.ini /etc/php/${PHPV}/cli/conf.d/99-xdebug.ini
        
# No bootstrap script copied; it lives in the workspace and runs via postStartCommand.