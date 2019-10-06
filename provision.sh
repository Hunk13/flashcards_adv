#!/bin/bash

sudo apt-get upgrade

# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential

echo installing Bundler
gem install bundler -N >/dev/null 2>&1

install Git git
install SQLite sqlite3 libsqlite3-dev
install memcached memcached

install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser flcard
sudo -u postgres createdb -O flcard flcard_adv_dev
sudo -u postgres createdb -O flcard flcard_adv_test
sudo -u postgres psql <<SQL
ALTER USER flcard WITH PASSWORD 'flcard';
SQL

install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'ExecJS runtime' nodejs

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'all set, rock on!'