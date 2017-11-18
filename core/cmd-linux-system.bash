USR_BIN=/usr/local/bin

export PATH=$PATH:\
$USR_BIN:\
$HOME/bin

# COMMANDS
cdbin(){
  cd $USR_BIN
}
binln() {
	if [ -z "$2" ] ; then
        echo "Please provide a folder='$1' and a command filename='$2'"
        return
  	fi
	ln -s "$1/$2" "$USR_BIN/$2"	
}

# NETWORK
portlist() {
  netstat -ntlp | grep LISTEN
}
