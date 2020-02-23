USR_BIN=/usr/local/bin

export PATH=$PATH:\
$USR_BIN:\
$HOME/bin

# COMMANDS
cdbin(){
  cd $USR_BIN
}
binln() {
  # MIN NUM OF ARG
  if [[ "$#" < "2" ]]; then
    echo "Please provide a folder='$1' and a command filename='$2'" >&2
    return -1
  fi
  ln -s "$1/$2" "$USR_BIN/$2"	
}
binappend() {
  usage $# "NEW_PATH_FOLDER"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local NEW_PATH_FOLDER=$1
  echo "export PATH=\$PATH:\"$NEW_PATH_FOLDER\"" >> ~/.bash_profile
  refresh
  echo $PATH
}

linuxdesc() {
  echo "====== Kernel version > uname -mrs ======"
  uname -mrs
  echo "====== Linux Distro > cat /etc/*-release ======"
  cat /etc/*-release
  echo "====== Kernel & GCC build > cat /proc/version ======"
  cat /proc/version
  echo "====== Others > ${SYS_INFO} ======"
  ${SYS_INFO}
}
suroot() {
  sudo -iu root
}

# NETWORK
portlist() {
  netstat -ntlp | grep LISTEN
}
lsip() {
  ip -4 addr  
}
tcp() {
  usage $# "ETHERNET_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    ifconfig
    return -1
  fi

  sudo tcpdump -i $@ -vvv
}
tcpport() {
  tcp "any dst port 20001 -A"
}

envls() {
  if [ -z "$1" ]
    then
      env
    else
      env | grep "$1"
  fi
}
envrm() {
  usage $# "ENV_NAME_TO_REMOVE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'envls KEYWORD' or 'envls'." >&2
    echo "" >&2
    envls
    return -1
  fi

  local ENV_NAME_TO_REMOVE=$1

  echo "unset $ENV_NAME_TO_REMOVE"
  unset $ENV_NAME_TO_REMOVE
}

