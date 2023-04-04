#!/bin/bash

#./rsync_script.sh remote-ip
#chmod +x rsync_script.sh


if [ "$#" -ne 1 ]; then
    echo "Usage: ./setup-nginx.sh remote-ip"
    exit 1
fi

remote_ip="$1"

sudo rsync -avz -e "ssh -i RjeKeys.pem" /etc/nginx/ ubuntu@"$remote_ip":/tmp/nginx
sudo rsync -avz -e "ssh -i RjeKeys.pem" /etc/letsencrypt/ ubuntu@"$remote_ip":/tmp/letsencrypt
