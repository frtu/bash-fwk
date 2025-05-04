import lib-dev-python

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
puupd() {
  pu "self" "update" $@
}

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
  usage $# "PROJECT_NAME:*_prj"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PROJECT_NAME="$1_prj"
  pu "init" ${PROJECT_NAME} ${@:2}

  cd ${PROJECT_NAME}
}
puadd() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  pu add $@
}
purm() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  uv remove $@
}

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
puaddmcp() {
  puadd "mcp[cli]" notion-client
}
