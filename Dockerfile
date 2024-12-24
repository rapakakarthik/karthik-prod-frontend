FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y apache2 sudo && \
    apt-get clean
WORKDIR /var/www/
RUN rm -rf /var/www/html && \
    mkdir -p /var/www/job.rapakakarthik.shop && \
    chown -R www-data:www-data /var/www/job.rapakakarthik.shop
COPY . /var/www/job.rapakakarthik.shop/


# Add the site configuration to Apache's sites-available directory
RUN echo '<VirtualHost *:80>\n\
    ServerName job.rapakakarthik.shop\n\
    DocumentRoot /var/www/job.rapakakarthik.shop/index.html\n\
    <Directory /var/www/job.rapakakarthik.shop>\n\
        AllowOverride All\n\
        Require all granted\n\
        DirectoryIndex index.html\n\
        Options -Indexes\n\
    </Directory>\n\
    ErrorLog ${APACHE_LOG_DIR}/job.rapakakarthik.shop-error.log\n\
    CustomLog ${APACHE_LOG_DIR}/job.rapakakarthik.shop-access.log combined\n\
</VirtualHost>' > /etc/apache2/sites-available/job.rapakakarthik.shop.conf

# RUN echo '<VirtualHost *:80>\n\
#     ServerAdmin admin@rapakakarthik.shop\n\
#     ServerName job.rapakakarthik.shop\n\
#     DocumentRoot /var/www/job.rapakakarthik.shop\n\
# \n\
#     <Directory /var/www/job.rapakakarthik.shop>\n\
#         AllowOverride All\n\
#         Require all granted\n\
#         DirectoryIndex index.html\n\
#         Options -Indexes\n\
#     </Directory>\n\
# \n\
#     ErrorLog ${APACHE_LOG_DIR}/job.rapakakarthik.shop-error.log\n\
#     CustomLog ${APACHE_LOG_DIR}/job.rapakakarthik.shop-access.log combined\n\
# </VirtualHost>' > /etc/apache2/sites-available/job.rapakakarthik.shop.conf


RUN a2ensite job.rapakakarthik.shop.conf && \
    a2dissite 000-default.conf
RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]