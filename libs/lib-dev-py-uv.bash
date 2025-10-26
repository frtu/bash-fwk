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

# ENV
puenv() {
  usage $# "[ENV]"

  local ENV=$1
  if [ -n "$ENV" ]
    then
      pu venv ${ENV} ${@:2}
    else
      pu venv
  fi
}
puyversion() {
  usage $# "VERSION"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=$1
  puenv --python ${VERSION}
}
alias pui=pucreate
pucreate() {
  usage $# "[PROJECT_NAME:*_prj]" "[TYPE:--lib]" "[SUB:--no-workspace]"
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

# PYTHON
# https://docs.astral.sh/uv/guides/install-python/
# https://docs.astral.sh/uv/concepts/python-versions/#viewing-available-python-versions
puyls() {
  pu "python" "list" $@
}
puyinst() {
  usage $# "[VERSION:latest]"
  pu "python" "install" $@
}
puyuninst() {
  pu "python" "uninstall" $@
}

# DEP
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

# https://docs.astral.sh/uv/concepts/projects/dependencies/#adding-dependencies
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

# TOOLS
alias putls="put list"
put() {
  usage $# "[CMD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OpuIONAL.
  if [[ -z "$1" ]]; then 
    echo "= UV TOOL Folder ="
    put dir
  else
    pu tool $@
  fi  
}
putinst() {
  usage $# "PACKAGE"
  put install $@
}
putupg() {
  usage $# "PACKAGE"
  put upgrade $@
}
putuninst() {
  usage $# "PACKAGE"
  put uninstall $@
}

# CMD
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
puaddfastapi() {
  puadd fastapi
}
puaddtest() {
  puadd pytest --dev
}

puaddmcp() {
  puadd "mcp[cli]"

  echo "true" > ${MCP_TOGGLE}
}
