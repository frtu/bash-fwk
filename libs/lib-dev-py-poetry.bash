# https://python-poetry.org/docs/#installation
inst_poetry() {
  echo "curl -sSL https://install.python-poetry.org | python3 -"
  curl -sSL https://install.python-poetry.org | python3 -

  binappend ~/.local/bin/
}
uninst_poetry() {
  echo "curl -sSL https://install.python-poetry.org | python3 - --uninstall"
  curl -sSL https://install.python-poetry.org | python3 - --uninstall
}

pt() {
  echo "poetry --version"
  poetry --version

  echo "======================="
  poetry env info
}
ptinfo() {
  usage $# "[CMD:--path]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=${@:---path}

  echo "poetry env info $CMD"
  poetry env info $CMD
}
ptupd() {
  usage $# "[VERSION:1.6.1]"

  echo "poetry self update $@"
  poetry self update $@
}

ptcreate() {
  usage $# "[PROJECT_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PROJECT_NAME=$1

  echo "poetry new ${PROJECT_NAME}"
  poetry new ${PROJECT_NAME}

  cd ${PROJECT_NAME}
}
ptinit() {
  echo "poetry init $@"
  poetry init $@
}
ptinst() {
  echo "poetry install"
  poetry install
}
ptbuild() {
  echo "poetry build $@"
  poetry build $@
}
ptrun() {
  echo "poetry run $@"
  poetry run $@
}
ptstart() {
  ptrun "start" "$@"
}

ptconf() {
  echo "poetry config --list "
  poetry config --list 
}
ptadd() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "poetry add $@"
  poetry add $@
}

ptaddpg() {
  ptadd psycopg2-binary
}
ptaddarg() {
  ptadd argparse
}
ptadddotenv() {
  ptadd python-dotenv
}
ptpylenium() {
  ptadd pylenium
}

