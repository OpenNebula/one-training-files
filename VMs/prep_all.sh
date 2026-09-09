#!/bin/sh
set -e

apk update
apk add --no-cache mariadb mariadb-client

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

rm -rf /var/lib/mysql/*
chown -R mysql:mysql /var/lib/mysql

cat > /etc/my.cnf.d/server.cnf <<EOF
[mysqld]
bind-address = 0.0.0.0
datadir = /var/lib/mysql
socket = /run/mysqld/mysqld.sock
pid-file = /run/mysqld/mariadb.pid
EOF

sed -i 's/skip-networking//g' /etc/my.cnf.d/mariadb-server.cnf

mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

rc-service mariadb start

mysql -u root -e 'CREATE USER IF NOT EXISTS "appuser"@"localhost" IDENTIFIED BY "appPassword";'
mysql -u root -e 'CREATE DATABASE app;'
mysql -u root -e 'GRANT ALL PRIVILEGES ON app.* TO 'appuser'@"localhost";'

cd ~
apk add python3 py3-pip git
python3 -m venv .
source ~/bin/activate
git clone https://github.com/alpeon/test-app.git app
cd app
pip install -r requirements.txt