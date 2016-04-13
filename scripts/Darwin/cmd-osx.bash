alias showFiles='defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles FALSE;killall Finder'

dos2unix() {
	cat $1 | tr '\n' '\r'
}

dos2unixfile() {
	mv $1 "$1.bak"
	cat "$1.bak" | tr '\n' '\r' > $1
}
