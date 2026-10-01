FROM wordpress:php8.2-apache

# Install MariaDB (MySQL) server locally
RUN apt-get update && apt-get install -y mariadb-server

COPY render-entrypoint.sh /usr/local/bin/render-entrypoint.sh
RUN chmod +x /usr/local/bin/render-entrypoint.sh

ENTRYPOINT ["render-entrypoint.sh"]
CMD ["apache2-foreground"]
