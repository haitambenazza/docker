#!/bin/bash

set -e #exiting in case of errors

DB_ROOT_PASS=$(cat run/secrets/root_mariadb_secret_password)
DB_PASS=$(cat run/secrets/mariadb_secret_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "init data dir..."
    mysql_install_db --datadir=/var/lib/mysql/ --user=mysql
    echo "starting mysql service..."
    service mariadb start
    mariadb -u root  << EOF
CREATE DATABASE IF NOT EXISTS \`${MARIADB_NAME}\`;
CREATE USER IF NOT EXISTS '${Db_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
GRANT ALL PRIVILEGES ON \`${MARIADB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    service mariadb stop
fi

exec mysqld_safe