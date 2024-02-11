import lib-dev-python

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
ppupg() {
  echo "pip install --upgrade pip"
  pip install --upgrade pip
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
ppinstpkg() {
  usage $# "PACKAGE" "[URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PACKAGE=$1
  local URL=$2
  
  if [ -n "$URL" ]
    then
      local INST_ARG="${PACKAGE} --index-url ${URL}"
    else
      local INST_ARG="${PACKAGE}"
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

ppconfedit() {
  code ~/.config/pip/pip.conf
}
ppconf() {
  local CONF_PARAM=${1:-list}
  echo "pip config $CONF_PARAM"
  pip config $CONF_PARAM
}
ppconfset() {
  usage $# "CONF_PARAM_NAME" "CONF_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CONF_PARAM_NAME=$1
  local CONF_PARAM_VALUE=$2

  echo "pip config set $CONF_PARAM_NAME \"$CONF_PARAM_VALUE\""
  pip config set $CONF_PARAM_NAME "$CONF_PARAM_VALUE"
}
alias ppconfrm=ppconfunset
ppconfunset() {
  usage $# "CONF_PARAM_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CONF_PARAM_NAME=$1
  
  echo "pip config unset $CONF_PARAM_NAME"
  pip config unset $CONF_PARAM_NAME
}
# https://mirrors.sustech.edu.cn/help/pypi.html#_2-configure-index-url
ppconfrepo() {
  usage $# "URL_MIRROR"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  ppconfset global.index-url "$1"
}
ppconfreporm() {
  ppconfunset global.index-url 
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
ppinst_ollama() {
  ppinst ollama
}
ppinst_openllm() {
  usage $# "[MODEL_NAME:falcon at https://github.com/bentoml/OpenLLM#-supported-models]"

  local MODEL_NAME=$1
  if [ -n "$MODEL_NAME" ]; 
    then
      local EXTRA_PARAMS="[$MODEL_NAME]"
    else
      echo "Install and search for MODEL_NAME at https://github.com/bentoml/OpenLLM#-supported-models"
  fi

  enablelib ai-openllm
  pcenv openllm
  ppinst openllm${EXTRA_PARAMS}
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

  # python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
}
