export GIT_COMPLETION_BASENAME=git-completion

gcompletion() {
	dl_completion https://raw.githubusercontent.com/git/git/master/contrib/completion/$GIT_COMPLETION_BASENAME.bash $GIT_COMPLETION_BASENAME.bash
}
