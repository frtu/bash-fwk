import lib-dev-python

export MCP_TOGGLE=mcp.txt

# https://docs.astral.sh/uv/getting-started/features/
# https://astral.sh/blog/uv
inst_uv() {
  echo "curl -LsSf https://astral.sh/uv/install.sh | sh"
  curl -LsSf https://astral.sh/uv/install.sh | sh
}
uninst_uv() {
  uv cache clean
  rm -r "$(uv python dir)"
  rm -r "$(uv tool dir)"
  rm ~/.local/bin/uv ~/.local/bin/uvx
}

pu() {
  usage $# "[CMD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OpuIONAL.
  if [[ -z "$1" ]]; then 
    echo "uv --version"
    uv --version
  else
    echo "uv $@"
    uv $@
  fi
}
puupg() {
  pu "self" "update" $@
}

# https://docs.astral.sh/uv/guides/install-python/
puls() {
  pu "python" "list" $@
}
puinst() {
  usage $# "[VERSION:latest]"
  pu "python" "install" $@
}
puuninst() {
  pu "python" "uninstall" $@
}

puenv() {
  usage $# "[ENV]"

  local ENV=$1
  if [ -n "$ENV" ]
    then
      pu venv ${ENV}
    else
      pu venv
  fi
}

pucreate() {
  usage $# "[PROJECT_NAME:*_prj]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  if [[ -n "$1" ]]; then
    local PROJECT_NAME="$1_prj"
  fi
  pu "init" ${PROJECT_NAME} ${@:2}

  if [[ -n "${PROJECT_NAME}" ]]; then
    cd ${PROJECT_NAME}
  fi
}

alias puimport=pudepimport
alias puadd=pudepadd
alias purm=pudeprm
pudepimport() {
  if [[ ! -f "${REQ_FILENAME}" ]]; then 
    echo "[WARN] Please sure file '${PWD}/${REQ_FILENAME}' exist !" >&2
    return 1
  fi

  pu "pip install -r requirements.txt"
}

pudepadd() {
  usage $# "[PACKAGE]"

  local PACKAGE=$1
  if [ -n "$PACKAGE" ]
    then
      local INST_ARG="${PACKAGE}"
    else
      if [[ -f "${REQ_FILENAME}" ]] 
        then 
          local INST_ARG="-r ${REQ_FILENAME}"
        else
          echo "[WARN] Please pass an argument PACKAGE or create a local file : ${REQ_FILENAME}" >&2
          return 1
      fi      
  fi

  echo "pu add ${INST_ARG}"
  pu add ${INST_ARG}
}
pudeprm() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  pu remove $@
}
pudepupg() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PACKAGE=$1
  puadd --dev ${PACKAGE} --upgrade-package ${PACKAGE} ${@:2}
}

pulint() {
  pucheck --fix
}
puformat() {
  purufftpl format $@
}
pucheck() {
  purufftpl check $@
}
purufftpl() {
  usage $# "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  purunfrozen ruff ${CMD} . ${@:2}
}
putypecheck() {
  purunfrozen pyright $@
}
putest() {
  purunfrozen pytest $@
}

purunfrozen() {
  usage $# "MODULE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local MODULE=$1
  pu "run --frozen" ${MODULE} ${@:2}
}
purun() {
  usage $# "[MODULE]"

  local MODULE=$1
  pu "run" ${MODULE} ${@:2}
}

alias pumcp=puaddmcp
puaddbase() {
  puadddotenv
  puaddrequests
}
puadddotenv() {
  puadd python-dotenv
}
puaddrequests() {
  puadd requests
}
puaddtest() {
  puadd pytest --dev
}

puaddmcp() {
  puadd "mcp[cli]"

  echo "true" > ${MCP_TOGGLE}
}
