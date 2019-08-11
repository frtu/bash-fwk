import lib-ssocks

inst_pip() {
  sudo apt-get -y install python3-pip
}
inst_ssocks() {
  usage $# "PASSWORD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PASSWORD=$1
  local HOSTNAME=`hostname -I`

  inst_pip
  sudo pip3 install shadowsocks
  
  ssconf ${PASSWORD} ${HOSTNAME}

  STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
      echo "Installation Success!"
      echo "- sudo vi /usr/local/lib/python3.6/dist-packages/shadowsocks/crypto/openssl.py"
      echo "- Change all : EVP_CIPHER_CTX_cleanup => EVP_CIPHER_CTX_reset"
      echo ""
      echo "Launch and Stop application with :"
      echo "> ssstart"
      echo "> ssstop"
    else
      echo "== Install error, please read logs. ==" >&2
  fi
}
inst_youtube() {
  sudo apt-get -y install youtube-dl
}

inst_node() {
  sudo apt-get install curl
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

  sudo apt update
  sudo apt-get install nodejs

  enablelib dev-node
  njv
}
