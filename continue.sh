export SECRET_KEY_BASE=`base64 /dev/urandom | head -c 30`

set -x -e

base64 /dev/urandom | head -c 30 > /var/gitlab_shell_secret

# The sandbox's /tmp is capped at 16MB. If we don't set TMPDIR, a `git push` bigger than that will fail.
export TMPDIR=/var/tmp
rm -rf /var/tmp
mkdir -p /var/tmp

redis-server /etc/redis.conf &
echo "started redis-server: " $?

export SSH_CONNECTION=12345 # gitlab-shell wants this variable to be set. Any value will do.

cd gitlab

export GEM_HOME=/opt/ruby/gitlab-bundle/ruby/2.1.0

if [ -f /var/migrations/20160421130527 ]
then
    echo "no migration necessary"
else
   RUBYOPT=-r/opt/ruby/gitlab-bundle/bundler/setup RAILS_ENV=production /opt/ruby/gitlab-bundle/ruby/2.1.0/bin/rake db:migrate
   mkdir -p /var/migrations/
   touch /var/migrations/20160421130527
fi

RUBYOPT=-r/opt/ruby/gitlab-bundle/bundler/setup RAILS_ENV=production /opt/ruby/gitlab-bundle/ruby/2.1.0/bin/sidekiq -q post_receive -q default -q archive_repo 2>&1 | awk '{print "sidekiq: " $0}' &
RUBYOPT=-r/opt/ruby/gitlab-bundle/bundler/setup RAILS_ENV=production /opt/ruby/gitlab-bundle/ruby/2.1.0/bin/unicorn_rails -p 10001 -E production -c /gitlab/config/unicorn.sandstorm.rb &

# Give Unicorn some time to start listening.
sleep 3

../gitlab-workhorse/gitlab-workhorse -listenAddr 127.0.0.1:10000 -authBackend http://127.0.0.1:10001





