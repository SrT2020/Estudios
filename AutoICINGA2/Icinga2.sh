#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo."
    exit 1
fi

# Update system packages and install necessary tools
echo "Updating system packages and installing prerequisites..."
apt update
apt -y install apt-transport-https wget gnupg

# Add the Icinga repository key
echo "Adding Icinga repository key..."
wget -O - https://packages.icinga.com/icinga.key | gpg --dearmor -o /usr/share/keyrings/icinga-archive-keyring.gpg

# Determine the Debian version and add the Icinga repository
DIST=$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release)
echo "Adding Icinga repository for $DIST..."
echo "deb [signed-by=/usr/share/keyrings/icinga-archive-keyring.gpg] https://packages.icinga.com/debian icinga-${DIST} main" > /etc/apt/sources.list.d/${DIST}-icinga.list
echo "deb-src [signed-by=/usr/share/keyrings/icinga-archive-keyring.gpg] https://packages.icinga.com/debian icinga-${DIST} main" >> /etc/apt/sources.list.d/${DIST}-icinga.list

# Update package lists after adding Icinga repository
apt update

# Add Debian Backports Repository if required (for Debian Stretch)
if [[ "$DIST" == "stretch" ]]; then
    echo "Adding Debian Backports repository for $DIST..."
    echo "deb https://deb.debian.org/debian ${DIST}-backports main" > /etc/apt/sources.list.d/${DIST}-backports.list
    apt update
fi

# Install Icinga 2
echo "Installing Icinga 2..."
apt install -y icinga2

# Validate Icinga 2 configuration
echo "Validating Icinga 2 configuration..."
icinga2 daemon -C

# Install monitoring plugins
echo "Installing monitoring plugins..."
apt install -y monitoring-plugins

# Set up the Icinga 2 API
echo "Setting up Icinga 2 API..."
icinga2 api setup

# Restart Icinga 2 to apply API settings
echo "Restarting Icinga 2..."
systemctl restart icinga2

# Install and set up Redis for Icinga DB
echo "Installing Icinga DB Redis package..."
apt install -y icingadb-redis

# Enable and start Redis service
echo "Enabling and starting Icinga DB Redis service..."
systemctl enable --now icingadb-redis

# Optional: Enable remote Redis connections (Uncomment and modify to allow remote access)
# echo "Configuring Redis for remote connections..."
# sed -i 's/^protected-mode yes/protected-mode no/' /etc/icingadb-redis/icingadb-redis.conf
# sed -i 's/^bind 127.0.0.1 ::1/bind 0.0.0.0 ::/' /etc/icingadb-redis/icingadb-redis.conf
# systemctl restart icingadb-redis

# Enable Icinga DB feature in Icinga 2
echo "Enabling Icinga DB feature in Icinga 2..."
icinga2 feature enable icingadb

# Restart Icinga 2 to apply changes
echo "Restarting Icinga 2..."
systemctl restart icinga2

# Install Icinga DB Daemon
echo "Installing Icinga DB Daemon..."
apt install -y icingadb

# Output success message
echo "Icinga 2 installation and setup complete!"
