# DISK and FOLDERS
disksize() {
  df -h
}

foldersize() {
  du -sh ./*
}
tree() {
  pwd
  find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}
mkcd() {
  mkdir $1 && cd $1
}

# FILES
cpsafe() {
  if [ -f "$2" ]; then
    echo "Copy and backup (+ $2.bak)"
    mv -f "$2" "$2.bak"
  else
    echo "Copy $BACKUP_MSG"
  fi
  cp "$1" "$2"
}
# recursive rm to all files that has this name
del() {
  find . -name $1 -exec rm {} \;
}

# TEXT
searchdir() {
  local SEARCH_PATH=${2:-.}

  if [ ! -d "$SEARCH_PATH" ]; then
    echo "ATTENTION : Parameter SEARCH_PATH=$SEARCH_PATH is NOT a DIRECTORY"
    return -1
  fi

  grep -r $1 $SEARCH_PATH
}

forline() {
  while IFS='' read -r line || [[ -n "$line" ]]; do
      echo "$line"
  done < "$1"
}

forlinegrep() {
  forline $1 | xargs -I {} grep --color "{}" $2
}

forlinetogrep() {
  fgrep -f $1 $2
}
