#!/usr/bin/env bash

# Start sshd for debugging thru Azure Web App
sed -i "s/SSH_PORT/$SSH_PORT/g" /etc/ssh/sshd_config
service ssh start

# start nginx
nginx -g 'daemon off;'
