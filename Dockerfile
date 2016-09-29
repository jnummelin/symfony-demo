FROM php:fpm

RUN docker-php-ext-enable opcache && \
  docker-php-ext-install pdo_mysql  && \
  apt-get update && \
  apt-get install -y git unzip netcat && \
  apt-get clean && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/symfony

# Add things picky way, so that to increase cache usage
#ADD app /var/www/symfony/
#ADD composer.json /var/www/symfony/
#ADD src /var/www/symfony/
#ADD web /var/www/symfony/
#ADD app.json /var/www/symfony/

ADD . /var/www/symfony/

RUN php /usr/local/bin/composer install


RUN mkdir -p /var/www/symfony/var/cache/prod && chmod -R a+rw /var/www/symfony/var/cache/prod \
  && mkdir -p /var/www/symfony/var/logs && chmod -R a+rw /var/www/symfony/var/logs \
  && mkdir -p /var/www/symfony/var/sessions/prod && chmod -R a+rw /var/www/symfony/var/sessions/prod

ADD entrypoint.sh .

CMD ./entrypoint.sh
