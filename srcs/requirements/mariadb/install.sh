#!/bin/sh

if test -f "/var/lib/mysql/mysql/user.frm"
then
	echo "Already installed!"
	exit 0
fi

# Install Database
mysql_install_db --user=mysql --datadir=/var/lib/mysql
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*skip-networking.*|#skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf

# Create new working directory
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Secure Installation
mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap << EOF

-- Reload Privilege Tables
FLUSH PRIVILEGES;

-- Set root Password
SET PASSWORD FOR 'root'@localhost = PASSWORD('$MYSQL_ROOT_PASSWORD');

-- Remove anonymous Users
DELETE FROM mysql.user WHERE User='';

-- Remove Remote root
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Remove test Database
DROP DATABASE IF EXISTS test;

-- Insert User Database
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

-- Insert New User
GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

-- Reload Privilege Tables
FLUSH PRIVILEGES;

EOF
