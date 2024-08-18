#!/bin/bash

# Guia de instalacion de GLPI en Linux - Ubuntu 18.04.1 LTS

# 1. Actualizar los repositorios y paquetes del sistema
sudo apt-get update -y
sudo apt-get dist-upgrade -y

# 2. Instalar entorno LAMP y phpmyadmin
sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql phpmyadmin nano

# 3. Instalar GLPI

# 3.1 Descargar la última versión y moverla al servidor web
wget https://github.com/glpi-project/glpi/releases/download/9.5.5/glpi-9.5.5.tgz
tar -xvzf glpi-9.5.5.tgz
sudo mv glpi /var/www/html/
sudo chown www-data:www-data /var/www/html/glpi/* -R

# 3.2 Instalar y configurar las extensiones PHP
sudo apt-get install -y php7.4-ldap php7.4-imap php7.4-curl php7.4-mbstring php7.4-gd php7.4-xmlrpc php7.4-xsl php7.4-apcu php7.4-intl php-cas

# Configurar php.ini para activar las extensiones necesarias
sudo sed -i "s/;extension=curl/extension=curl/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/;extension=gd2/extension=gd2/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/;extension=imap/extension=imap/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/;extension=intl/extension=intl/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/;extension=ldap/extension=ldap/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/;extension=mbstring/extension=mbstring/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/;extension=xmlrpc/extension=xmlrpc/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/;extension=xsl/extension=xsl/" /etc/php/7.4/apache2/php.ini

# 3.3 Configurar el servidor web
sudo bash -c 'echo "<Directory /var/www/html/glpi>
    AllowOverride All
</Directory>" >> /etc/apache2/apache2.conf'

# 3.4 Reiniciar el servidor web
sudo systemctl restart apache2

# 3.5 Configuración de la base de datos
sudo mysql -e "CREATE DATABASE glpi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 3.6 Crear usuario de base de datos para GLPI
sudo mysql -e "CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';"
sudo mysql -e "GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';"
sudo mysql -e "GRANT SELECT ON mysql.time_zone_name TO 'glpi'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# 3.7 Abrir GLPI en el navegador
xdg-open http://localhost/glpi &

# Fin del script
