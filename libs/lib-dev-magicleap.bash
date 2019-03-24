export ML_VERSION=v0.19.0
export ML_HOME=${HOME}/MagicLeap/mlsdk/${ML_VERSION}

export ML_TOOLS=${ML_HOME}/tools
export MLDB_PATH=${ML_TOOLS}/mldb

export PATH=${ML_HOME}:${MLDB_PATH}:$PATH

alias mlcd="cd ${ML_VERSION}"
alias mlversion="mldb version"

alias mldevices="mldb devices"
alias mlls="mldb packages"

alias mlps="mldb ps"
alias mltop="mldb top"
alias mlifconfig="mldb ifconfig"
alias mlbattery="mldb battery"

alias mllock="mldb lock"
alias mlunlock="mldb unlock"
alias mlreboot="mldb reboot"
alias mlshutdown="mldb shutdown"

alias mllog="mldb log"

mlbuilddebug() {
  usage $# "PACKAGE_PATH" "[EXTRA_ARGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PACKAGE_PATH=$1
  local EXTRA_ARGS=${@:2}

  echo "mldb uninstall ${EXTRA_ARGS} ${PACKAGE_NAME}"
  mldb uninstall ${EXTRA_ARGS} ${PACKAGE_NAME}
}

mlinstall() {
  usage $# "MPK_FILE" "[EXTRA_ARGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  echo "== At the end append -r for forcing install =="

  local MPK_FILE=$1
  local EXTRA_ARGS=${@:2}

  echo "mldb install -u ${EXTRA_ARGS} ${MPK_FILE}"
  mldb install -u ${EXTRA_ARGS} ${MPK_FILE}
}
mluninstall() {
  usage $# "PACKAGE_NAME" "[EXTRA_ARGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any PACKAGE_NAME run 'mlls'" >&2
    mlls
    return -1
  fi

  local PACKAGE_NAME=$1
  local EXTRA_ARGS=${@:2}

  echo "mldb uninstall ${EXTRA_ARGS} ${PACKAGE_NAME}"
  mldb uninstall ${EXTRA_ARGS} ${PACKAGE_NAME}
}
mlkill() {
  usage $# "PACKAGE_NAME" "[EXTRA_ARGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any PACKAGE_NAME run 'mlls'" >&2
    mlls
    return -1
  fi

  local PACKAGE_NAME=$1
  local EXTRA_ARGS=${@:2}

  echo "mldb terminate -f ${EXTRA_ARGS} ${PACKAGE_NAME}"
  mldb terminate -f ${EXTRA_ARGS} ${PACKAGE_NAME}
}

mlport() {
  echo "== list the forward socket connections =="
  mldb forward --list
  echo "== list all reverse socket connections from device =="
  mldb reverse --list
}
