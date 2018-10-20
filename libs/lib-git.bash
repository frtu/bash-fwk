# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
completion $GIT_COMPLETION_BASENAME

# Git branch in prompt.
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33m\]\W\[\033[m\]\$(parse_git_branch)\$"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

grmcached() {
  usage $# "ITEM_TO_REMOVE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ITEM_TO_REMOVE=$1

  echo "git rm -r --cached $ITEM_TO_REMOVE"
  git rm -r --cached $ITEM_TO_REMOVE
}

gsub(){
  echo "git submodule update --init"
  git submodule update --init
}
gtag() {
  echo "git tag"
  git tag
}
gtagdate() {
  gtag | xargs -L1 git log --pretty=format:"%D %cI" -1 
}

gbrls() {
  echo "git branch -a"
  git branch -a
}
gbradd() {
  usage $# "BRANCH_NAME:master" "[REPO_NAME:origin]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local BRANCH_NAME=$1
  local REPO_NAME=$2

  if [ -n "$REPO_NAME" ]
    then
      if [ "$REPO_NAME" = "origin" ]
        then
          local NEW_REPO_NAME=$REPO_NAME
          local NEW_BRANCH_NAME=$BRANCH_NAME
        else
          local NEW_REPO_NAME=repo-$REPO_NAME
          local NEW_BRANCH_NAME=$NEW_REPO_NAME-$BRANCH_NAME
      fi
      echo "git branch $NEW_BRANCH_NAME repo-$REPO_NAME/$BRANCH_NAME"
      git branch $NEW_BRANCH_NAME $NEW_REPO_NAME/$BRANCH_NAME
      echo "git checkout $NEW_BRANCH_NAME"
      git checkout $NEW_BRANCH_NAME

    else
      echo "git branch $BRANCH_NAME"
      git branch $BRANCH_NAME
      echo "git checkout $BRANCH_NAME"
      git checkout $BRANCH_NAME
  fi
  git pull
}
gbrrm() {
  usage $# "BRANCH_NAME" "[FALLBACK_BRANCH_AFTER_DELETE:master]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local BRANCH_NAME=$1
  local FALLBACK_BRANCH_AFTER_DELETE=${2:-master}

  echo "git checkout ${FALLBACK_BRANCH_AFTER_DELETE}"
  git checkout ${FALLBACK_BRANCH_AFTER_DELETE}

  echo "git branch -D ${BRANCH_NAME}"
  git branch -D ${BRANCH_NAME}
}
gbrmv() {
  usage $# "OLD_BRANCH_NAME" "NEW_BRANCH_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local OLD_BRANCH_NAME=$1
  local NEW_BRANCH_NAME=$2

  echo "git branch -m ${OLD_BRANCH_NAME} ${NEW_BRANCH_NAME}"
  git branch -m ${OLD_BRANCH_NAME} ${NEW_BRANCH_NAME}
}

gbrremotels() {
  echo "List all remote branches > git remote -v"
  git remote -v
}
gbrremoteadd() {
  usage $# "REPO_NAME" "GITHUB_PROJECT" "[GITHUB_ROOT_URL:github.com]" "[BRANCH_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local REPO_NAME=$1
  local GITHUB_PROJECT=$2
  local GITHUB_ROOT_URL=${3:-github.com}
  local BRANCH_NAME=$4

  local REMOTE_NAME=repo-$REPO_NAME

  echo "git remote add $REMOTE_NAME git@$GITHUB_ROOT_URL:$REPO_NAME/$GITHUB_PROJECT.git"
  git remote add $REMOTE_NAME git@$GITHUB_ROOT_URL:$REPO_NAME/$GITHUB_PROJECT.git
  echo "git fetch $REMOTE_NAME"
  git fetch $REMOTE_NAME

  gbrremotels

  if [ -n "$BRANCH_NAME" ]
    then
      gbradd ${BRANCH_NAME} ${REPO_NAME}
    else
      echo "ADD A NEW BRANCH WITH > gbradd {BRANCH_NAME} ${REPO_NAME}"
  fi
}
gbrremoterm() {
  usage $# "REMOTE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local REMOTE_NAME=remote-$1
  echo "git remote remove $REMOTE_NAME"
  git remote remove $REMOTE_NAME
}

gpatch() {
  usage $# "DIFF_FILENAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DIFF_FILENAME=${1:-diff}
	echo "git diff > $DIFF_FILENAME.patch"
	git diff > $DIFF_FILENAME.patch
}
gpatchapply() {
  usage $# "DIFF_FILENAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DIFF_FILENAME=${1:-diff}	
	if [ -f "$DIFF_FILENAME.patch" ]; then
		echo "Applying patch with 'git apply $DIFF_FILENAME.patch'"
		git apply $DIFF_FILENAME.patch
	fi
  if [ -f "$DIFF_FILENAME" ]; then
    echo "Applying patch with 'git apply $DIFF_FILENAME'"
    git apply $DIFF_FILENAME
  fi
}
