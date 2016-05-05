#!/bin/bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y nodejs-dev nodejs-legacy git libsqlite3-dev cmake pkg-config libicu-dev g++ redis-server golang-go

mkdir /opt/ruby
chown vagrant:vagrant /opt/ruby

# TODO(cleanup): the logic this unpriviliged-setup script probably belongs in build.sh.
su -c "bash /opt/app/.sandstorm/unprivileged-setup.sh" vagrant

exit 0
