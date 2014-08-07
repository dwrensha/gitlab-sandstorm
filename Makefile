gitlab_repo = https://gitlab.com/gitlab-org/gitlab-ce.git
gitlab_shell_repo = https://gitlab.com/gitlab-org/gitlab-shell.git
gitlab_development_root = $(shell pwd)

all: clone bundle config support

clone: gitlab/.git gitlab-shell/.git

config: gitlab-shell/config.yml gitlab/config/gitlab.yml gitlab/config/database.yml gitlab/config/unicorn.rb gitlab/config/resque.yml

bundle: gitlab-shell-bundle gitlab-bundle
	bundle install

support: Procfile redis postgresql

redis: redis/redis.conf

gitlab/.git:
	git clone ${gitlab_repo} gitlab

gitlab-shell/.git:
	git clone ${gitlab_shell_repo} gitlab-shell

gitlab-bundle:
	cd gitlab && bundle install --without mysql

gitlab-shell-bundle:
	cd gitlab-shell && bundle install

gitlab/config/gitlab.yml:
	sed "s|/home/git|${gitlab_development_root}|" gitlab/config/gitlab.yml.example > gitlab/config/gitlab.yml

gitlab-shell/config.yml:
	sed "s|/home/git|${gitlab_development_root}|" gitlab-shell/config.yml.example > gitlab-shell/config.yml

gitlab/config/database.yml:
	sed "s|/home/git|${gitlab_development_root}|" database.yml.example > gitlab/config/database.yml

gitlab/config/unicorn.rb:
	sed "s|/home/git|${gitlab_development_root}|" gitlab/config/unicorn.rb.example > gitlab/config/unicorn.rb

redis: redis/redis.conf

redis/redis.conf:
	sed "s|/home/git|${gitlab_development_root}|" $@.example > $@

gitlab/config/resque.yml:
	sed "s|/home/git|${gitlab_development_root}|" redis/resque.yml.example > $@

postgresql: postgresql/data/PG_VERSION

postgresql/data/PG_VERSION:
	initdb -E utf-8 postgresql/data

Procfile:
	sed "s|/home/git|${gitlab_development_root}|g" $@.example > $@
