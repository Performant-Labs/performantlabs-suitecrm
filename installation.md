Steps to follow:

0. Edit `docker-compose.yml`
1. Build and up docker-compose project: `docker compose up --build -d`
2. if you care about security, run `docker exec -it suitecrm_script-mariadb-1 mysql_secure_installation` (change container name if neccesary)
 - just press enter (there is no root password)
 - Switch to unix_socket authentication [Y/n] Y
 - Change the root password? [Y/n] y
 - put your DB root password and take note of it!!!
 - Remove anonymous users? [Y/n] Y
 - Disallow root login remotely? [Y/n] Y
 - Remove test database and access to it? [Y/n] Y
 - Reload privilege tables now? [Y/n]
3. Now you can use the host and conclude the instalation of the CSuite CRM using the DB user and passwords you choose at the begining.

4. On the webpage config on these fields you place
      DATABASE CONFIGURATION:
        SuiteCRM Database User
              USER THAT YOU CHOOSE ON THE STEP #0
        SuiteCRM Database User Password
              PASSWORD THAT YOU CHOOSE ON THE STEP #0
        Host Name
              mariadb
        Database Name
              DATABASE NAME YOU CHOOSE ON THE STEP #0

Then the rest you decide which admin user and admin password


    GOOD LUCK!
