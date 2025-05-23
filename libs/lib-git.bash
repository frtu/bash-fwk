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
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local GITHUB_ROOT_URL=$1
  echo "Persiting GITHUB_ROOT_URL=${GITHUB_ROOT_URL}!"
  echo "export PERSISTED_GITHUB_ROOT_URL=$GITHUB_ROOT_URL" > $GIT_ENV_FILE
}
grmcached() {
  usage $# "ITEM_TO_REMOVE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local ITEM_TO_REMOVE=$1

  echo "git rm -r --cached $ITEM_TO_REMOVE"
  git rm -r --cached $ITEM_TO_REMOVE
}

gstatus() {
  echo "git status"
  git status
}
gsafe() {
  echo "git config --global --add safe.directory '*'"
  git config --global --add safe.directory '*'
}

gbase() {
  usage $# "[MESSAGE]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "git init"
  git init

  local MESSAGE=${1:-Init}
  gaddall ${MESSAGE}
}
gbaserm() {
  echo "rm -Rf .git"
  rm -Rf .git
}
gs() {
  echo "git stash $@"
  git stash $@
}
gsp() {
  gs pop
}
gadd() {
  usage $# "FILE_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gtpl add $@  
}
gaddall() {
  usage $# "MESSAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local MESSAGE=$1
  echo "git add -A"
  git add -A

  echo "git commit -am \"$MESSAGE\""
  git commit -am "$MESSAGE"
}
gcomm() {
  usage $# "MESSAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local MESSAGE=$1
  echo "git commit -m ${MESSAGE}"
  git commit -m ${MESSAGE}
}
# https://www.atlassian.com/git/tutorials/rewriting-history
gamend() {
  usage $# "[MESSAGE]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local MESSAGE=$1
  if [ -n "$MESSAGE" ]; then
    local PARAMS="-m \"${MESSAGE}\""
  else
    local PARAMS="--no-edit"
  fi

  echo "git commit --amend ${PARAMS}"
  git commit --amend ${PARAMS}
}
gdiff() {
  usage $# "NUM_OF_COMMIT" "[FILE_PATH]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local NUM_OF_COMMIT=$1
  local FILE_PATH=$2

  if [ -n "$FILE_PATH" ]
    then
      gtpl diff HEAD~${NUM_OF_COMMIT} HEAD > $FILE_PATH
    else
      gtpl diff HEAD~${NUM_OF_COMMIT} HEAD
  fi
}
gdifffile() {
  usage $# "FILE_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gtpl diff $@  
}
grollback() {
  usage $# "FILE_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gtpl checkout $@
}
grb() {
  gtpl checkout $@
}
gtpl() {
  usage $# "CMD" "FILE_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    gstatus
    return 1;
  fi

  local CMD=$1
  local FILE_PATH=$2
  echo "git ${CMD} ${FILE_PATH}"
  git ${CMD} ${FILE_PATH}
}

gf() {
  echo "git fetch --all"
  git fetch --all
}
gl() {
  usage $# "[REMOTE_REPO_NAME:origin]" "[REMOTE_BRANCH:master]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "git pull $@"
  git pull $@
}
ghf() {
  gh --force $@
}
gh() {
  usage $# "[REMOTE_REPO_NAME:origin]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "git push $@"
  git push $@
}
gcl() {
  local REPO_NAME=$1
  local PROJECT_NAME=$2
  local BRANCH_NAME=$3
  local GITHUB_ROOT_URL=$4

  if [[ $REPO_NAME == http* ]] || [[ $REPO_NAME == git@* ]] || [[ $REPO_NAME == ssh@* ]] ; then
    echo "git clone $@"
    git clone $@
    
    local END_URL="${2:-$1##*\/}"
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
    return 1
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
    return 1
  fi
  ##################################

  local EXTRA_ARGS="--force"
  if [ -n "$BRANCH_NAME" ]; then
    local EXTRA_ARGS="-b ${BRANCH_NAME} ${EXTRA_ARGS}"
  fi
  echo "git submodule add ${EXTRA_ARGS} git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git"
  git submodule add ${EXTRA_ARGS} git@${GITHUB_ROOT_URL}:${REPO_NAME}/${PROJECT_NAME}.git
}

glog() {
  echo "git log"
  git log
}
gtagls() {
  echo "git tag"
  git tag
}
gtaglsdate() {
  gtagls | xargs -L1 git log --pretty=format:"%D %cI" -1 
}
gtagpush() {
  usage $# "TAG_NAME" "[REMOTE_REPO_NAME:origin]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "==== Please push an existing tag ! Check existing tag using 'gtagls' ===="
    gtagls
    return 1; 
  fi

  local TAG_NAME=$1

  echo "git push ${REMOTE_REPO_NAME} ${TAG_NAME}:${TAG_NAME}"
  git push ${REMOTE_REPO_NAME} ${TAG_NAME}:${TAG_NAME}
}
gtagrm() {
  usage $# "TAG_NAME" "[REMOTE_REPO_NAME:origin]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "==== Please specify a tag to remove ! Check existing tag using 'gtagls' ===="
    gtagls
    return 1; 
  fi

  local TAG_NAME=$1
  local REMOTE_REPO_NAME=${2:-origin}

  echo "git tag -d ${TAG_NAME}"
  git tag -d ${TAG_NAME}

  echo "git push ${REMOTE_REPO_NAME} :refs/tags/${TAG_NAME}"
  git push ${REMOTE_REPO_NAME} :refs/tags/${TAG_NAME}
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
    return 1; 
  fi

  local BRANCH_OR_TAG_NAME=$1
  echo "git checkout ${BRANCH_OR_TAG_NAME}"
  git checkout ${BRANCH_OR_TAG_NAME}
}
# git stash checkout pop
gbrsp() {
  usage $# "BRANCH_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  glsp $@
}
# git stash checkout pop
glsp() {
  usage $# "[BRANCH_NAME]"

  local BRANCH_NAME=$1
  gs
  if [ -n "$BRANCH_NAME" ]; then
    gbr ${BRANCH_NAME}
  fi
  gl
  gsp
}

