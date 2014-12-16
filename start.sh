#! /bin/sh

set -x

mkdir -p /var/redis
mkdir -p /var/log

mkdir -p /var/repositories
mkdir -p /var/gitlab-satellites

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

cp initdb.sqlite3 /var/sqlite3/db.sqlite3

# gitlab-shell wants this variable to be set. Any value will do.
export SSH_CONNECTION=12345

cd gitlab

RAILS_ENV=production bundle exec foreman start
#bundle exec rails server -p 10000 -e production





