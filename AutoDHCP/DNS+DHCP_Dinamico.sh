#!/bin/bash

# 1. Copiar los archivos de definición de la DNS a /var/lib/bind
echo "Copiando archivos de definición de la DNS a /var/lib/bind..."
cp /etc/bind/{directa.db,inversa.db} /var/lib/bind/ || { echo "Error al copiar archivos"; exit 1; }

# 2. Cambiar el usuario y el grupo propietario de los archivos copiados
echo "Cambiando propietario y grupo de los archivos en /var/lib/bind..."
chown bind:bind /var/lib/bind/* || { echo "Error al cambiar propietario"; exit 1; }

# 3. Crear una clave privada para la comunicación segura entre DHCP y DNS
echo "Creando clave privada para la comunicación segura entre DHCP y DNS..."
tsig-keygen -a hmac-md5 > /etc/bind/clau || { echo "Error al generar clave"; exit 1; }

# 4. Mostrar la clave generada
echo "Mostrando la clave generada:"
cat /etc/bind/clau

# 5. Editar el archivo named.conf.local y añadir las entradas necesarias
echo "Editando /etc/bind/named.conf.local..."
cat <<EOF >> /etc/bind/named.conf.local

# La clau secreta que farem servir per les actualitzacions DHCP.
key "tsig-key" {
    algorithm hmac-md5;
    secret "asdasddsaasd/dsa==";
};

# Definició de la meva zona directa
zone "empresa.com" {
    type master;
    file "/var/lib/bind/home.lan.db";
    allow-update { key "tsig-key"; };
};

# Definició de la meva zona inversa
zone "1.168.192.in-addr.arpa" {
    type master;
    file "/var/lib/bind/rev.0.162.198.in-addr.arpa";
    allow-update { key "tsig-key"; };
};
EOF

# 6. Editar el archivo dhcpd.conf y añadir las entradas necesarias
echo "Editando /etc/dhcp/dhcpd.conf..."
cat <<EOF >> /etc/dhcp/dhcpd.conf

# Canvieu l'estil d'actualització de les DNSs dinàmiques al valor interim:
ddns-update-style standard;
ignore client-updates;

# Sobreescribim el FQHN configurat del clcient
ddns-domainname "empresa.com.";
ddns-rev-domainname "in-addr.arpa.";

# Opcions comunes de configuracio
option domain-name "empresa.com";
option domain-name-servers 192.168.0.X;
default-lease-time 600;
max-lease-time 7200;

# Si el servidor DHCP és el servidor DHCP oficial per a la xarxa local
# la directiva authoritative s'ha de descomentar.
authoritative;

# Feu servir aquesta directiva per a enviar logs al fitxer que vulgueu
log-facility local7;

key "tsig-key" {
    algorithm hmac-md5;
    secret "asdasddsaasd/dsa==";
};

zone empresa.com. {
    primary 127.0.0.1;
    key "tsig-key";
};

zone 1.168.192.in-addr.arpa. {
    primary 127.0.0.1;
    key "tsig-key";
};

# Declaració del rang.
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.0.150;
    option routers 192.168.1.1;
}
EOF

# 7. Cambiar el usuario propietario del archivo dhcpd.conf
echo "Cambiando propietario del archivo /etc/dhcp/dhcpd.conf..."
chown dhcpd:dhcpd /etc/dhcp/dhcpd.conf || { echo "Error al cambiar propietario"; exit 1; }

# Reiniciar los servicios bind9 e isc-dhcp-server
echo "Reiniciando servicios..."
service bind9 restart || { echo "Error al reiniciar bind9"; exit 1; }
service isc-dhcp-server restart || { echo "Error al reiniciar isc-dhcp-server"; exit 1; }

echo "Script completado exitosamente."
