#!/bin/bash
set -e
set -x

if [[ ! -x /var/www/html/crm/public ]]; then
  echo "Downloading CRM..."
  cd /var/www/html/crm
  wget https://suitecrm.com/download/148/suite87/564667/suitecrm-8-7-1.zip
  unzip suitecrm-8-7-1.zip
  chown -R www-data:www-data /var/www/html/crm
  chmod -R 755 /var/www/html/crm
fi

#systemctl restart apache2
service apache2 start

# Adjust permissions
echo "Adjusting permissions..."
find /var/www/html/crm -type d -not -perm 2755 -exec chmod 2755 {} \;
find /var/www/html/crm -type f -not -perm 0644 -exec chmod 0644 {} \;
find /var/www/html/crm ! -user www-data -exec chown www-data:www-data {} \;
chmod +x /var/www/html/crm/bin/console

echo "The script has finished. Before opening the web browser, you must run 'mysql_secure_installation' manually and follow the instructions."
echo "You can now complete the installation of your CRM from the web browser using this address: http://$server_ip"
echo "Remember all the usernames and passwords you previously defined. Enjoy and good luck!"

# A command to keep it running #see https://stackoverflow.com/questions/25135897/how-to-automatically-start-a-service-when-running-a-docker-container
tail -F /var/log/apache2/error.log /var/log/apache2/access.log
