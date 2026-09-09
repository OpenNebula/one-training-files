# List of contextualization parameters

ONE_SERVICE_PARAMS=(
    'MYSQL_DATABASE'            'configure' 'Database name'                          ''
    'DB_ROOT'            'configure' 'Database user'                                     ''
    'MYSQL_ROOT_PASSWORD'            'configure' 'Database pass'                             ''
)

### Appliance metadata ###############################################
ONE_SERVICE_NAME='Service FlaskApp - Database'
ONE_SERVICE_VERSION='0.0.1'   #latest
ONE_SERVICE_BUILD=$(date +%s)
ONE_SERVICE_SHORT_DESCRIPTION='Appliance with the database and FlaskApp'
ONE_SERVICE_DESCRIPTION=$(cat <<EOF
An appliance that comes pre-installed with MariaDB and based on the Ubuntu Linux. 
Made specifically for OpenNebula Certified Expert training to showcase one-apps.
EOF
)

### Contextualization defaults #######################################
MYSQL_DATABASE="${MYSQL_DATABASE:appdb}"
DB_ROOT="${DB_ROOT:appuser}"
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:appdbpassword}"
DB_HOST='127.0.0.1'

###############################################################################
###############################################################################
###############################################################################

#
# service implementation
#

service_install()
{   
    
    setup_flask
    systemctl enable --now mariadb

    msg info "INSTALL FINISHED"

    return 0
}

service_configure()
{
    
    cfg_db

    msg info "CONFIGURATION FINISHED"

    return 0

}

service_bootstrap()
{
 return 0
}

setup_flask()
{
    cd ~
    source bin/activate
    mkdir app
    git clone https://github.com/alpeon/test-app.git app
    cd app
    pip install -r requirements.txt

}



cfg_db()
{
    mysql -u root -e "CREATE USER IF NOT EXISTS '${DB_ROOT}'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${DB_ROOT}'@'%';"
}