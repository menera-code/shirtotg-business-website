#!/bin/bash
set -e

# 1. Fix Apache Port for Render
PORT="${PORT:-80}"
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf

# 2. Initialize and Start Local MariaDB
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing local MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi
service mariadb start

# 3. Create DB and User for WordPress
mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mysql -e "CREATE USER IF NOT EXISTS 'wpuser'@'localhost' IDENTIFIED BY 'wppassword';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# 4. Force WordPress to use the LOCAL database
export WORDPRESS_DB_HOST=127.0.0.1
export WORDPRESS_DB_USER=wpuser
export WORDPRESS_DB_PASSWORD=wppassword
export WORDPRESS_DB_NAME=wordpress
export WORDPRESS_TABLE_PREFIX=wp_

# 5. Hand off to official WordPress entrypoint
exec docker-entrypoint.sh apache2-foreground
