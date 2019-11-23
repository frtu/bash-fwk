if [[ -z "$INSTALL_TOOL" ]] ; then INSTALL_TOOL="apt -y" ; fi

if [[ -z "$CHECK_SUDO" && $(id -u) -ne 0 ]] ; then INSTALL_TOOL="sudo $INSTALL_TOOL" ; fi

inst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "$INSTALL_TOOL install $@"
  $INSTALL_TOOL install $@
}
