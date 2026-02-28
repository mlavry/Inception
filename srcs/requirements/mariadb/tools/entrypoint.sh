#!/bin/sh
set -eu

# 1) Dossier runtime du socket

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

