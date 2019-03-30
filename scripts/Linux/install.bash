import lib-ssocks

inst_pip() {
  sudo apt-get -y install python3-pip
}
inst_ss() {
  usage $# "PASSWORD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PASSWORD=$1
  local HOSTNAME=`hostname -I`

  inst_pip
  sudo pip3 install shadowsocks
  
  ssconf ${PASSWORD} ${HOSTNAME}
}
