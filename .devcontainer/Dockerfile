ARG WP_VERSION=latest
FROM wordpress:${WP_VERSION}

# Install required packages
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    curl \
    less \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Ensure proper ownership
RUN chown -R www-data:www-data /var/www/html

# Set working directory
WORKDIR /var/www/html
