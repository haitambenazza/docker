#!/bin/bash
set -e

DB_ROOT_PASS=$(cat /run/secrets/root_mariadb_secret_password)
USER_PASSWD=$(cat /run/secrets/mariadb_secret_password)

echo "mariadb init..."
echo "MARIADB_NAME: ${MARIADB_NAME}"
echo "DB_USER: ${DB_USER}"

# create dir for Unix socket for mariadb and set perms
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

if [ ! -d "/var/lib/mysql/.init_test" ]; then
    echo "Initializing data directory..."
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
    chmod 755 /var/lib/mysql
    touch .init_test # creating a file so the volume will be empty 
    
    mysql_install_db --datadir=/var/lib/mysql/ --user=mysql
    
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    MYSQL_PID=$!
    
    # Wait for mariadb/mysql to start
    while ! mysqladmin ping --silent; do
        echo "Still waiting..."
        sleep 1
    done
    echo "mariadb is up!"
    
    echo "Creating wordpress and user..."
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MARIADB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${USER_PASSWD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_NAME}\`.* TO '${DB_USER}'@'%';
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${USER_PASSWD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_NAME}\`.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
    echo "Stopping temporary MariaDB instance..."
    mysqladmin -u root -p"${DB_ROOT_PASS}" shutdown
    wait $MYSQL_PID
    
    echo "Database initialization complete!"
else
    echo "Database already initialized, skipping setup."
fi

# Ensure proper ownership before starting
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /run/mysqld

echo "Starting MariaDB..."
exec mysqld --user=mysql