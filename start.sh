set -x

mkdir -p /var/redis
mkdir -p /var/log

mkdir -p /var/repositories
mkdir -p /var/gitlab-satellites

mkdir -p /var/tmp/repositories

mkdir -p /var/uploads

mkdir -p /var/sqlite3

cp initdb.sqlite3 /var/sqlite3/db.sqlite3

source continue.sh




