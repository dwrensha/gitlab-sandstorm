export RBENV_ROOT=/usr/local/share/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

redis-server /etc/redis.conf &
echo "started redis-server: " $?

cd gitlab

bundle exec rails server -p 10000 -e production


