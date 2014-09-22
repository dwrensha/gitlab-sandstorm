# GitLab Development Kit

Run a GitLab development environment isolated in a directory.

This project uses Foreman to run dedicated Postgres and Redis processes for
GitLab development. All data is stored inside the gitlab-development-kit
directory. All connections to supporting services go through Unix domain
sockets to avoid port conflicts.

## Design goals

- Get the user started, do not try to take care of everything
- Run everything as your 'desktop' user on your development machine
- GitLab Development Kit itself does not run `sudo` commands
- It is OK to leave some things to the user (e.g. installing Ruby)

## Installation

### Pre-installation

Ensure you have installed Ruby 2.1 and Bundler with your method of choice (RVM, ruby-build, rbenv, chruby, etc.).

### Install dependencies

#### OS X 10.9

```
brew tap homebrew/dupes
brew install redis postgresql phantomjs libiconv icu4c pkg-config cmake
bundle config build.nokogiri --with-iconv-dir=/usr/local/opt/libiconv
```

#### Ubuntu

```
sudo apt-get install postgresql libpq-dev phantomjs redis-server libicu-dev cmake
```

#### Debian

TODO

#### RedHat

TODO

### Clone GitLab Development Kit repository

```
git clone https://gitlab.com/gitlab-org/gitlab-development-kit.git
cd gitlab-development-kit
```

### Install the repositories and gems

The Makefile will clone the repositories, install the Gem bundles and set up
basic configuration files.

```
# Clone the official repositories of gitlab and gitlab-shell
make
```

Alternatively, you can clone straight from your forked repositories or GitLab EE.

```
# Clone your own forked repositories
make gitlab_repo=git@gitlab.com:example/gitlab-ce.git gitlab_shell_repo=git@gitlab.com:example/gitlab-shell.git
```

### Post-installation

Start Redis and PostgreSQL by running the command below.

    bundle exec foreman start

Seed the main GitLab database:

    cd gitlab && bundle exec rake db:create dev:setup

Finally, start the main GitLab rails application:

    bundle exec foreman start

END Post-installation

## Development

When doing development, you will need one shell session (terminal window)
running Postgres and Redis, and one or more other sessions to work on GitLab
itself.

### Example

First start Postgres and Redis.

```
# terminal window 1
# current directory: gitlab-development-kit
bundle exec foreman start
```

Next, start a Rails development server.

```
# terminal window 2
# current directory: gitlab-development-kit/gitlab
bundle exec foreman start
```

Now you can go to http://localhost:3000 in your browser.

## Troubleshooting

### Rails cannot connect to Postgres

- Check if foreman is running in the gitlab-development-kit directory.
- Check for custom Postgres connection settings defined via the environment; we
  assume none such variables are set. Look for them with `set | grep '^PG'`.

### 'LoadError: dlopen' when starting Ruby apps

This can happen when you try to load a Ruby gem with native extensions that
were linked against a system library that is no longer there. A typical culprit
is Homebrew on OS X, which encourages frequent updates (`brew update && brew
upgrade`) which may break binary compatibility.

```
bundle exec rake db:create gitlab:setup
rake aborted!
LoadError: dlopen(/Users/janedoe/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/extensions/x86_64-darwin-13/2.1.0-static/charlock_holmes-0.6.9.4/charlock_holmes/charlock_holmes.bundle, 9): Library not loaded: /usr/local/opt/icu4c/lib/libicui18n.52.1.dylib
  Referenced from: /Users/janedoe/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/extensions/x86_64-darwin-13/2.1.0-static/charlock_holmes-0.6.9.4/charlock_holmes/charlock_holmes.bundle
  Reason: image not found - /Users/janedoe/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/extensions/x86_64-darwin-13/2.1.0-static/charlock_holmes-0.6.9.4/charlock_holmes/charlock_holmes.bundle
/Users/janedoe/gitlab-development-kit/gitlab/config/application.rb:6:in `<top (required)>'
/Users/janedoe/gitlab-development-kit/gitlab/Rakefile:5:in `require'
/Users/janedoe/gitlab-development-kit/gitlab/Rakefile:5:in `<top (required)>'
(See full trace by running task with --trace)
```

In the above example, you see that the charlock_holmes gem fails to load
`libicui18n.52.1.dylib`. You can try fixing this by re-installing
charlock_holmes:

```
# in /Users/janedoe/gitlab-development-kit
gem uninstall charlock_holmes
bundle install # should reinstall charlock_holmes
```
