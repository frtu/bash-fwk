if [[ -z "$INSTALL_TOOL" ]] ; then local INSTALL_TOOL="apt" ; fi

if [[ $(id -u) -ne 0 ]] ; then alias apt='sudo apt' ; fi

inst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "$INSTALL_TOOL install $@"
  $INSTALL_TOOL install $@
}
inst_helm() {
  inst kubernetes-helm
}
