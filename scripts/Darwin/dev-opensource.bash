MVN_RELEASE_REPO=target/checkout

inst_gpg() {
  brew install gnupg2
  brew install gpg-agent
}

# More about signature & commands
# http://central.sonatype.org/pages/working-with-pgp-signatures.html
gpgls() {
	gpg2 --list-keys	
}
gpgkeypublic() {
	gpg --list-key | grep ^pub
}

gpgagentstart() {
	eval $(gpg-agent --daemon --no-grab --write-env-file $HOME/.gpg-agent-info)
	export GPG_TTY=$(tty)
	export GPG_AGENT_INFO	
}

mvnreleasetag() {
	mvn release:prepare 
}
mvnreleasedeploy() {
	mvn clean package verify gpg:sign release:prepare release:perform 
}

mvnreleasecd() {
	cd $MVN_RELEASE_REPO
}
