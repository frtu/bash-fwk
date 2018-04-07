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

# NETWORK
portlist() {
  netstat -ntlp | grep LISTEN
}

linuxdesc() {
  echo "====== Kernel version ======"
  uname -mrs
  echo "====== Linux Distro ======"
  cat /etc/*-release
  echo "====== Kernel & GCC build ======"
  cat /proc/version
}
