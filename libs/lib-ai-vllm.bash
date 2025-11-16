#!/bin/sh
import lib-dev-py-uv

# https://www.byteplus.com/en/topic/409013?title=where-does-vllm-store-models
export VLLM_CACHE_ROOT=~/.cache/huggingface/hub
# export HF_HUB_CACHE=

# Model
alias avmcd='cd ${VLLM_CACHE_ROOT}'
avmls() {
  ls -l ${VLLM_CACHE_ROOT}
  echo "ATTENTION : MODEL_NAME is 'models--[MODEL_NAME]' replace '--' with '/'"
}
avmrm() {
  usage $# "MODEL_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Need to pass the MODEL_NAME" >&2
    avmls
    return 1
  fi

  local MODEL_NAME=$1
  rm -Rf ${VLLM_CACHE_ROOT}/${MODEL_NAME}
}

# https://docs.vllm.ai/en/stable/getting_started/quickstart.html#prerequisites
avcreate() {
  usage $# "[PYTHON_VERSION:3.12]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local PYTHON_VERSION=${1:-3.12}
  puyversion "${PYTHON_VERSION}" "--seed"
  puinst vllm --torch-backend=auto
}
avrun() {
  usage $# "[MODEL_NAME:TinyLlama/TinyLlama-1.1B-Chat-v1.0]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local MODEL_NAME=${1:-TinyLlama/TinyLlama-1.1B-Chat-v1.0}

  echo "== Run VLLM API server with model : ${MODEL_NAME} =="
  vllm serve ${MODEL_NAME}
  # VLLM_USE_CUDA=0 python -m vllm.entrypoints.api_server \
  #   --model "${MODEL_NAME}" \
  #   --tensor-parallel-size 1 \
  #   --host 0.0.0.0 \
  #   --port 8000 \
  #   --dtype float16
}

# External install
ppinst_vllm() {
  echo "pip install torch torchvision"
  pip install torch torchvision

  echo "pip install -U vllm --pre --extra-index-url https://wheels.vllm.ai/nightly"
  pip install -U vllm --pre --extra-index-url https://wheels.vllm.ai/nightly
}