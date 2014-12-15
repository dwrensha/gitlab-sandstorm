export RBENV_ROOT=/usr/local/share/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

rm -f /var/tmp/pids/*

redis-server /etc/redis.conf &
echo "started redis-server: " $?

cd gitlab

export SSH_CONNECTION=12345

RAILS_ENV=production bundle exec foreman start
#bundle exec rails server -p 10000 -e production


