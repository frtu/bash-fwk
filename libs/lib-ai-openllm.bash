# https://github.com/bentoml/OpenLLM
ol() {
  echo "openllm -h"
  openllm -h
}
olenable() {
  echo "pcenv openllm"
  pcenv openllm
}

olstart() {
  usage $# "MODEL_NAME"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "Install and search for MODEL_NAME at https://github.com/bentoml/OpenLLM#-supported-models" >&2
    return 1
  fi

  local MODEL_NAME=${1:-opt}
  local ADDITIONAL_PARAMS=${@:2}

  echo "openllm start ${MODEL_NAME} ${ADDITIONAL_PARAMS}"
  openllm start ${MODEL_NAME} ${ADDITIONAL_PARAMS}
}
