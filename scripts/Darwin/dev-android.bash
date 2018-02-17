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
  EXPECTED_ARGS=( "VENDOR_ID" )
  #  OPTIONAL_ARGS=( "[OPTIONAL_ARG]" )

  # ARG CHECK ONE LINER
  if [[ "$#" < "${#EXPECTED_ARGS[*]}" ]]; then echo "Usage : ${FUNCNAME[0]} ${EXPECTED_ARGS[@]} ${OPTIONAL_ARGS[@]}" >&2 ; return -1 ; fi

  local VENDOR_ID=$1

  echo "== Setting VENDOR_ID : ${VENDOR_ID} into $ANDROID_USB_CONFIG =="
  echo "${VENDOR_ID}"   >> $ANDROID_USB_CONFIG
  
  cat $ANDROID_USB_CONFIG
}

adbinstall() {
  EXPECTED_ARGS=( "APK_FILE" )
  # ARG CHECK ONE LINER
  if [[ "$#" < "${#EXPECTED_ARGS[*]}" ]]; then echo "Usage : ${FUNCNAME[0]} ${EXPECTED_ARGS[@]} ${OPTIONAL_ARGS[@]}" >&2 ; return -1 ; fi

  local APK_FILE=$1

  echo "adb install ${APK_FILE}"
  adb install ${APK_FILE}
}