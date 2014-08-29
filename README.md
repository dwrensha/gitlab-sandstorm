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
brew install redis postgresql phantomjs libiconv icu4c
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

### Database initialization for development

```
cd gitlab
bundle exec rake db:create gitlab:setup
```

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
