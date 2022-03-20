#!/usr/bin/env bash

SITE=$1

if [[ -z $SITE ]]; then
    echo "Provide a domain name such as example.com as a parameter."
    exit 1
fi

if [[ ! -d /etc/nginx/conf.d ]]; then
    echo "/etc/nginx/conf.d does not exist."
    exit
fi

sudo wget -q \
    https://gist.githubusercontent.com/tricarte/8c4595ef50649a91e2ca6462c27f2d42/raw/7f58be951c81c2e39231b0118f7e82c8e6eeb804/example.com.conf \
    -O "/etc/nginx/conf.d/.$SITE.conf"

ROOT="/home/$(whoami)/sites/$SITE"
sudo replace -s '/var/www/example.com/public' "$ROOT" -- "/etc/nginx/conf.d/.$SITE.conf"
sudo replace -s 'example.com' "$SITE" -- "/etc/nginx/conf.d/.$SITE.conf"

echo "Virtual host \"$SITE\" has been created in /etc/nginx/conf.d."
echo "Remove the preceding dot to enable it."
