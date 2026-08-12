#!/bin/bash

## install python packages
apk add python3 py3-pip

## create virtual environment
cd ~
python3 -m venv .
source bin/activate
mkdir app

## clone the application and install dependencies
git clone https://github.com/alpeon/test-app.git app
cd app
pip install -r requirements.txt

## Fix variables
sed -i 's/DB_ROOT/DB_USER/g' app/app.py
sed -i 's/MYSQL_ROOT_PASSWORD/DB_USER_PASSWORD/g' app/app.py
sed -i 's/MYSQL_DATABASE/APP_DATABASE/g' app/app.py

## install cloudflared cli

curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/bin/cloudflared
chmod +x /usr/bin/cloudflared