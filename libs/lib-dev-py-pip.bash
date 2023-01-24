import lib-dev-python

REQ_FILENAME=requirements.txt

ppls() {
  echo "pip list"
  pip list
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
          echo "[ERROR] Please pass an argument PACKAGE or create a local file : ${REQ_FILENAME}" >&2
          return 1
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
ppinst_mtcnn() {
  ppinst mtcnn
}
ppinst_tensorflow() {
  ppuninstnocache --default-timeout=1000 tensorflow
}

pparchm1() {
  envcreate "ARCHFLAGS" "-arch arm64"
}

