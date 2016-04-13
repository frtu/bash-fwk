# Command utils
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