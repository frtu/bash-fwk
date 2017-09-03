# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
completion $GIT_COMPLETION_BASENAME

# Git branch in prompt.
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33m\]\W\[\033[m\]\$(parse_git_branch)\$"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


gtag() {
  git tag
}
gtagdate() {
  gtag | xargs -L1 git log --pretty=format:"%D %cI" -1 
}

gpatch() {
	if [ -z "$1" ]
    	then
        	local DIFF_NAME=diff
	    else
    	    local DIFF_NAME=$1
  	fi
	echo "git diff > $DIFF_NAME.patch"
	git diff > $DIFF_NAME.patch
}
gpatchapply() {
	if [ -z "$1" ]
    	then
        	local DIFF_NAME=diff
	    else
    	    local DIFF_NAME=$1
  	fi
	
	if [ -f "$DIFF_NAME.patch" ]; then
		echo "Applying patch with 'git apply $DIFF_NAME.patch'"
		git apply $DIFF_NAME.patch
	fi
}
