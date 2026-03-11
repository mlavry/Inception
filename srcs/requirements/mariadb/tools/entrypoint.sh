#!/bin/sh
set -eu

# 1) Dossier runtime du socket

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# 2) Si /var/lib/mysql/mysql n'existe pas => volume vide => 1er lancement

if [ ! -d /var/lib/mysql/mysql ]; then
	echo "MariaDB: first init..."

	# Initialise les fichiers système MariaDB dans le volume
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	# Démarre temporairement MariaDB (local uniquement) pour exécuter du SQL
	mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
	pid="$!"

	# Attend que MariaDB réponde 
	i=0
	while ! mariadb-admin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
		i=$((i + 1))
		if [ "$i" -ge 30 ]; then
			echo "MariaDB: startup timeout"
			exit 1
		fi
		sleep 1
	done

	# Vérifie que les variables existent (sinon stop net)
	: "${MYSQL_ROOT_PASSWORD:?Missing MYSQL_ROOT_PASSWORD}"
	: "${MYSQL_DATABASE:?Missing MYSQL_DATABASE}"
	: "${MYSQL_USER:?Missing MYSQL_USER}"
	: "${MYSQL_PASSWORD:?Missing MYSQL_PASSWORD}"

	# Configure root + crée DB + user WordPress
	mariadb --socket=/run/mysqld/mysqld.sock <<-SQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		DELETE FROM mysql.user WHERE User='${MYSQL_USER}';
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
		SQL

	# Arret du serveur temporaire
	if ! mariadb-admin --socket=/run/mysqld/mysqld.sock shutdown >/dev/null 2>&1; then
		kill "$pid" 2>/dev/null || true
	fi
	wait "$pid" 2>/dev/null || true
	echo "MariaDB: init done."
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql
