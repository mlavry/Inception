#!/bin/sh
set -eu

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

echo "STEP 1: script started"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

echo "STEP 2: checking wordpress database dir"

: "${MYSQL_ROOT_PASSWORD:?Missing MYSQL_ROOT_PASSWORD}"
: "${MYSQL_DATABASE:?Missing MYSQL_DATABASE}"
: "${MYSQL_USER:?Missing MYSQL_USER}"
: "${MYSQL_PASSWORD:?Missing MYSQL_PASSWORD}"

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	echo "STEP 3: first init detected"

	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	echo "STEP 4: install-db done"

	mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
	pid="$!"
	echo "STEP 5: temp mysqld started"

	i=0
	while ! mariadb-admin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
		i=$((i + 1))
		if [ "$i" -ge 30 ]; then
			echo "STEP FAIL: startup timeout"
			exit 1
		fi
		sleep 1
	done
	echo "STEP 6: temp mysqld ready"

	env -u MYSQL_HOST -u MYSQL_TCP_PORT -u MYSQL_UNIX_PORT \
	mariadb --protocol=SOCKET --socket=/run/mysqld/mysqld.sock -uroot -e "
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
	FLUSH PRIVILEGES;
"

echo "STEP 7: SQL executed"

	if ! mariadb-admin --socket=/run/mysqld/mysqld.sock shutdown >/dev/null 2>&1; then
		kill "$pid" 2>/dev/null || true
	fi
	wait "$pid" 2>/dev/null || true
	echo "STEP 8: init done"
fi

echo "STEP 10: final mysqld exec"
exec mysqld --user=mysql --datadir=/var/lib/mysql
