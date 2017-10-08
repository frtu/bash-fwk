# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
completion $GIT_COMPLETION_BASENAME

# Git branch in prompt.
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33m\]\W\[\033[m\]\$(parse_git_branch)\$"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

gdff() {
  if [ $# -eq 0 ]; then
    echo "Please specify parameters > 'dff FOLDER_SOURCE FOLDER_TARGET'."
    return -1
  fi
  echo "patch -p$LEVEL -t -i $FILENAME"
  diff -rupN $1 $2
}
gpch() {
  if [ $# -eq 0 ]; then
    echo "Please specify parameters > 'pch PATCH_FILE_NAME'."
    return -1
  fi
  local FILENAME=$1
  local LEVEL=${2:-1}
  echo "patch -p$LEVEL -t -i $FILENAME"
  patch -p$LEVEL -t -i $FILENAME
}

gtag() {
  git tag
}
gtagdate() {
  gtag | xargs -L1 git log --pretty=format:"%D %cI" -1 
}

glog() {
	local NUMBER=${1:-10}
	echo "git log --oneline -n $NUMBER"
	git log --oneline -n $NUMBER
}
greset() {
	local HASH=${1:-HEAD}
	echo "git reset --hard $HASH"
	git reset --hard $HASH
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
