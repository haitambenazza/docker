#!/bin/bash
set -e

DB_ROOT_PASS=$(cat /run/secrets/root_mariadb_secret_password)
USER_PASSWD=$(cat /run/secrets/mariadb_secret_password)

echo "=== MariaDB Initialization ==="
echo "MARIADB_NAME: ${MARIADB_NAME}"
echo "DB_USER: ${DB_USER}"
echo "==============================="

# Create the socket directory and set permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing data directory..."
    
    # Ensure the data directory exists and has proper ownership/permissions
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
    chmod 755 /var/lib/mysql
    
    # Initialize database
    mysql_install_db --datadir=/var/lib/mysql/ --user=mysql
    
    echo "Starting MariaDB service temporarily..."
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    MYSQL_PID=$!
    
    # Wait for MySQL to start
    echo "Waiting for MariaDB to start..."
    for i in {1..30}; do
        if mysqladmin ping --silent 2>/dev/null; then
            echo "MariaDB is up!"
            break
        fi
        echo "Waiting... ($i/30)"
        sleep 1
    done
    
    echo "Creating database and user..."
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MARIADB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${USER_PASSWD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_NAME}\`.* TO '${DB_USER}'@'%';
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${USER_PASSWD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_NAME}\`.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
    
    echo "Verifying user creation..."
    mysql -u root -e "SELECT User, Host FROM mysql.user WHERE User = '${DB_USER}';"
    
    echo "Setting root password..."
    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
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