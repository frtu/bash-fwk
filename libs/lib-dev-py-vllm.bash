import lib-dev-python

ppinst_vllm() {
  echo "pip install torch torchvision"
  pip install torch torchvision

  echo "pip install -U vllm --pre --extra-index-url https://wheels.vllm.ai/nightly"
  pip install -U vllm --pre --extra-index-url https://wheels.vllm.ai/nightly
}

pvllmrun() {
  usage $# "[MODEL:TinyLlama/TinyLlama-1.1B-Chat-v1.0]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local MODEL=${1:-TinyLlama/TinyLlama-1.1B-Chat-v1.0}
  
  echo "Run VLLM API server with model : ${MODEL}"
  VLLM_USE_CUDA=0 python -m vllm.entrypoints.api_server \
    --model "${MODEL}" \
    --tensor-parallel-size 1 \
    --host 0.0.0.0 \
    --port 8000 \
    --dtype float16
}