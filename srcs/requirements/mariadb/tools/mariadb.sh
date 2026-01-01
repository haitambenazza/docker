#!/bin/bash

set -e #exiting in case of errors

DB_ROOT_PASS=$(cat run/secrets/root_mariadb_secret_password)
USER_PASSWD=$(cat run/secrets/mariadb_secret_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "init data dir..."
    mysql_install_db --datadir=/var/lib/mysql/ --user=mysql
    echo "starting mysql service..."
    service mariadb start
    mariadb -u root  << EOF
CREATE DATABASE IF NOT EXISTS \`${MARIADB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${USER_PASSWD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_NAME}\`.* TO '${DB_USER}'@'%';
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${USER_PASSWD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_NAME}\`.* TO '${DB_USER}'@'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
FLUSH PRIVILEGES;
EOF
    service mariadb stop
fi

exec mysqld_safe