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
upg() {
  $INSTALL_TOOL upgrade $@
}
inst_dl_bin() {
  usage $# "EXEC_NAME" "EXEC_URL" "[BIN_PATH:/usr/local/bin/]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local EXEC_NAME=$1
  local EXEC_URL=$2
  local BIN_PATH=${3:-/usr/local/bin/}

  echo "curl -Lo ${EXEC_NAME} ${EXEC_URL}"
  curl -Lo ${EXEC_NAME} "${EXEC_URL}" && chmod +x ${EXEC_NAME} && bincp ${EXEC_NAME}
}
bincp() {
  usage $# "EXEC_FILE_NAME" "[EXEC_FINAL_NAME]" "[BIN_PATH:/usr/local/bin/]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local EXEC_FILE_NAME=$1
  local EXEC_FINAL_NAME=${2:-$1}
  local BIN_PATH=${3:-/usr/local/bin/}
  sudo cp ${EXEC_FILE_NAME} ${BIN_PATH}/${EXEC_FINAL_NAME}
}

inst_wget() {
  inst wget
}
inst_maven() {
  inst maven
}
