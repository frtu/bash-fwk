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
  usage $# "[MODEL_NAME:opt]"

  local MODEL_NAME=${1:-opt}
  local ADDITIONAL_PARAMS=${@:2}

  echo "openllm start ${MODEL_NAME} ${ADDITIONAL_PARAMS}"
  openllm start ${MODEL_NAME} ${ADDITIONAL_PARAMS}
}
