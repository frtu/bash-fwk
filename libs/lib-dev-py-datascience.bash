import lib-dev-python
import lib-dev-py-conda

dstorch() {
  pypltfm
  pyrun "import torch;" \
    "print(f'PyTorch Version: {torch.__version__}');" \
    "print(f'Is CUDA available: {torch.cuda.is_available()}');" \
    "print(f'Is MPS available: {torch.backends.mps.is_available()}');" \
    "print(f'Is MPS activated in PyTorch: {torch.backends.mps.is_built()}');"
}
dsjupyter() {
  echo "jupyter lab"
  jupyter lab
}

dsinst() {
  dsinstpytorch
  dsinsttransformers
  dsinstjupyter
}
dsinstjupyter() {
  pcinst jupyter
}
dsinsttransformers() {
  pcinst transformers
  pcinst huggingface_hub
}
dsinstautogpt() {
  usage $# "[VERSION:0.4.2]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local VERSION=${1:-0.4.2}
  BUILD_CUDA_EXT=0 pip install "git+https://github.com/PanQiWei/AutoGPTQ.git@v${VERSION}"
}
# https://pytorch.org/get-started/locally/
dsinstpytorch() {
  dsinstrepopytorch pytorch::pytorch torchvision torchaudio
}

# Adding or Installing from repositories
dsinstrepopytorch() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "conda install -y -c pytorch $@"
  conda install -y -c pytorch $@
}
dsrepohuggingface() {
  pcrepo huggingface
}
