################################################################################
# Base image
################################################################################

FROM phusion/baseimage

ARG DEBIAN_FRONTEND=noninteractive

RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

################################################################################
# Build instructions
################################################################################

# Add PPA
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update

# Install software
RUN apt-get install -y libcurl4-openssl-dev pkg-config
RUN apt-get install -y git
RUN apt-get install -y p7zip-full unzip
RUN apt-get install -y make

# Install packages
RUN apt-get install --no-install-recommends --allow-unauthenticated -y \
  nginx \
  supervisor \
  curl \
  wget \
  php5.6-dev \
  php5.6-curl \
  php5.6-fpm \
  php5.6-gd \
  php5.6-memcached \
  php5.6-mysql \
  php5.6-mcrypt \
  php5.6-sqlite \
  php5.6-mbstring \
  php5.6-dom \
  php5.6-cli \
  php5.6-json \
  php5.6-common \
  php5.6-opcache \
  php5.6-readline \
  php-pear \
  php5.6-xml



RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/run/php && touch /var/run/php/php5.6-fpm.sock

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install redis extension
RUN cd ~; wget https://github.com/phpredis/phpredis/archive/master.zip -O phpredis.zip; unzip -o phpredis.zip; mv phpredis-* phpredis; cd phpredis; /usr/bin/phpize; ./configure; make; make install
RUN touch /etc/php/5.6/mods-available/redis.ini; echo extension=redis.so > /etc/php/5.6/mods-available/redis.ini; phpenmod redis

# Install cphalcon extension
RUN cd ~; git clone https://github.com/phalcon/cphalcon; cd ~/cphalcon/build; ./install
RUN echo "extension=phalcon.so" >> /etc/php/5.6/mods-available/phalcon.ini; phpenmod phalcon

# Install Mongo DB extension
RUN cd ~; git clone https://github.com/mongodb/mongo-php-driver.git; cd mongo-php-driver; git submodule sync && git submodule update --init; phpize; ./configure; make all -j 5; make install
RUN sh -c "echo 'extension=mongodb.so' > /etc/php/5.6/mods-available/mongodb.ini"
RUN echo "extension=mongodb.so" >> /etc/php/5.6/fpm/php.ini; phpenmod mongodb

# Add configuration files
COPY conf/nginx.conf /etc/nginx/
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini
COPY conf/www.conf /etc/php/5.6/fpm/pool.d/

# Set Timezone
ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

################################################################################
# Ports
################################################################################

EXPOSE 80 443 9000

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/bin/supervisord"]
