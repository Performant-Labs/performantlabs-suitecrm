#!/bin/bash
set -e
set -x

# Function to request user input
get_input() {
    read -p "$1: " value
    echo $value
}

# Function to automatically get the internal IP
get_internal_ip() {
    ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '^127' | head -n1
}

# Request user information
db_user=${SUITECRM_DATABASE_USER:-bn_suitecrm}
db_pass=${SUITECRM_DATABASE_PASSWORD:-bitnami123}
db_name=${MARIADB_DATABASE:-CRM}

# Note: mysql_secure_installation requires manual interaction
echo "Execute 'mysql_secure_installation' manually after the script finishes."

# Configure database
echo "Configuring main database..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $db_name CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'%';
FLUSH PRIVILEGES;
EOF

# Verificar se o banco de dados foi criado
if mysql -u root -e "USE $db_name"; then
    echo "Database $db_name created successfully."
else
    echo "Failed to create database $db_name. Please check MySQL root permissions."
    exit 1
fi

# Verificar se o usuário foi criado
if mysql -u root -e "SELECT User FROM mysql.user WHERE User='$db_user';" | grep -q "$db_user"; then
    echo "User $db_user created successfully."
else
    echo "Failed to create user $db_user. Please check MySQL root permissions."
    exit 1
fi

echo "The script has finished. Before opening the web browser, you must run 'mysql_secure_installation' manually and follow the instructions."
echo "You can now complete the installation of your CRM from the web browser using this address: http://$server_ip"
echo "Remember all the usernames and passwords you previously defined. Enjoy and good luck!"
