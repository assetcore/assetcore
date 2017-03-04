FROM phusion/passenger-full
MAINTAINER ASSETCORE community@assetcore.com

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN apt update
RUN apt-get -y install imagemagick gsfonts

ADD assetcore /home/app/assetcore
RUN chown -R app:app /home/app/assetcore

USER app
ENV HOME /home/app

WORKDIR /home/app/assetcore
RUN bundle install --without development test --path vendor/bundle

# RUN ./bin/init_config
ADD conf/rails-amqp.yml /home/app/assetcore/config/amqp.yml
ADD conf/rails-database.yml /home/app/assetcore/config/database.yml
ADD conf/rails-application.yml /home/app/assetcore/config/application.yml
ADD conf/nginx-assetcore-env.conf /etc/nginx/main.d/assetcore-env.conf

USER root

RUN rm /etc/nginx/sites-enabled/default
ADD conf/nginx-assetcore-with-ssl.conf /etc/nginx/sites-available/assetcore
RUN ln -s /etc/nginx/sites-available/assetcore /etc/nginx/sites-enabled/assetcore

RUN mkdir /etc/nginx/ssl_keys/
ADD conf/ssl_keys/server.crt /etc/nginx/ssl_keys/server.crt
ADD conf/ssl_keys/server.key /etc/nginx/ssl_keys/server.key

RUN chown -R app:app /home/app/assetcore/config

RUN rm -f /etc/service/nginx/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
