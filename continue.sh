#! /bin/sh

set -x

rm -f /var/tmp/pids/*

redis-server /etc/redis.conf &
echo "started redis-server: " $?

cd gitlab

export SSH_CONNECTION=12345

export GEM_HOME=/gitlab/.bundle/ruby/2.1.0
RUBYOPT=-r/gitlab/.bundle/bundler/setup RAILS_ENV=production ./.bundle/ruby/2.1.0/bin/sidekiq -q post_receive -q default 2>&1 | awk '{print "sidekiq: " $0}' &
./bin/rails server -p 10000 -e production



