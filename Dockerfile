# Use Ubuntu as the base image
FROM ubuntu:latest

# Set non-interactive mode to avoid some prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache2 and necessary utilities
RUN apt-get update && \
    apt-get install -y apache2 sudo && \
    apt-get clean

# Set the working directory
WORKDIR /var/www/

# Remove the default html directory and create a new one for the specified domain
RUN rm -rf /var/www/html && \
    mkdir -p /var/www/dev-01.rapakakarthik.shop && \
    chown -R www-data:www-data /var/www/dev-01.rapakakarthik.shop

# Copy files from the build context (including index.html) into the new directory
COPY . /var/www/dev-01.rapakakarthik.shop/

# Add the site configuration to Apache's sites-available directory
RUN echo '<VirtualHost *:80>\n\
    ServerName dev-01.rapakakarthik.shop\n\
    DocumentRoot /var/www/dev-01.rapakakarthik.shop\n\
    <Directory /var/www/dev-01.rapakakarthik.shop>\n\
        AllowOverride All\n\
        Require all granted\n\
        DirectoryIndex index.html\n\
        Options -Indexes\n\  # Disable directory listing\n\
    </Directory>\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n\
</VirtualHost>' > /etc/apache2/sites-available/dev-01.rapakakarthik.shop.conf

# Enable the new site and disable the default site
RUN a2ensite dev-01.rapakakarthik.shop.conf && \
    a2dissite 000-default.conf

# Enable mod_rewrite for Apache
RUN a2enmod rewrite

# # Add ServerName directive to apache2.conf to suppress warnings
# RUN echo "ServerName dev-01.rapakakarthik.shop" >> /etc/apache2/apache2.conf  {{ edit_1 }}

# # Add ServerName directive to apache2.conf to suppress warnings
# RUN echo "ServerName dev-01.rapakakarthik.shop:80" >> /etc/apache2/apache2.conf  {{ edit_1 }}

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]