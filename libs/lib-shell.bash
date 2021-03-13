shell() {
  echo $SHELL
}
shellvi() {
  sudo vi /etc/shells
}
shellmv() {
  usage $# "SHELL:zsh|bash"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SHELL=$1
  echo "chsh -s \$(which $SHELL)"
  chsh -s $(which $SHELL)
}

hosts() {
  cat /etc/hosts
}
hostsvi() {
  sudo vi /etc/hosts
}
hostsappend() {
  usage $# "IP" "DNS"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local IP=$1
  local DNS=$2

  echo "sudo -- sh -c \"echo $IP $DNS >> /etc/hosts\""
  sudo -- sh -c "echo $IP $DNS >> /etc/hosts"
}
hostscn() {
  hostsappend 199.232.28.133 raw.githubusercontent.com
}