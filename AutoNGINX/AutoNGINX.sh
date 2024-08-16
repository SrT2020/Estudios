#!/bin/bash

sudo apt-get update
sudo apt-get install -y nginx

# Generate Diffie-Hellman parameter for better security
sudo openssl dhparam -out /etc/nginx/dhparam.pem 2048


cat <<EOL | sudo tee /etc/nginx/nginx.conf
user                 www-data;
pid                  /run/nginx.pid;
worker_processes     auto;
worker_rlimit_nofile 65535;

include              /etc/nginx/modules-enabled/*.conf;

events {
    multi_accept       on;
    worker_connections 65535;
}

http {
    charset                utf-8;
    sendfile               on;
    tcp_nopush             on;
    tcp_nodelay            on;
    server_tokens          off;
    log_not_found          off;
    types_hash_max_size    2048;
    types_hash_bucket_size 64;
    client_max_body_size   16M;

    include                mime.types;
    default_type           application/octet-stream;

    access_log             off;
    error_log              /dev/null;

    limit_req_log_level    warn;
    limit_req_zone         \$binary_remote_addr zone=login:10m rate=10r/m;

    ssl_session_timeout    1d;
    ssl_session_cache      shared:SSL:10m;
    ssl_session_tickets    off;

    ssl_dhparam            /etc/nginx/dhparam.pem;

    ssl_protocols          TLSv1.2 TLSv1.3;
    ssl_ciphers            ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

    ssl_stapling           on;
    ssl_stapling_verify    on;
    resolver               1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220 valid=60s;
    resolver_timeout       2s;

    include                /etc/nginx/conf.d/*.conf;
    include                /etc/nginx/sites-enabled/*;
}
EOL


cat <<EOL | sudo tee /etc/nginx/sites-available/example.com.conf
server {
    listen              443 ssl http2;
    listen              [::]:443 ssl http2;
    server_name         www.example.com;
    root                /var/www/example.com/public;

    ssl_certificate     /etc/nginx/ssl/example.com.crt;
    ssl_certificate_key /etc/nginx/ssl/example.com.key;

    include             nginxconfig.io/security.conf;

    access_log          /var/log/nginx/access.log combined buffer=512k flush=1m;
    error_log           /var/log/nginx/error.log warn;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location ~ ^/api/ {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    include nginxconfig.io/general.conf;
}

server {
    listen              443 ssl http2;
    listen              [::]:443 ssl http2;
    server_name         .example.com;

    ssl_certificate     /etc/nginx/ssl/example.com.crt;
    ssl_certificate_key /etc/nginx/ssl/example.com.key;
    return              301 https://www.example.com\$request_uri;
}

server {
    listen      80;
    listen      [::]:80;
    server_name .example.com;
    return      301 https://www.example.com\$request_uri;
}
EOL

mkdir /etc/nginx/nginxconfig.io
cat <<EOL | sudo tee /etc/nginx/nginxconfig.io/security.conf
# Enhanced security headers
add_header X-XSS-Protection          "1; mode=block" always;
add_header X-Content-Type-Options    "nosniff" always;
add_header Referrer-Policy           "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy   "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self';" always;
add_header Permissions-Policy        "geolocation=(), microphone=(), camera=(), interest-cohort=()" always;
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
add_header X-Frame-Options           "DENY" always;
add_header Expect-CT                 "max-age=86400, enforce" always;
add_header X-Download-Options        "noopen" always;
add_header X-Permitted-Cross-Domain-Policies "none" always;


location ~ /\.(?!well-known) {
    deny all;
    access_log off;
    log_not_found off;
}

location ~ (^|/)\. {
    return 404;
}


location ~* \.(?:txt|md|xml|sh|env|ini|log|conf)$ {
    deny all;
    access_log off;
    log_not_found off;
}

# security.txt redirection
location /security.txt {
    return 301 /.well-known/security.txt;
}

location = /.well-known/security.txt {
    alias /var/www/security.txt;  
}
EOL

mkdir /etc/nginx/nginxconfig.io
cat <<EOL | sudo tee /etc/nginx/nginxconfig.io/general.conf
# favicon.ico
location = /favicon.ico {
    log_not_found off;
}

# robots.txt
location = /robots.txt {
    log_not_found off;
}

# assets, media
location ~* \.(?:css(\.map)?|js(\.map)?|jpe?g|png|gif|ico|cur|heic|webp|tiff?|mp3|m4a|aac|ogg|midi?|wav|mp4|mov|webm|mpe?g|avi|ogv|flv|wmv)$ {
    expires 7d;
}

# svg, fonts
location ~* \.(?:svgz?|ttf|ttc|otf|eot|woff2?)$ {
    add_header Access-Control-Allow-Origin "*";
    expires    7d;
}

# gzip
gzip            on;
gzip_vary       on;
gzip_proxied    any;
gzip_comp_level 6;
gzip_types      text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;
EOL

sudo ln -s /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
echo "Nginx has been installed and configured for www.example.com"
