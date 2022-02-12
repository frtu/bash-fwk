if [[ -z "$CHECK_SUDO" ]] && [[ $(id -u) -ne 0 ]] ; then 
  alias systemctl="sudo systemctl"
fi

srvlogs() {
  journalctl -xe
}

srvactivate() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  systemctl enable $@
}
srvstatus() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  systemctl status $@
}
srvstart() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  systemctl start $@
  srvstatus $@
}
srvstop() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  systemctl stop $@
  srvstatus $@
}
srvrestart() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  systemctl restart $@
  srvstatus $@
}
