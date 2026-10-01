FROM wordpress:php8.2-apache

# Copy the Aiven CA certificate into the container
COPY ca.pem /var/www/html/ca.pem

COPY render-entrypoint.sh /usr/local/bin/render-entrypoint.sh
RUN chmod +x /usr/local/bin/render-entrypoint.sh

ENTRYPOINT ["render-entrypoint.sh"]
CMD ["apache2-foreground"]
