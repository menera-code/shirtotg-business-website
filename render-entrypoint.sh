#!/bin/bash
set -e

PORT="${PORT:-80}"

sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf

if [ -f /etc/apache2/sites-available/default-ssl.conf ]; then
  sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/default-ssl.conf
fi

exec docker-entrypoint.sh "$@"
