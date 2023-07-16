import lib-shell

alias showFiles='defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles FALSE;killall Finder'
alias setBash='sudo chsh -s /bin/bash'
alias vlc='/Application/VLC.app/Contents/MacOs/VLC'

tmpopen() {
	open $TMPDIR
}
tmpcd() {
	cd $TMPDIR
}

dos2unix() {
	cat $1 | tr '\n' '\r'
}
dos2unixfile() {
	mv $1 "$1.bak"
	cat "$1.bak" | tr '\n' '\r' > $1
}

foldersize() {
	du -h -d 1
}
tree() {
	pwd
	find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}
del() {
	find . -name $1 -exec rm {} \;
}

servicels() {
	launchctl list	
}
servicestart() {
	if [ $# -eq 0 ]; then
      echo "Add the service name to start !"
      return
  	fi
  	echo "launchctl start $1"
	launchctl start $1	
}
servicestop() {
	if [ $# -eq 0 ]; then
      echo "Add the service name to stop !"
      return
  	fi
  	echo "launchctl stop $1"
	launchctl stop $1	
}