# git branch
gbrc() {
  usage $# "BRANCH_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local BRANCH_NAME=$1
  echo "git branch $BRANCH_NAME"
  git branch $BRANCH_NAME

  gbr ${BRANCH_NAME} 
}
gbrcreate() {
  usage $# "BRANCH_NAME:master" "[REMOTE_REPO_NAME:origin]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local BRANCH_NAME=$1
  local REMOTE_REPO_NAME=$2

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
  if [[ "$?" -ne 0 ]]; then return 1; fi

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
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local OLD_BRANCH_NAME=$1
  local NEW_BRANCH_NAME=$2

  echo "git branch -m ${OLD_BRANCH_NAME} ${NEW_BRANCH_NAME}"
  git branch -m ${OLD_BRANCH_NAME} ${NEW_BRANCH_NAME}
}
grebaseremote() {
  usage $# "BRANCH_NAME:master" "[REMOTE_REPO_NAME:origin]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local BRANCH_NAME=$1
  local REMOTE_REPO_NAME=${2:-origin}

  echo "git pull --rebase ${REMOTE_REPO_NAME} ${BRANCH_NAME}"
  git pull --rebase ${REMOTE_REPO_NAME} ${BRANCH_NAME}
}

gfm() {
  gbrsp master
}
gfd() {
  gbrsp develop
}
gff() {
  usage $# "FEATURE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local FEATURE_NAME=$1
  gbrsp feature/${FEATURE_NAME}
}
gffc() {
  usage $# "FEATURE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local FEATURE_NAME=$1
  gbrc feature/${FEATURE_NAME}
}
gfr() {
  usage $# "RELEASE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RELEASE_NAME=$1
  gbrsp release/${RELEASE_NAME}
}
gfrc() {
  usage $# "RELEASE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RELEASE_NAME=$1
  gbrc release/${RELEASE_NAME}
}
gfh() {
  usage $# "HOTFIX_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local HOTFIX_NAME=$1
  gbrsp hotfix/${HOTFIX_NAME}
}
gfhc() {
  usage $# "HOTFIX_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local HOTFIX_NAME=$1
  gbrc hotfix/${HOTFIX_NAME}
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
    return 1
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
    return 1
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
  if [[ "$?" -ne 0 ]]; then return 1; fi

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
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local REMOTE_NAME=remote-$1
  echo "git remote remove $REMOTE_NAME"
  git remote remove $REMOTE_NAME
}

# Reset to previous commit
greset() {
  usage $# "COMMIT_ID"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any COMMIT_ID run 'glog'" >&2 
    return 1
  fi

  local COMMIT_ID=$1
  gs
  git reset --hard ${COMMIT_ID}
  gsp
}

gpatch() {
  usage $# "DIFF_FILENAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local DIFF_FILENAME=${1:-diff}
	echo "git diff > $DIFF_FILENAME.patch"
	git diff > $DIFF_FILENAME.patch
}
gpatchapply() {
  usage $# "DIFF_FILENAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

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
gconfedit() {
  code .git/config
}
gconf() {
  local CONF_PARAM=${1:---list}
  echo "git config $CONF_PARAM"
  git config $CONF_PARAM
}
gconfset() {
  usage $# "CONF_PARAM_NAME" "CONF_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CONF_PARAM_NAME=$1
  local CONF_PARAM_VALUE=$2

  echo "git config --global $CONF_PARAM_NAME \"$CONF_PARAM_VALUE\""
  git config --global $CONF_PARAM_NAME "$CONF_PARAM_VALUE"
}
gconfsetname() {
  usage $# "NAME_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gconfset user.name "$1"
}
gconfsetemail() {
  usage $# "EMAIL_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gconfset user.email "$1"
}
gconfsetproxy() {
  usage $# "PROXY_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gconfset http.proxy "$1"
}
gconfsetpushsetupremote() {
  usage $# "PULL_REBASE_PARAM_VALUE:true"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gconfset "--add --bool push.autoSetupRemote" "$1"
}
gconfsetpullrebase() {
  usage $# "PULL_REBASE_PARAM_VALUE:true"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gconfset pull.rebase "$1"
}

glfs() {
  echo "git lfs env"
  git lfs env
}
glfsinst() {
  echo "git lfs install --skip-repo"
  git lfs install --skip-repo
}