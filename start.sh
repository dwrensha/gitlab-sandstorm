export SECRET_KEY_BASE=`base64 /dev/urandom | head -c 30`

set -x

mkdir -p /var/redis
mkdir -p /var/log

mkdir -p /var/repositories
mkdir -p /var/gitlab-satellites

mkdir -p /var/tmp/repositories

mkdir -p /var/uploads

mkdir -p /var/sqlite3

redis-server /etc/redis.conf &
echo "started redis-server: " $?

cp initdb.sqlite3 /var/sqlite3/db.sqlite3

export SSH_CONNECTION=12345 # gitlab-shell wants this variable to be set. Any value will do.

cd gitlab
export GEM_HOME=/gitlab/.bundle/ruby/2.1.0
RUBYOPT=-r/gitlab/.bundle/bundler/setup RAILS_ENV=production ./.bundle/ruby/2.1.0/bin/sidekiq -q post_receive -q default -q archive_repo 2>&1 | awk '{print "sidekiq: " $0}' &
./bin/rails server -p 10000 -e production





