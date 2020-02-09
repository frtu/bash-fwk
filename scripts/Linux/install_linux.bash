import lib-inst
import lib-ssocks
import lib-k8s-minikube

inst_ssocks() {
  usage $# "PASSWORD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

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
      echo "Launch and Stop application with (on Centos, please >suroot before cmd):"
      echo "> ssstart"
      echo "> ssstop"
    else
      echo "== Install error, please read logs. ==" >&2
  fi
}
inst_node() {
  usage $# "VERSION:10/12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local VERSION=$1

  inst curl
  $NODE_CONFIG

  upd
  inst nodejs

  enablelib dev-node
  njversion
}
inst_node10() {
  inst_node 10
}
uninst_node() {
  uninst nodejs
}