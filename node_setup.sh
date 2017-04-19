#!/bin/bash

#############################################################################################################################
#                                                                                                                           #
#  cf. https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-16-04  #
#                                                                                                                           #
#############################################################################################################################

cd ~
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install build-essential git nginx nodejs -y
sudo npm install -g pm2

pm2 startup systemd

sudo cat nginx-server-config > /etc/nginx/sites-available/default
sudo nginx -t
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full'

# FOR HTTPS:
#sudo apt-get install letsencrypt -y
#sudo systemctl stop nginx && \
#sudo letsencrypt certonly --standalone && \
#read -p "domain name? " your_domain_name
#sudo echo "# HTTP - redirect all requests to HTTPS:
#server {
        #listen 80;
        #listen [::]:80 default_server ipv6only=on;
        #return 301 https://$host$request_uri;
#}
#
## HTTPS - proxy requests on to local Node.js app:
#server {
        #listen 443;
        #server_name $your_domain_name;
#
        #ssl on;
        ## Use certificate and key provided by Let's Encrypt:
        #ssl_certificate /etc/letsencrypt/live/${your_domain_name}/fullchain.pem;
        #ssl_certificate_key /etc/letsencrypt/live/${your_domain_name}/privkey.pem;
        #ssl_session_timeout 5m;
        #ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        #ssl_prefer_server_ciphers on;
        #ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
#
        ## Pass requests for / to localhost:8080:
        #location / {
                #proxy_set_header X-Real-IP $remote_addr;
                #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                #proxy_set_header X-NginX-Proxy true;
                #proxy_pass http://localhost:8080/;
                #proxy_ssl_session_reuse off;
                #proxy_set_header Host $http_host;
                #proxy_cache_bypass $http_upgrade;
                #proxy_redirect off;
        #}
#}" > /etc/nginx/sites-enabled/default
#sudo nginx -t
#sudo systemctl start nginx

pm2 start app/server.js
