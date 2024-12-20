# Use Ubuntu as the base image
FROM ubuntu:latest

# Set non-interactive mode to avoid some prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache2 and necessary utilities
RUN apt-get update && \
    apt-get install -y apache2 sudo && \
    apt-get clean

# # Modify /etc/hosts to include the domain name (run as root)
# USER root
# RUN echo "127.0.0.1   dev-01.rapakakarthik.shop" > /tmp/hosts && \
#     cat /tmp/hosts >> /etc/hosts

# Set the working directory
WORKDIR /var/www/

# Remove default html directory and create a new one for the specified domain
RUN rm -rf /var/www/html && \
    mkdir -p /var/www/dev-01.rapakakarthik.shop && \
    chown -R www-data:www-data /var/www/dev-01.rapakakarthik.shop

# Copy files from the build context into the new directory
COPY . /var/www/dev-01.rapakakarthik.shop

# Add the site configuration to Apache's sites-available directory
RUN echo '<VirtualHost *:80>\n\
    ServerName dev-01.rapakakarthik.shop\n\
    DocumentRoot /var/www/dev-01.rapakakarthik.shop\n\
    <Directory /var/www/dev-01.rapakakarthik.shop>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n\
</VirtualHost>' > /etc/apache2/sites-available/dev-01.rapakakarthik.shop.conf

# Enable the new site and disable the default site
RUN a2ensite dev-01.rapakakarthik.shop.conf && \
    a2dissite 000-default.conf

# Enable mod_rewrite for Apache
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
