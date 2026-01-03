#!/bin/bash
set -e 

DIR=/var/www/html  # Missing leading slash!
ROOT_PASSWD=$(cat /run/secrets/root_wordpress_secret_password)
DB_USER_PASSWD=$(cat /run/secrets/mariadb_secret_password)  # Missing leading slash!
USER_PASSWD=$(cat /run/secrets/wordpress_secret_password)

# Wait for MariaDB to be ready
while ! mariadb-admin ping -h"$DB_HOST" --silent; do
    echo "waiting for mariadb..."
    sleep 3
done 

echo "MariaDB is ready!"

if [ ! -f "${DIR}/wp-config.php" ]; then
    echo "Setting up WordPress..."
    
    mkdir -p ${DIR}
    
    # Download WordPress core
    wp core download --path=${DIR} --allow-root
    
    cd ${DIR}
    
    # Create wp-config.php
    wp config create --allow-root \
        --dbname=${MARIADB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_USER_PASSWD} \
        --dbhost=${DB_HOST}:${DB_PORT}
    
    # Install WordPress
    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title="${SITE_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASS} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email
    
    # Create additional user
    wp user create --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASS} \
        --role=author
    
    echo "WordPress setup complete!"
else
    echo "WordPress already configured."
fi

exec php-fpm8.2 -F