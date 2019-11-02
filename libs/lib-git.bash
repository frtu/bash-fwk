# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
# completion $GIT_COMPLETION_BASENAME

GIT_ENV_FILE=$LOCAL_SCRIPTS_FOLDER/env-git.bash

# Git branch in prompt.
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33m\]\W\[\033[m\]\$(parse_git_branch)\$"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
gpersist() {
  usage $# "GITHUB_ROOT_URL:github.com"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local GITHUB_ROOT_URL=$1
  echo "Persiting GITHUB_ROOT_URL=${GITHUB_ROOT_URL}!"
  echo "export PERSISTED_GITHUB_ROOT_URL=$GITHUB_ROOT_URL" > $GIT_ENV_FILE
}
grmcached() {
  usage $# "ITEM_TO_REMOVE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ITEM_TO_REMOVE=$1

  echo "git rm -r --cached $ITEM_TO_REMOVE"
  git rm -r --cached $ITEM_TO_REMOVE
}

gcl() {
  local REPO_NAME=$1
  local PROJECT_NAME=$2
  local BRANCH_NAME=$3
  local GITHUB_ROOT_URL=$4

  if [[ $1 == http* ]]; then
    echo "git clone $1"
    git clone $1
    
    local END_URL="${1##*\/}"
    local FOLDER_NAME="${END_URL%.*}"
    cd ${FOLDER_NAME}/
    return
  fi

  if [ -z "$GITHUB_ROOT_URL" ]; then
      # Take into account PERSISTED_GITHUB_ROOT_URL for Enterprise GitHub
      if [ -n "$PERSISTED_GITHUB_ROOT_URL" ]
        then
          echo "Use PERSISTED_GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}"
          local GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}
        else
          local GITHUB_ROOT_URL="github.com"
          echo "Use DEFAULT value : ${GITHUB_ROOT_URL}"
      fi
  fi

  ##################################
  # PARSE REPO_NAME/PROJECT_NAME
  # Check if first parameter contains is already REPO_NAME/PROJECT_NAME
  if [[ $1 == *\/* ]]; then
    local PROJECT_NAME="${1##*\/}"
    local REPO_NAME="${1%\/*}"
  fi
  ## USAGE IF NO PROJECT_NAME
  if [ -z $PROJECT_NAME ]; then
    usage $# "REPO_NAME" "PROJECT_NAME" "[BRANCH_NAME]" "[GITHUB_ROOT_URL:${GITHUB_ROOT_URL}]"
    return -1
  fi
  ##################################  
  
  local FOLDER_NAME=$PROJECT_NAME-$REPO_NAME

  echo "git clone git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git ${FOLDER_NAME}"
  git clone git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git ${FOLDER_NAME}
  cd ${FOLDER_NAME}/

  if [ -n "$BRANCH_NAME" ]; then
      echo "git checkout ${BRANCH_NAME}"
      git checkout ${BRANCH_NAME}
  fi
  gsub
}

gsub(){
  echo "git submodule update --init"
  git submodule update --init
}
gsubadd(){
  local REPO_NAME=$1
  local PROJECT_NAME=$2
  local BRANCH_NAME=$3
  local GITHUB_ROOT_URL=$4

  if [ -z "$GITHUB_ROOT_URL" ]; then
      # Take into account PERSISTED_GITHUB_ROOT_URL for Enterprise GitHub
      if [ -n "$PERSISTED_GITHUB_ROOT_URL" ]
        then
          echo "Use PERSISTED_GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}"
          local GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}
        else
          local GITHUB_ROOT_URL="github.com"
          echo "Use DEFAULT value : ${GITHUB_ROOT_URL}"
      fi
  fi

  ##################################
  # PARSE REPO_NAME/PROJECT_NAME
  # Check if first parameter contains is already REPO_NAME/PROJECT_NAME
  if [[ $1 == *\/* ]]; then
    local PROJECT_NAME="${1##*\/}"
    local REPO_NAME="${1%\/*}"
  fi
  ## USAGE IF NO PROJECT_NAME
  if [ -z $PROJECT_NAME ]; then
    usage $# "REPO_NAME" "PROJECT_NAME" "[BRANCH_NAME]" "[GITHUB_ROOT_URL:${GITHUB_ROOT_URL}]"
    return -1
  fi
  ##################################

  local EXTRA_ARGS="--force"
  if [ -n "$BRANCH_NAME" ]; then
    local EXTRA_ARGS="-b ${BRANCH_NAME} ${EXTRA_ARGS}"
  fi
  echo "git submodule add ${EXTRA_ARGS} git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git"
  git submodule add ${EXTRA_ARGS} git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git
}

gtagls() {
  echo "git tag"
  git tag
}
gtaglsdate() {
  gtagls | xargs -L1 git log --pretty=format:"%D %cI" -1 
}
gtagpush() {
  usage $# "TAG_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "==== Please push an existing tag ! Check existing tag using 'gtagls' ===="
    gtagls
    return -1; 
  fi

  local TAG_NAME=$1

  echo "git push origin ${TAG_NAME}:${TAG_NAME}"
  git push origin ${TAG_NAME}:${TAG_NAME}
}

gbrls() {
  echo "git branch -a"
  git branch -a
}
gbr() {
  usage $# "BRANCH_OR_TAG_NAME:master"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "==== Please use 'gtagls' to select an existing tag ===="
    gtagls
    echo "==== Please use 'gbrls' to select an existing branch (remove '/remotes/repo/' for a remote branch) ===="
    gbrls
    return -1; 
  fi

  local BRANCH_OR_TAG_NAME=$1
  echo "git checkout ${BRANCH_OR_TAG_NAME}"
  git checkout ${BRANCH_OR_TAG_NAME}
}
gbrcreate() {
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

      gbr $NEW_BRANCH_NAME

    else
      echo "git branch $BRANCH_NAME"
      git branch $BRANCH_NAME

      gbr $BRANCH_NAME
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

gremotels() {
  echo "List all remote repositories > git remote -v"
  git remote -v
}
gremoteadd() {
  local REPO_NAME=$1
  local PROJECT_NAME=$2
  local REMOTE_NAME=${3:-origin}
  local GITHUB_ROOT_URL=$4
  local BRANCH_NAME=${5:-master}

  if [ -z "$GITHUB_ROOT_URL" ]; then
      # Take into account PERSISTED_GITHUB_ROOT_URL for Enterprise GitHub
      if [ -n "$PERSISTED_GITHUB_ROOT_URL" ]
        then
          echo "Use PERSISTED_GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}"
          local GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}
        else
          local GITHUB_ROOT_URL="github.com"
          echo "Use DEFAULT value : ${GITHUB_ROOT_URL}"
      fi
  fi

  ##################################
  # PARSE REPO_NAME/PROJECT_NAME
  # Check if first parameter contains is already REPO_NAME/PROJECT_NAME
  if [[ $1 == *\/* ]]; then
    local PROJECT_NAME="${1##*\/}"
    local REPO_NAME="${1%\/*}"
  fi
  ## USAGE IF NO PROJECT_NAME
  if [ -z $PROJECT_NAME ]; then
    usage $# "REPO_NAME" "PROJECT_NAME" "[REMOTE_NAME:origin]" "[GITHUB_ROOT_URL:${GITHUB_ROOT_URL}]" "[BRANCH_NAME:master]"
    return -1
  fi
  ##################################
  ## USAGE IF NO PROJECT_NAME
  if [ ! -d .git ]; then
    echo "git init"
    git init
  fi

  echo "git remote add $REMOTE_NAME git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git"
  git remote add $REMOTE_NAME git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git

  echo "git fetch $REMOTE_NAME"
  git fetch $REMOTE_NAME

  gremotels

  echo "== First time link to a default branch > git checkout ${BRANCH_NAME} =="
  gbr ${BRANCH_NAME}
}
gremotemultiadd() {
  local REPO_NAME=$1
  local PROJECT_NAME=$2
  local BRANCH_NAME=$3
  local GITHUB_ROOT_URL=$4

  if [ -z "$GITHUB_ROOT_URL" ]; then
      # Take into account PERSISTED_GITHUB_ROOT_URL for Enterprise GitHub
      if [ -n "$PERSISTED_GITHUB_ROOT_URL" ]
        then
          echo "Use PERSISTED_GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}"
          local GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}
        else
          local GITHUB_ROOT_URL="github.com"
          echo "Use DEFAULT value : ${GITHUB_ROOT_URL}"
      fi
  fi

  ##################################
  # PARSE REPO_NAME/PROJECT_NAME
  # Check if first parameter contains is already REPO_NAME/PROJECT_NAME
  if [[ $1 == *\/* ]]; then
    local PROJECT_NAME="${1##*\/}"
    local REPO_NAME="${1%\/*}"
  fi
  ## USAGE IF NO PROJECT_NAME
  if [ -z $PROJECT_NAME ]; then
    usage $# "REPO_NAME" "PROJECT_NAME" "[BRANCH_NAME]" "[GITHUB_ROOT_URL:${GITHUB_ROOT_URL}]"
    return -1
  fi
  ##################################

  local REMOTE_NAME=repo-$REPO_NAME
  gremoteadd ${REPO_NAME} ${PROJECT_NAME} ${REMOTE_NAME} ${GITHUB_ROOT_URL}

  if [ -n "$BRANCH_NAME" ]
    then
      gbrcreate ${BRANCH_NAME} ${REPO_NAME}
    else
      echo "ADD A NEW BRANCH WITH > gbrcreate {BRANCH_NAME} ${REPO_NAME}"
  fi  
}
gremotemultimerge() {
  usage $# "REPO_NAME" "PROJECT_NAME" "BRANCH_NAME" "[GITHUB_ROOT_URL:github.com]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local REPO_NAME=$1
  local PROJECT_NAME=$2
  local BRANCH_NAME=$3
  local GITHUB_ROOT_URL=$4

  if [ -z "$GITHUB_ROOT_URL" ]; then
      # Take into account PERSISTED_GITHUB_ROOT_URL for Enterprise GitHub
      if [ -n "$PERSISTED_GITHUB_ROOT_URL" ]
        then
          echo "Use PERSISTED_GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}"
          local GITHUB_ROOT_URL=${PERSISTED_GITHUB_ROOT_URL}
        else
          local GITHUB_ROOT_URL="github.com"
          echo "Use DEFAULT value : ${GITHUB_ROOT_URL}"
      fi
  fi

  echo "git pull git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git ${BRANCH_NAME}"
  git pull git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git ${BRANCH_NAME}
}
gremoterm() {
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
gconfls() {
  local CONF_PARAM=${1:---list}
  echo "git config $CONF_PARAM"
  git config $CONF_PARAM
}
gconfset() {
  usage $# "CONF_PARAM_NAME" "CONF_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CONF_PARAM_NAME=$1
  local CONF_PARAM_VALUE=$2

  echo "git config --global $CONF_PARAM_NAME \"$CONF_PARAM_VALUE\""
  git config --global $CONF_PARAM_NAME "$CONF_PARAM_VALUE"
}
gconfsetname() {
  usage $# "NAME_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  gconfset user.name "$1"
}
gconfsetemail() {
  usage $# "EMAIL_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  gconfset user.email "$1"
}
gconfsetproxy() {
  usage $# "PROXY_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  gconfset http.proxy "$1"
}
