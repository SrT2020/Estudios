#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo."
    exit 1
fi

# Update system packages and install prerequisites
echo "Updating system packages and installing prerequisites..."
apt-get update
apt-get -y install apt-transport-https wget gnupg

# Add the Icinga repository key
echo "Adding Icinga repository key..."
wget -O - https://packages.icinga.com/icinga.key | apt-key add -

# Determine the Debian version and add the Icinga repository
DIST=$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release)
echo "Adding Icinga repository for $DIST..."
echo "deb https://packages.icinga.com/debian icinga-${DIST} main" > /etc/apt/sources.list.d/${DIST}-icinga.list
echo "deb-src https://packages.icinga.com/debian icinga-${DIST} main" >> /etc/apt/sources.list.d/${DIST}-icinga.list

# Update package lists after adding Icinga repository
apt-get update

# Install Icinga Web 2 and Icinga CLI
echo "Installing Icinga Web 2 and Icinga CLI..."
apt-get install -y icingaweb2 icingacli

# Install and configure web server (Apache or Nginx)
# For Apache
echo "Installing Apache and PHP..."
apt-get install -y apache2 libapache2-mod-php php php-mysql php-gd php-xml php-mbstring php-ldap

# Enable Apache modules for Icinga Web 2
echo "Enabling Apache modules..."
a2enmod rewrite
a2enmod ssl

# Optional: If you need Nginx, uncomment the following section and comment out Apache installation
# echo "Installing Nginx and PHP..."
# apt-get install -y nginx php-fpm php-mysql php-gd php-xml php-mbstring php-ldap

# Optional: Nginx configuration for Icinga Web 2
# echo "Creating Nginx configuration for Icinga Web 2..."
# icingacli setup config webserver nginx --document-root /usr/share/icingaweb2/public
# ln -s /usr/share/icingaweb2/public /var/www/html/icingaweb2
# systemctl restart nginx

# Optional: If using a local database, configure MariaDB
echo "Configuring MariaDB database..."
# Install MariaDB (if not installed)
apt-get install -y mariadb-server mariadb-client

# Secure MariaDB installation
mysql_secure_installation

# Create the Icinga Web 2 database and user
echo "Creating database and user for Icinga Web 2..."
mysql -e "CREATE DATABASE icingaweb2;"
mysql -e "GRANT ALL ON icingaweb2.* TO icingaweb2@localhost IDENTIFIED BY 'CHANGEME';"

# Generate setup token for Icinga Web 2
echo "Generating Icinga Web 2 setup token..."
icingacli setup token create

# Display the setup token (for reference)
echo "Setup token for Icinga Web 2: $(icingacli setup token show)"

# Output success message
echo "Icinga Web 2 installation and setup completed!"
echo "Visit http://your-server-ip/icingaweb2/setup in your browser to complete the setup."

# Restart web server to apply changes
echo "Restarting Apache..."
systemctl restart apache2
