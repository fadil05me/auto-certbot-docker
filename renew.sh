#!/bin/bash

# Define variables

# The name of the container for this certbot
CONTAINER_NAME="certbot-auto"

# Change the IMAGE acording to your DNS Providers, look it up here: https://hub.docker.com/u/certbot.
# If you are using cloudflare just ignore it
IMAGE="certbot/dns-cloudflare"

# Change to your Email
EMAIL="fadil05me@gmail.com"

# Change to your Domain, use comma if you have more than 1 domain
DOMAINS="*.fadil05me.my.id,fadil05me.my.id"

# The location for your SSL cert
CONFIG_DIR="/etc/letsencrypt/live/"

# Location for your cloudflare.ini file
CLOUDFLARE_INI_PATH="/etc/letsencrypt/renewal/cloudflare.ini"

# Run the docker container to renew certificates
docker run --rm \
  --name $CONTAINER_NAME \
  -v "$CONFIG_DIR:/etc/letsencrypt:rw" \
  $IMAGE certonly --dns-cloudflare \
  --dns-cloudflare-credentials $CLOUDFLARE_INI_PATH \
  --email $EMAIL \
  --agree-tos \
  --domain $DOMAINS \
  --non-interactive \
  --config-dir /etc/letsencrypt \
  --work-dir /etc/letsencrypt \
  --logs-dir /etc/letsencrypt

# Reload Nginx to apply the new certificates

# If you are using nginx ontop of docker uncomment the command below, and change "nginx-reverse-proxy" to your docker container name

#docker exec nginx-reverse-proxy nginx -s reload

# If you are using nginx on your linux system directly, use this command:

sudo systemctl reload nginx
