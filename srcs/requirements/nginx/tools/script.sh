#!/bin/bash

echo "127.0.0.1	hbenazza.42.fr" >> /etc/hosts
cat /etc/hosts
nginx -t

exec nginx -g "daemon off;"