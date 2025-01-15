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
COPY job.rapakakarthik.shop.conf /etc/apache2/sites-available/job.rapakakarthik.shop.conf
RUN chown -R www-data:www-data /etc/apache2/sites-available/job.rapakakarthik.shop.conf
RUN a2ensite job.rapakakarthik.shop.conf && \
    a2dissite 000-default.conf
RUN a2enmod rewrite
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]