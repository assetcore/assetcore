#!/bin/bash
#Install Ruby through rbenv:
rbenv install 2.2.1
rbenv global 2.2.1

#install bundler
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
rbenv rehash

# Install Mysql
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password gatomorto'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password gatomorto'
sudo apt-get install -y mysql-server  mysql-client  libmysqlclient-dev

# Install Redis
sudo apt-add-repository -y ppa:chris-lea/redis-server
sudo apt-get update
sudo apt-get install -y redis-server

# Install RabbitMQ
sudo apt-add-repository 'deb http://www.rabbitmq.com/debian/ testing main'
curl http://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y rabbitmq-server

sudo rabbitmq-plugins enable rabbitmq_management
sudo service rabbitmq-server restart
wget http://localhost:15672/cli/rabbitmqadmin
chmod +x rabbitmqadmin
sudo mv rabbitmqadmin /usr/local/sbin

# Install PhantomJS
sudo apt-get update
sudo apt-get install -y build-essential chrpath git-core libssl-dev libfontconfig1-dev
cd /usr/local/share
PHANTOMJS_VERISON=1.9.8
sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERISON-linux-x86_64.tar.bz2
sudo tar xjf phantomjs-$PHANTOMJS_VERISON-linux-x86_64.tar.bz2
sudo ln -s /usr/local/share/phantomjs-$PHANTOMJS_VERISON-linux-x86_64/bin/phantomjs /usr/local/share/phantomjs
sudo ln -s /usr/local/share/phantomjs-$PHANTOMJS_VERISON-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
sudo ln -s /usr/local/share/phantomjs-$PHANTOMJS_VERISON-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

#Install JavaScript Runtime
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get -y install nodejs

# Instlal ImageMagick
sudo apt-get install -y imagemagick
 
# Install Assetcore
cd 
git clone https://github.com/assetcore/assetcore.git
cd assetcore
bundle install

#Prepare configure files
bin/init_config
sed -i -e "s/gem 'mysql2'/gem 'mysql2', '~> 0.3.18'/g" Gemfile
bundle update mysql2
bundle install

#Deploy Database
bundle exec rake db:setup

# Starting all daemons
bundle exec rake daemons:start

# Starting Server
bundle exec rails server

