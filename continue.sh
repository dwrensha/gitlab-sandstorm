export SECRET_KEY_BASE=`base64 /dev/urandom | head -c 30`

set -x -e

base64 /dev/urandom | head -c 30 > /var/gitlab_shell_secret

redis-server /etc/redis.conf &
echo "started redis-server: " $?

export SSH_CONNECTION=12345 # gitlab-shell wants this variable to be set. Any value will do.

cd gitlab

export GEM_HOME=/gitlab/.bundle/ruby/2.1.0

if [ -f /var/migrations/20150818213832 ]
then
    echo "no migration necessary"
else
   RAILS_ENV=production ./bin/rake db:migrate
   mkdir -p /var/migrations/
   touch /var/migrations/20150818213832
fi

RUBYOPT=-r/opt/ruby/gitlab-bundle/bundler/setup RAILS_ENV=production /opt/ruby/gitlab-bundle/ruby/2.1.0/bin/sidekiq -q post_receive -q default -q archive_repo 2>&1 | awk '{print "sidekiq: " $0}' &
RUBYOPT=-r/opt/ruby/gitlab-bundle/bundler/setup RAILS_ENV=production /opt/ruby/gitlab-bundle/ruby/2.1.0/bin/unicorn_rails -p 10000 -E production -c /gitlab/config/unicorn.sandstorm.rb




