import lib-inst

export SS_CONFIG=/etc/shadowsocks.json

alias ssconfcat='cat $SS_CONFIG'

ssconf() {
  usage $# "PASSWORD" "[HOSTNAME]" "[PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PASSWORD=$1
  local HOSTNAME=${2:-10.140.0.2}
  local PORT=${3:-80}

  echo "{\"server\":\"${HOSTNAME}\",\"server_port\":${PORT},\"local_port\":0,\"password\":\"${PASSWORD}\",\"timeout\":600,\"method\":\"aes-256-cfb\"}" | sudo tee $SS_CONFIG > /dev/null
  ssconfcat
}
ssstart() {
  $SUDO_CONDITIONAL ssserver -c $SS_CONFIG -d start
}
ssstop() {
  $SUDO_CONDITIONAL ssserver -c $SS_CONFIG -d stop
}
