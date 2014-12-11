#! /bin/sh

set -x

mkdir -p /var/git/gitlab/tmp/sockets
mkdir -p /var/git/gitlab/tmp/pids
mkdir -p /var/git/gitlab/log
mkdir -p /var/git/repositories
mkdir -p /var/redis
mkdir -p /var/log

mkdir -p /var/repositories

mkdir -p /var/tmp/cache
mkdir -p /var/tmp/miniprofiler
mkdir -p /var/tmp/pids
mkdir -p /var/tmp/sessions
mkdir -p /var/tmp/sockets

mkdir -p /var/sqlite3

export RBENV_ROOT=/usr/local/share/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

redis-server /etc/redis.conf &
echo "started redis-server: " $?

cd gitlab

RAILS_ENV=production bundle exec rake db:create db:setup
echo "done setting up database:" $?

bundle exec rails server -p 10000 -e production


#bundle exec foreman start
#bundle exec unicorn_rails -p ${PORT:="10000"} -E ${RAILS_ENV:="development"} -c ${UNICORN_CONFIG:="config/unicorn.rb"}
#unicorn_rails -p 10000 -E "development" -c "config/unicorn.rb" -o 127.0.0.1
#echo "started foreman: " $?



