#!/bin/bash


set -e 

DIR=var/www/html
ROOT_PASSWD=$(cat /run/secrets/root_wd_passwd)
DB_USER_PASSWD=$(cat run/secrets/mariadb_secret_password)
USER_PASSWD=$(cat run/secrets/wordpress_secret_password)

mdkir -p ${DIR}
wp core download  --path=${DIR} --allow-root
cd ${DIR}
wp config create --allow-root --dbname=${MARIADB_NAME} --dbuser=${DB_USER} --dbpass=${DB_USER_PASSWD} \
             --dbhost=${DB_HOST}:${DB_PORT}

wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title="${SITE_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASS} \
        --admin_email=${WP_ADMIN_EMAIL} --skip-email

wp user create --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASS} \
        --role=author
    
exec php-fpm8.2 -F