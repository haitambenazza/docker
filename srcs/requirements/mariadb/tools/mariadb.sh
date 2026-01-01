#!/bin/bash

set -e #exiting in case of errors

DB_ROOT_PASS=$(cat run/secrets/root_mariadb_secret_password)
DB_PASS=$(cat run/secrets/mariadb_secret_password)

if [ -d "/var/lib/mysql/mysql" ]; then
    echo "init dir..."
    # mysql_install_db --datadir=/var/lib/mysql/
    # echo "starting mysql service..."
    # service mysql start
    # mariadb -u root    # you need to log as root to be able to create db and users
fi

# create db for wordpress
# create user identified by username and password
# grant priviliges to user 
# add password to root
# flush priveleges
# stop mariadb
exec mysqld_safe