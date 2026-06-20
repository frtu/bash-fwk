whp() {
  usage $# "VOICE_SOURCE_PATH" "TXT_TARGET_PATH" "[LANGUAGE:English]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local VOICE_SOURCE_PATH=$1
  local TXT_TARGET_PATH=$2
  local LANGUAGE=${3:-English}
  if [ -n "${LANGUAGE}" ]; then
    OPTIONAL_ARGS="--language ${LANGUAGE}"
  fi

  whisper "$VOICE_SOURCE_PATH" ${OPTIONAL_ARGS} > "$TXT_TARGET_PATH"
}
whpfr() {
  usage $# "VOICE_SOURCE_PATH" "TXT_TARGET_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local VOICE_SOURCE_PATH=$1
  local TXT_TARGET_PATH=$2

  whp "$VOICE_SOURCE_PATH" "$TXT_TARGET_PATH" "French"
}

inst_whisper() {
  echo "=Installing whisper="
  inst ffmpeg
  pip install -U openai-whisper
}