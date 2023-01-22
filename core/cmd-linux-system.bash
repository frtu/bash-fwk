USR_BIN=/usr/local/bin

export PATH=$PATH:\
$USR_BIN:\
$HOME/bin

# COMMANDS
cdbin(){
  cd $USR_BIN
}
binln() {
  usage $# "LOCAL_FOLDER" "CMD_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  ln -s "$1/$2" "$USR_BIN/$2"	
}
binmv() {
  usage $# "FILE_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  sudo mv $1 $USR_BIN
}
binappend() {
  usage $# "NEW_PATH_FOLDER"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local NEW_PATH_FOLDER=$1
  echo "export PATH=\"$NEW_PATH_FOLDER\":\$PATH" >> ~/.bash_profile
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

# PROCESS
psowner() {
  usage $# "PID"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodls'" >&2
    ps -edf
    return 1
  fi

  local PID=$1

  ps -o user= ${PID}
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
    return 1
  fi

  echo "sudo tcpdump -i $@ -vvv"
  sudo tcpdump -i $@ -vvv
}
tcpport() {
  usage $# "PORT"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PORT=$1
  tcp "any dst port ${PORT} -A"
}
# http://lartc.org/howto/lartc.iproute2.arp.html
iproute() {
  echo "ip route show"
  ip route show
}
ipneigh() {
  echo "ip neigh show"
  ip neigh show
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
    return 1
  fi

  local ENV_NAME_TO_REMOVE=$1

  echo "unset $ENV_NAME_TO_REMOVE"
  unset $ENV_NAME_TO_REMOVE
}

