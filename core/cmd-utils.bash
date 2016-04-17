# Command utils
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

mkcd() {
  mkdir $1 && cd $1
}

disksize() {
  df -h
}

tree() {
	pwd
	find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

# recursive rm to all files that has this name
del() {
	find . -name $1 -exec rm {} \;
}