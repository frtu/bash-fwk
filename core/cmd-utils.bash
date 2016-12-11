# Command utils
mkcd() {
  mkdir $1 && cd $1
}
tree() {
  pwd
  find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}
# recursive rm to all files that has this name
del() {
  find . -name $1 -exec rm {} \;
}

cpsafe() {
  if [ -f "$2" ]
  then
	echo "Copy and backup (+ $2.bak)"
	mv -f "$2" "$2.bak"
  else
  	echo "Copy $BACKUP_MSG"
  fi
  cp "$1" "$2"
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
