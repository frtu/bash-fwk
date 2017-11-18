export LOCAL_COMPLETION_FOLDER=~/scr-completion-local

export GIT_COMPLETION_BASENAME=git-completion

completion() {
  load_file "$LOCAL_COMPLETION_FOLDER/$1.bash"
}
dl_completion() {
  if [ $# -lt 2 ]; then
    echo "Please specify parameters > 'dl_completion DL_URL BASH_FILENAME'."
    return -1
  fi

  local DL_URL=$1
  local BASH_FILENAME=$2
  
  mkdir -p $LOCAL_COMPLETION_FOLDER
  echo "Download locally $LOCAL_COMPLETION_FOLDER/$BASH_FILENAME"
  curl -L# $DL_URL > $LOCAL_COMPLETION_FOLDER/$BASH_FILENAME
}

gcompletion() {
	dl_completion https://raw.githubusercontent.com/git/git/master/contrib/completion/$GIT_COMPLETION_BASENAME.bash $GIT_COMPLETION_BASENAME.bash
}
