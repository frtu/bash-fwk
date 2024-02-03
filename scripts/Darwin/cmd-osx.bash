import lib-shell

alias showFiles='defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles FALSE;killall Finder'
alias setBash='sudo chsh -s /bin/bash'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

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
  usage $# "SERVICE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
	
  echo "launchctl start $1"
  launchctl start $1	
}
servicestop() {
  usage $# "SERVICE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
	
  echo "launchctl stop $1"
  launchctl stop $1	
}
serviceenv() {
  usage $# "ENV_NAME" "[ENV_VALUE]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ENV_NAME=$1
  local ENV_VALUE=$2

  if [ -n "$ENV_NAME" ] ; then
	if [ -n "$ENV_VALUE" ]
		then
			echo "launchctl setenv $ENV_NAME \"$ENV_VALUE\""
			launchctl setenv $ENV_NAME "$ENV_VALUE"
		else
			echo "launchctl getenv $ENV_NAME"
			launchctl getenv $ENV_NAME
	fi
  fi
}
serviceenvrm() {
  usage $# "ENV_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ENV_NAME=$1

  echo "launchctl unsetenv $ENV_NAME"
  launchctl unsetenv $ENV_NAME
}
