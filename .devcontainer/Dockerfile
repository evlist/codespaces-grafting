# Single-container dev image with Apache, MariaDB, PHP, and WP-CLI
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 mariadb-server \
    php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip \
    curl jq less unzip ca-certificates && \
    a2enmod rewrite && \
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

# Helper script to start services and bootstrap WP
# COPY ./bin/bootstrap-wp.sh /usr/local/bin/bootstrap-wp.sh
# RUN chmod +x /usr/local/bin/bootstrap-wp.sh

# The devcontainer runtime keeps the container alive; services run in postStartCommand