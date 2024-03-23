import lib-dev-python
import lib-dev-py-conda

dstorch() {
  pyrun "import torch;" \
    "print('PyTorch version:', torch.__version__);" \
    "print('Is MPS available:', torch.backends.mps.is_available());" \
    "print('Is MPS activated in PyTorch:', torch.backends.mps.is_built());"
}
dsjupyter() {
  echo "jupyter lab"
  jupyter lab
}

dsinstds() {
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
