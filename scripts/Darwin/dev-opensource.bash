import lib-dev-maven-release

GPG_HOME=~/.gnupg

inst_gpg() {
  brew install gnupg2
  brew install gpg-agent
}

# More about signature & commands
# http://central.sonatype.org/pages/working-with-pgp-signatures.html
gpgcd() {
  if [ ! -f "$GPG_HOME/pubring.gpg" ]; then
  	echo "list-keys will initialize the Public key"
    gpgls
  fi  
  if [ ! -f "$GPG_HOME/secring.gpg" ]; then
  	echo "Attention no secret key use > gpgkeysgen"
  	return -1
  fi
  cd $GPG_HOME
}
gpgkeysls() {
	gpg2 --list-keys
}
gpgkeyspublic() {
	gpg --list-key | grep ^pub
}
gpgkeysgen() {
	gpg --gen-key
}

# gpgagentstart() {
# 	eval $(gpg-agent --daemon --no-grab --write-env-file $HOME/.gpg-agent-info)
# 	export GPG_TTY=$(tty)
# 	export GPG_AGENT_INFO	
# }
