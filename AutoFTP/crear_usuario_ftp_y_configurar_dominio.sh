#!/bin/bash

# Solicitar credenciales y cuota
read -p 'Username: ' uservar
read -sp 'Password: ' passvar
read -p 'Quota: ' quota

# Variables comunes
USER_DIR="/var/www/tomascom/users/$uservar"
HTML_DIR="$USER_DIR/html"
DB_USER='root'
DB_PASSWD='alumne'
DB_NAME='usuarisftp'
TABLE='comptes'
DOMINIO="$uservar.tomas.com"
IP=$(hostname -I | awk '{print $1}')
NUM=$(echo $IP | awk -F. '{print $4}')

# Crear directorios personales y configurar permisos
mkdir -p "$HTML_DIR"
chown -R usuariftp:wwwftp "$USER_DIR"
chmod 775 "$USER_DIR" "$HTML_DIR"
echo "pagina de $uservar" > "$HTML_DIR/index.html"
chown -R www-data:wwwftp "$HTML_DIR"

# Insertar usuario en la base de datos FTP
mysql -u"$DB_USER" -p"$DB_PASSWD" "$DB_NAME" << EOF
INSERT INTO $TABLE (Login, Estatus, Contrasenya, Id_usuari, Id_grup, Directori, Ample_pujada, Ample_baixada, Comentari, Acces_ip, Quota_mida, Quota_fitxer)
VALUES ("$uservar", '1', SHA1("$passvar"), 2001, 2002, "$USER_DIR", NULL, NULL, "$passvar", '*', $quota, NULL);
EOF

# Configurar DNS
echo "$uservar IN A $IP" >> /etc/bind/directa
echo "$NUM IN PTR $DOMINIO" >> /etc/bind/inversa

# Crear configuración del VirtualHost de Apache
cat <<EOL >> /etc/apache2/sites-available/tomas.com.conf
<VirtualHost *:80>
    ServerName $DOMINIO
    ServerAdmin root@tomas.com
    DocumentRoot $HTML_DIR
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    Redirect permanent / https://$DOMINIO/
</VirtualHost>
<VirtualHost *:443>
    ServerName $DOMINIO
    DocumentRoot $HTML_DIR
    SSLEngine on
    SSLCertificateFile /etc/apache2/tls/apache.pem
    SSLProtocol all
    SSLCipherSuite HIGH:MEDIUM
</VirtualHost>
EOL

# Reiniciar servicios
systemctl restart bind9 apache2
