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
  usage $# "PROJECT_NAME"
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
  usage $# "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "poetry run $@"
  poetry run $@
}
ptstart() {
  ptrun "start" "$@"
}

ptconf() {
  usage $# "[CONF_NAME]" "[CONF_VALUE]"

  local CMD=${@:---list}

  echo "poetry config ${CMD}"
  poetry config ${CMD}
}
ptconfvirtualenv() {
  ptconf "virtualenvs.in-project" "true"
  ptconf
}
ptenv() {
  usage $# "[ENV]"

  local ENV=$1
  if [ -n "$ENV" ]
    then
      echo "poetry env use ${ENV}"
      poetry env use ${ENV}
    else
      echo "poetry env list"
      poetry env list
  fi
}
ptenvinfo() {
  echo "poetry env info $@"
  poetry env info $@
}
ptenvinfopath() {
  ptenvinfo "--path"
}
ptenvinfoexec() {
  ptenvinfo "--executable"
}
ptenvrm() {
  usage $# "ENV1" "[ENV..]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    ptenv
    return 1; 
  fi

  echo "poetry env remove $@"
  poetry env remove $@
}
ptenvrmall() {
  ptenvrm --all
}
ptenvactivate() {
  usage $# "[ENV]"

  local ENV=$1
  if [ -n "$ENV" ]; then
      echo ". $ENV/bin/activate"
      . $ENV/bin/activate
  elif [[ -d "$PWD/.venv" ]] ; then
      echo "Activating local env : [$PWD/.venv]" >&2
      ptenvactivate $PWD/.venv
  else
    ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
    echo "== Select the env from the list ==" >&2
    poetry env list --full-path
    return 1; 
  fi
}

ptpy() {
  ptrun python $@
}
ptshell() {
  echo "poetry shell $@"
  poetry shell $@
}

ptdep() {
  echo "poetry show --tree $@"
  poetry show --tree $@
}
ptadd() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "poetry add $@"
  poetry add $@
}
ptrm() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "poetry remove $@"
  poetry remove $@
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
ptdjango() {
  ptadd django
}
