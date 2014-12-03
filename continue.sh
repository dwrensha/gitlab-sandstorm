#! /bin/sh

set -x

redis-server /etc/redis.conf
echo "started redis-server: " $?

bundle exec foreman start
echo "started foreman: " $?

sleep infinity
