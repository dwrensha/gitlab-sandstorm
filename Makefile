gitlab_repo = https://github.com/dwrensha/gitlabhq.git
gitlab_repo_branch = sandstorm-app
gitlab_shell_repo = https://github.com/dwrensha/gitlab-shell.git
gitlab_shell_repo_branch = sandstorm-app
gitlab_development_root=
postgres_bin_dir = $(shell pg_config --bindir)

all: gitlab-setup gitlab-shell-setup support-setup

# Set up the GitLab Rails app

gitlab-setup: gitlab/.git gitlab/.bundle initdb.sqlite3

gitlab/.git:
	git clone ${gitlab_repo} gitlab && cd gitlab && git checkout ${gitlab_repo_branch}

gitlab/.bundle:
	cd gitlab && bundle install --path .bundle --without test development --jobs 4 --standalone

initdb.sqlite3: gitlab/.bundle
	rm -rf db
	mkdir db
	find gitlab/.bundle -type f -name "jquery.atwho.js" -exec sed -i 's/@ sourceMappingURL=jquery.caret.map//g' {} \;
	cd gitlab && RAILS_ENV=production bundle exec rake db:create db:setup && RAILS_ENV=production ./bin/rake assets:precompile
	mv db/db.sqlite3 initdb.sqlite3
	rm -rf db
	ln -s /var/sqlite3 db

# Set up gitlab-shell

gitlab-shell-setup: gitlab-shell/.git gitlab-shell/.bundle

gitlab-shell/.git:
	git clone ${gitlab_shell_repo} gitlab-shell && git checkout ${gitlab_shell_repo_branch}

gitlab-shell/.bundle:
	cd gitlab-shell && bundle install --path vendor/bundle --without test development --jobs 4

# Update gitlab and gitlab-shell

update: gitlab-update gitlab-shell-update

gitlab-update: gitlab/.git/pull
	cd gitlab && \
	bundle install --without mysql production --jobs 4 && \
	bundle exec rake db:migrate

gitlab-shell-update: gitlab-shell/.git/pull
	cd gitlab-shell && \
	bundle install --without production --jobs 4

gitlab/.git/pull:
	cd gitlab && git pull --ff-only

gitlab-shell/.git/pull:
	cd gitlab-shell && git pull --ff-only

# Set up supporting services

support-setup: Procfile .bundle
	@echo ""
	@echo "*********************************************"
	@echo "************** Setup finished! **************"
	@echo "*********************************************"
	sed -n '/^### Post-installation/,/^END Post-installation/p' README.md
	@echo "*********************************************"

Procfile:
	sed -e "s|/home/git|${gitlab_development_root}|g"\
	  -e "s|postgres |${postgres_bin_dir}/postgres |"\
	  $@.example > $@

postgresql: postgresql/data/PG_VERSION

postgresql/data/PG_VERSION:
	${postgres_bin_dir}/initdb -E utf-8 postgresql/data

.bundle:
	bundle install --jobs 4
