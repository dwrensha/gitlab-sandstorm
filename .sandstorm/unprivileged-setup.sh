#!/bin/bash

set -euo pipefail


cd /opt/ruby

git clone https://github.com/rbenv/rbenv.git /opt/ruby/rbenv
git clone https://github.com/rbenv/ruby-build.git /opt/ruby/rbenv/plugins/ruby-build

export PATH=/opt/ruby/rbenv/bin:$PATH
export RBENV_ROOT=/opt/ruby/rbenv
eval "$(rbenv init -)"

rbenv install 2.1.8
rbenv shell 2.1.8

gem install bundler

cd /opt/app
make
