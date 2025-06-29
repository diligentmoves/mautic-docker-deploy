FROM mautic/mautic:5-apache

# Set Apache to serve from /var/www/html/docroot
RUN sed -i 's|DocumentRoot .*|DocumentRoot /var/www/html/docroot|' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's|<Directory /var/www/html>|<Directory /var/www/html/docroot>|' /etc/apache2/apache2.conf
	
# Optional: install extra PHP extensions or Composer
RUN apt-get update && apt-get install -y \
    unzip curl git nano \
    && rm -rf /var/lib/apt/lists/*
