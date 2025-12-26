ARG WP_VERSION=latest
FROM wordpress:${WP_VERSION}

# Install MySQL client and wget
RUN apt-get update && \
    apt-get install -y default-mysql-client wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Fix ownership of webroot
RUN chown -R www-data:www-data /var/www/html

# Set working directory
WORKDIR /var/www/html
