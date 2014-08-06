gitlab_repo = https://gitlab.com/gitlab-org/gitlab-ce.git
gitlab_shell_repo = https://gitlab.com/gitlab-org/gitlab-shell.git
gitlab_development_root = $(shell pwd)

all: clone bundle config

clone: gitlab/.git gitlab-shell/.git

config: gitlab-shell/config.yml gitlab/config/gitlab.yml gitlab/config/database.yml gitlab/config/unicorn.rb

bundle: gitlab-shell-bundle gitlab-bundle

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
	sed -e '/username:/d' -e '/password:/d' gitlab/config/database.yml.postgresql > gitlab/config/database.yml

gitlab/config/unicorn.rb:
	sed "s|/home/git|${gitlab_development_root}|" gitlab/config/unicorn.rb.example > gitlab/config/unicorn.rb
