if [[ -z "$INSTALL_TOOL" ]] ; then INSTALL_TOOL="apt -y" ; fi
if [[ -z "$UNINSTALL_TOOL" ]] ; then UNINSTALL_TOOL="apt purge" ; fi

if [[ -z "$CHECK_SUDO" ]] && [[ $(id -u) -ne 0 ]] ; then 
  export INSTALL_TOOL="sudo $INSTALL_TOOL"
  export UNINSTALL_TOOL="sudo $UNINSTALL_TOOL"
fi

inst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "$INSTALL_TOOL install $@"
  $INSTALL_TOOL install $@
}
uninst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "$UNINSTALL_TOOL $@"
  $UNINSTALL_TOOL $@

  $CLEANUP_TOOL
}
upd() {
  $INSTALL_TOOL update $@
}

inst_wget() {
  inst wget
}