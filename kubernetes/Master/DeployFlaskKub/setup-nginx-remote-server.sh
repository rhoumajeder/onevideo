#!/bin/bash

# sudo bash ./setup-nginx-remote-server.sh
sudo rsync -av /tmp/nginx/ /etc/nginx/
sudo rsync -av /tmp/letsencrypt/ /etc/letsencrypt/
sudo systemctl start nginx
sudo systemctl reload nginx