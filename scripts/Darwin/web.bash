#!/bin/bash
sockspersist() {
  usage $# "SOCKS_PORT" "SSH_HOSTNAME:w.x.y.z" "[USERNAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SOCKS_PORT=$1
  local SSH_HOSTNAME=$2
  local USERNAME=$3

  local TARGET_SERVICE_FILENAME=${SERVICE_LOCAL_BASH_PREFIX}chrome.bash
  echo "Creating startup file ${TARGET_SERVICE_FILENAME}"

  echo "#!/bin/bash" > $TARGET_SERVICE_FILENAME
  echo "export SAVED_SOCKS_PORT=${SOCKS_PORT}" >> $TARGET_SERVICE_FILENAME
  echo "export SAVED_SSH_HOSTNAME=${SSH_HOSTNAME}" >> $TARGET_SERVICE_FILENAME
  echo "export SAVED_USERNAME=${USERNAME}" >> $TARGET_SERVICE_FILENAME
  echo "alias saved_socks='sshsocks ${SOCKS_PORT} ${SSH_HOSTNAME} ${USERNAME}'" >> $TARGET_SERVICE_FILENAME
  echo "alias saved_sockschrome='sockschrome ${SOCKS_PORT} ${SSH_HOSTNAME} ${USERNAME}'" >> $TARGET_SERVICE_FILENAME
}

sockschrome() {
  usage $# "SOCKS_PORT" "SSH_HOSTNAME:w.x.y.z" "[USERNAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SOCKS_PORT=$1
  local SSH_HOSTNAME=$2
  local USERNAME=$3

  sshsocks ${SOCKS_PORT} ${SSH_HOSTNAME} ${USERNAME}
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  	 --user-data-dir="$HOME/proxy-profile" --proxy-server="socks5://localhost:${SOCKS_PORT}"
}

socksfirefox() {
  usage $# "SOCKS_PORT" "SSH_HOSTNAME:w.x.y.z" "[USERNAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SOCKS_PORT=$1
  local SSH_HOSTNAME=$2
  local USERNAME=$3

  sshsocks ${SOCKS_PORT} ${SSH_HOSTNAME} ${USERNAME}
  # LINUX : /usr/bin/firefox
  "/Applications/Firefox.app/Contents/MacOS/firefox"
}