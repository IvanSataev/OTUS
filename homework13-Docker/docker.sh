#!/bin/bash
sudo -i
### Downloads and installation of necessary applications
yum install -y vim docker net-tools
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/sbin/docker-compose
sudo chmod +x /usr/local/sbin/docker-compose
systemctl start docker
mkdir hosts logs www
setenforce 0
### formation of the start page with phpinfo
cat >> www/index.php << EOF
<?php
echo phpinfo();
EOF

### create nginx configure file
cat >> nginx.conf << EOF
server {
    index index.php;
    server_name _;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/;

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}
EOF
### Dockerfile build php conteiner
cat >> Dockerfile << EOF
FROM php:7.4-fpm
RUN set -ex && apt update -y  && apt -y upgrade
WORKDIR /var/www
EOF

### docker-compose file for up containers
cat >> docker-compose.yml << EOF
version: '3.7'
services:
  nginx:
   image: nginx:latest
   ports:
      -  "8080:80"
   volumes:
        - ./nginx.conf:/etc/nginx/conf.d/default.conf
        - ./www:/var/www
        - ./logs/nginx:/var/log/nginx
  php:
    build: .
    volumes:
        - ./www:/var/www
EOF

docker-compose up -d
echo "GET START PAGE"
curl 127.0.0.1:8080/index.php

