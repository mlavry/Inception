#!/bin/sh
set -eu

MYSQL_PASSWORD="$(cat /run/secrets/db_password)"
MYSQL_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
INIT_MARKER="/var/lib/mysql/.inception_init_done"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

: "${MYSQL_DATABASE:?Missing MYSQL_DATABASE}"
: "${MYSQL_USER:?Missing MYSQL_USER}"
: "${MYSQL_PASSWORD:?Missing MYSQL_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:?Missing MYSQL_ROOT_PASSWORD}"

if [ ! -f "$INIT_MARKER" ]; then
	echo "STEP 1: first init"

	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	echo "STEP 2: bootstrap SQL"

	mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap <<EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	touch "$INIT_MARKER"
	chown mysql:mysql "$INIT_MARKER"

	echo "STEP 3: init done"
fi

echo "STEP 4: starting mariadb"
exec mysqld --user=mysql --datadir=/var/lib/mysql
