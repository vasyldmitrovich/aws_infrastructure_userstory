#!/bin/bash

db_user_root=root
db_user=myuser
db_password=mypassword

# Install DB
sudo apt update
sudo apt install mariadb-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb.service
sudo ufw allow 3306

# Create user and add permission
sudo mysql -uroot -px -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${db_user_root}'); \
CREATE USER '${db_user}'@'localhost' IDENTIFIED BY '${db_password}'; \
CREATE USER '${db_user}'@'%' IDENTIFIED BY '${db_password}'; \
GRANT ALL ON *.* TO '${db_user}'@'localhost' IDENTIFIED BY '${db_password}' WITH GRANT OPTION; \
GRANT ALL ON *.* TO '${db_user}'@'%' IDENTIFIED BY '${db_password}' WITH GRANT OPTION; \
FLUSH PRIVILEGES;"

sudo mysql -u${db_user} -p${db_password} < $1/userstory_data.sql

sudo sed -i 's/^bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo service mariadb restart

# Install Open JDK and Maven
sudo apt update &&
sudo apt install openjdk-17-jre-headless -y &&
sudo apt update &&
sudo apt install maven -y &&
sudo ufw allow 8080
sudo ufw reload

# Add variable to system
cat $1/var_for_app >> $1/.profile
source $1/.profile

# Clone code and run app
mkdir "$1/userstoryproj_back"
git clone https://github.com/vasyldmitrovich/userstoryproj_back.git $1/userstoryproj_back
cd $1/userstoryproj_back
mvn clean package

# First running application
java -jar ./target/*.jar &
echo "$!" > $1/java_backend_PID.txt

echo "start install apache" >> $1/logfile.txt
sudo apt update &&
sudo apt install apache2 -y &&
sudo ufw allow 'Apache' &&
sudo apt-get update &&
sudo apt-get install -y ca-certificates curl gnupg &&
sudo mkdir -p /etc/apt/keyrings &&
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg &&
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list &&
sudo apt update &&
sudo apt install nodejs -qy &&
echo "finish install apache" >> $1/logfile.txt