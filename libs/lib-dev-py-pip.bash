import lib-dev-python

REQ_FILENAME=requirements.txt

ppls() {
  echo "pip list"
  pip list
}

ppdesc() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "pip show $@"
  pip show $@
}
ppinst() {
  usage $# "[PACKAGE]" "[VERSION]"

  local PACKAGE=$1
  local VERSION=$2

  if [ -n "$PACKAGE" ]
    then
      if [ -n "$VERSION" ]
        then
          local INST_ARG="${PACKAGE}==${VERSION}"
        else
          local INST_ARG="${PACKAGE}"
      fi
    else
      if [[ -f "${REQ_FILENAME}" ]] 
        then 
          local INST_ARG="-r ${REQ_FILENAME}"
        else
          echo "[WARN] Please pass an argument PACKAGE or create a local file : ${REQ_FILENAME}" >&2
          local INST_ARG="-e ."
      fi      
  fi
  
  echo "pip install ${INST_ARG}"
  pip install ${INST_ARG}
}
ppuninst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PACKAGE=$1

  echo "pip uninstall ${PACKAGE}"
  pip uninstall ${PACKAGE}
}
ppuninstnocache() {
  ppuninst --no-cache-dir $@
}

pprepoclean() {
  echo "pip cache purge"
  pip cache purge
}
ppinst_pyusb() {
  ppinst pyusb
}
ppinst_mtcnn() {
  ppinst mtcnn
}
ppinst_tensorflow() {
  ppuninstnocache --default-timeout=1000 tensorflow
}

pparchm1() {
  envcreate "ARCHFLAGS" "-arch arm64"
}
ppinst_pytorch_m1() {
  # From https://pytorch.org/
  echo "conda install pytorch torchvision torchaudio -c pytorch"
  conda install pytorch torchvision torchaudio -c pytorch
}
