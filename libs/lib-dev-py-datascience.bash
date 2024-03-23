import lib-dev-py-conda

dsinstjupyter() {
  pcinst jupyter
}
dsinsttransformers() {
  pcinst transformers
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
