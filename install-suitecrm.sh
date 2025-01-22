#!/bin/bash
set -e
set -x

# Update and install essential packages
echo "Updating and installing essential packages..."
apt update && apt upgrade -y
apt install unzip wget -y

# Update and install PHP packages
echo "Updating and installing PHP packages..."
apt install -y software-properties-common
add-apt-repository ppa:ondrej/php -y && apt update && apt upgrade -y
apt update && apt install -y php8.2 libapache2-mod-php8.2 php8.2-cli php8.2-curl php8.2-common php8.2-intl php8.2-gd php8.2-mbstring php8.2-mysqli php8.2-pdo php8.2-mysql php8.2-xml php8.2-zip php8.2-imap php8.2-ldap php8.2-curl php8.2-soap php8.2-bcmath

# Configure Apache
echo "Configuring Apache Server..."
a2enmod rewrite
#systemctl restart apache2

# Disable directory listing globally
echo "Disabling directory listing globally..."
cat << EOF | tee /etc/apache2/conf-available/disable-directory-listing.conf
<Directory /var/www/>
    Options -Indexes
</Directory>
EOF
a2enconf disable-directory-listing

# Environment isn't accessible during build, so hardcode server name
server_ip=suitecrm.performantlabs.com
echo "IP retrieved: $server_ip"

# Configure VirtualHost
echo "Configuring VirtualHost..."
cat << EOF | tee /etc/apache2/sites-available/crm.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/crm/public
    ServerName $server_ip
    <Directory /var/www/html/crm/public>
        Options -Indexes +FollowSymLinks +MultiViews
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
a2ensite crm.conf
#systemctl reload apache2

# Configure php.ini
echo "Setting php.ini..."
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/8.2/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 50M/' /etc/php/8.2/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 50M/' /etc/php/8.2/apache2/php.ini
sed -i 's/max_execution_time = .*/max_execution_time = 300/' /etc/php/8.2/apache2/php.ini

