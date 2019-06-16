# https://creator.magicleap.com/learn/guides/magic-leap-builder-overview
export MLSDK_INSTALL_PATH=${HOME}/MagicLeap/mlsdk/${ML_VERSION}

export ML_TOOLS=${MLSDK_INSTALL_PATH}/tools
export MLDB_PATH=${ML_TOOLS}/mldb

export PATH=${MLSDK_INSTALL_PATH}:${MLDB_PATH}:$PATH

# https://creator.magicleap.com/learn/guides/magic-leap-device-bridge-overview
alias mlcd="cd ${ML_VERSION}"
alias mlversion="mldb version"

alias mldevices="mldb devices"
alias mlls="mldb packages"
alias mlwifi="mldb wifi status"
# https://creator.magicleap.com/learn/guides/develop-device-setup#connect-with-mldb-wifi

alias mlps="mldb ps"
alias mltop="mldb top"
alias mlifconfig="mldb ifconfig"
alias mlbattery="mldb battery"

alias mllock="mldb lock"
alias mlunlock="mldb unlock"
alias mlreboot="mldb reboot"
alias mlshutdown="mldb shutdown"

alias mllog="mldb log"

mlinstall() {
  usage $# "MPK_FILE" "[DEVICE_ID]" "[EXTRA_ARGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  echo "== Can specify DEVICE_ID by running 'mldevices' =="

  local MPK_FILE=$1
  local DEVICE_ID=$2
  local EXTRA_ARGS=${@:3}

  if [ -n "${DEVICE_ID}" ]; then
    EXTRA_ARGS=-s ${DEVICE_ID} ${EXTRA_ARGS}
  fi

  echo "mldb ${EXTRA_ARGS} install -u ${MPK_FILE}"
  mldb ${EXTRA_ARGS} install -u ${MPK_FILE}
}
mluninstall() {
  usage $# "PACKAGE_NAME" "[DEVICE_ID]" "[EXTRA_ARGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any PACKAGE_NAME run 'mlls'" >&2
    mlls
    return -1
  fi

  local PACKAGE_NAME=$1
  local DEVICE_ID=$2
  local EXTRA_ARGS=${@:3}

  if [ -n "${DEVICE_ID}" ]; then
    EXTRA_ARGS=-s ${DEVICE_ID} ${EXTRA_ARGS}
  fi

  echo "mldb ${EXTRA_ARGS} uninstall ${PACKAGE_NAME}"
  mldb ${EXTRA_ARGS} uninstall ${PACKAGE_NAME}
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

mlportls() {
  echo "== list the forward socket connections =="
  mldb forward --list
  echo "== list all reverse socket connections from device =="
  mldb reverse --list
}
mlportadd() {
  usage $# "PORT"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PORT=$1

  echo "mldb tcpip -p ${PORT}"
  mldb tcpip -p ${PORT}
}

mlconnect() {
  usage $# "IP" "PORT"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know IP run 'mlwifi'" >&2
    mlwifi
    echo "If you need to add a new PORT run 'mlportadd'" >&2
    return -1
  fi

  local IP=$1
  local PORT=$2

  echo "mldb connect ${IP}:${PORT}"
  mldb connect ${IP}:${PORT}
}

# https://creator.magicleap.com/learn/guides/magic-leap-builder-overview
mbcertpersist() {
  usage $# "CERT_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CERT_PATH=$1
  if [ ! -f "$CERT_PATH" ]; then
    CERT_PATH=${PWD}/$1
  fi
  if [ ! -f "$CERT_PATH" ]; then
    echo "Certificate file doesn't exist : $1!" >&2
    return -1
  fi

  local TARGET_SERVICE_FILENAME=${SERVICE_LOCAL_BASH_PREFIX}dev-magicleap.bash
  echo "Patching file ${TARGET_SERVICE_FILENAME} with MLCERT=${CERT_PATH}"
  echo "export MLCERT=${CERT_PATH}" >> $TARGET_SERVICE_FILENAME
}

#https://creator.magicleap.com/learn/tutorials/capture-service
mlvideo() {
  usage $# "DEST_FILE" "[RESOLUTION:1080p|720p]" "[EXTRA_ARGS:-f 600|-t 10|-w]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DEST_FILE=$1
  local RESOLUTION=$2
  local EXTRA_ARGS=${@:3}

  if [ -n "${RESOLUTION}" ]; then
    EXTRA_ARGS=-q ${RESOLUTION} ${EXTRA_ARGS}
  fi

  echo "mldb capture video ${EXTRA_ARGS} ${DEST_FILE}"
  mldb capture video ${EXTRA_ARGS} ${DEST_FILE} 
}
mlimage() {
  usage $# "DEST_FILE" "[RESOLUTION:1080p|720p]" "[EXTRA_ARGS:-r]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DEST_FILE=$1
  local RESOLUTION=$2
  EXTRA_ARGS=${@:3}

  if [ -n "${RESOLUTION}" ]; then
    EXTRA_ARGS=-q ${RESOLUTION} ${EXTRA_ARGS}
  fi

  echo "mldb capture image ${EXTRA_ARGS} ${DEST_FILE}"
  mldb capture image ${EXTRA_ARGS} ${DEST_FILE} 
}
mlvideopull() {
  mldb pull -D /C1/videos
}
mlimagepull() {
  mldb pull -D /C1/photos
}

# https://creator.magicleap.com/learn/guides/magic-leap-builder-user-guide
mbdevice() {
  usage $# "PACKAGE_FILE" "[TARGET:device|release_device|debug_device]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PACKAGE_FILE=$1
  local TARGET=${2:-device}

  mbbuild ${PACKAGE_FILE} ${TARGET}
}
mbhost() {
  usage $# "PACKAGE_FILE" "[TARGET:host|release_host|debug_host]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PACKAGE_FILE=$1
  local TARGET=${2:-host}

  mbbuild ${PACKAGE_FILE} ${TARGET}
}

mbbuild() {
  usage $# "PACKAGE_FILE" "TARGET"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PACKAGE_FILE=$1
  local TARGET=$2

  if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Package file doesn't exist : $1!" >&2
    return -1
  fi

  echo "mabu --print-target -t ${TARGET}"
  mabu --print-target -t ${TARGET}

  echo "mabu -s ${MLCERT} -t ${TARGET} ${PACKAGE_FILE}"
  mabu -s ${MLCERT} -t ${TARGET} ${PACKAGE_FILE}
}