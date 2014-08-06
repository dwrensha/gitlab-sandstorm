gitlab_repo = https://gitlab.com/gitlab-org/gitlab-ce.git
gitlab_shell_repo = https://gitlab.com/gitlab-org/gitlab-shell.git

all: gitlab/.git gitlab-shell/.git

gitlab/.git:
	git clone ${gitlab_repo} gitlab

gitlab-shell/.git:
	git clone ${gitlab_shell_repo} gitlab-shell
