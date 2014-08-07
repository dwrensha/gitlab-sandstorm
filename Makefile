gitlab_repo = https://gitlab.com/gitlab-org/gitlab-ce.git
gitlab_shell_repo = https://gitlab.com/gitlab-org/gitlab-shell.git
gitlab_development_root = $(shell pwd)

all: gitlab-setup gitlab-shell-setup support-setup

# Set up the GitLab Rails app

gitlab-setup: gitlab/.git gitlab-config gitlab/.bundle

gitlab/.git:
	git clone ${gitlab_repo} gitlab

gitlab-config: gitlab/config/gitlab.yml gitlab/config/database.yml gitlab/config/unicorn.rb gitlab/config/resque.yml

gitlab/config/gitlab.yml:
	sed "s|/home/git|${gitlab_development_root}|" gitlab/config/gitlab.yml.example > gitlab/config/gitlab.yml

gitlab/config/database.yml:
	sed "s|/home/git|${gitlab_development_root}|" database.yml.example > gitlab/config/database.yml

gitlab/config/unicorn.rb:
	sed "s|/home/git|${gitlab_development_root}|" gitlab/config/unicorn.rb.example > gitlab/config/unicorn.rb

gitlab/config/resque.yml:
	sed "s|/home/git|${gitlab_development_root}|" redis/resque.yml.example > $@

gitlab/.bundle:
	cd gitlab && bundle install --without mysql --path .bundle

# Set up gitlab-shell

gitlab-shell-setup: gitlab-shell/.git gitlab-shell/config.yml gitlab-shell/.bundle

gitlab-shell/.git:
	git clone ${gitlab_shell_repo} gitlab-shell

gitlab-shell/config.yml:
	sed "s|/home/git|${gitlab_development_root}|" gitlab-shell/config.yml.example > gitlab-shell/config.yml

gitlab-shell/.bundle:
	cd gitlab-shell && bundle install --path .bundle

# Set up supporting services

support-setup: Procfile redis postgresql .bundle

Procfile:
	sed "s|/home/git|${gitlab_development_root}|g" $@.example > $@

redis: redis/redis.conf

redis/redis.conf:
	sed "s|/home/git|${gitlab_development_root}|" $@.example > $@

postgresql: postgresql/data/PG_VERSION

postgresql/data/PG_VERSION:
	initdb -E utf-8 postgresql/data

.bundle:
	bundle install --path .bundle
