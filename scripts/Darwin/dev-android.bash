export ANDROID_HOME=${HOME}/Library/Android/sdk/
export ANDROID_PLF_TOOLS=${ANDROID_HOME}/platform-tools
export ANDROID_TOOLS=${ANDROID_HOME}/tools

export ANDROID_M2REPO=${ANDROID_HOME}/extras/android/m2repository/
export ANDROID_USB_CONFIG=${HOME}/.android/adb_usb.ini

export PATH=${ANDROID_PLF_TOOLS}:${ANDROID_TOOLS}:$PATH


alias droidcd="cd ${ANDROID_HOME}"
alias droidcdm2repo="cd ${ANDROID_M2REPO}"

droidinstall() {
  mkdir -p ${ANDROID_HOME}
}

adbls() {
  adb devices
}
adbaddvendor() {
  usage $# "VENDOR_ID"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local VENDOR_ID=$1

  echo "== Setting VENDOR_ID : ${VENDOR_ID} into $ANDROID_USB_CONFIG =="
  echo "${VENDOR_ID}"   >> $ANDROID_USB_CONFIG
  
  cat $ANDROID_USB_CONFIG
}

adbinstall() {
  usage $# "APK_FILE" "[EXTRA_ARGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  echo "== At the end append -r for forcing install =="

  local APK_FILE=$1
  local EXTRA_ARGS=${@:2}

  echo "adb install ${EXTRA_ARGS} ${APK_FILE}"
  adb install ${EXTRA_ARGS} ${APK_FILE}
}
