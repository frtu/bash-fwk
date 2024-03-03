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
  usage $# "[CMD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ -z "$1" ]]; then 
    echo "poetry --version"
    poetry --version

    echo "======================="
    poetry env info
  else
    echo "poetry $@"
    poetry $@
  fi
}
ptshow() {
  pt show $@
}
ptinfo() {
  usage $# "[CMD:--path]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=${@:---path}
  pt "env" "info" $CMD
}
ptupd() {
  usage $# "[VERSION:1.6.1]"
  pt "self" "update" $@
}

ptcreate() {
  usage $# "PROJECT_NAME:*_prj"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PROJECT_NAME="$1_prj"
  pt "new" ${PROJECT_NAME} ${@:2}

  cd ${PROJECT_NAME}
}
ptinit() {
  pt "init" $@
}
ptimport() {
  if [[ ! -f "${REQ_FILENAME}" ]]; then 
    echo "[WARN] Please sure file '${PWD}/${REQ_FILENAME}' exist !" >&2
    return 1
  fi

  echo "poetry add \$( cat requirements.txt )"
  poetry add $( cat requirements.txt )
}
ptinst() {
  pt "install" $@
}
ptbuild() {
  pt "build" $@
}
ptrun() {
  usage $# "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  pt "run" $@
}
ptstart() {
  ptrun "start" "$@"
}
ptlock() {
  ptrun "lock" "$@"
}

ptconf() {
  usage $# "[CONF_NAME]" "[CONF_VALUE]"

  local CMD=${@:---list}

  pt "config" ${CMD}
}
ptconfvirtualenv() {
  ptconf "virtualenvs.in-project" "true"
  ptconf
}
# https://python-poetry.org/docs/managing-environments/
# -> Use the shell version of python
ptconfvirtualenvactive() {
  ptconf "virtualenvs.prefer-active-python" "true"
  ptconf
}

ptenv() {
  usage $# "[ENV]"

  local ENV=$1
  if [ -n "$ENV" ]
    then
      pt "env" "use" ${ENV}
    else
      pt "env" "list"
  fi
}
ptenvinfo() {
  pt "env" "info" $@
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

  pt env remove $@
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
  usage $# "[FILE_PATH:--version]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local FILE_PATH=${1:---version}
  ptrun python ${FILE_PATH} ${@:2}
}
ptpymain() {
  ptpy main.py $@
}
ptshell() {
  pt "shell" $@
}

ptdep() {
  pt show --tree $@
}
ptadd() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  pt add $@
}
ptrm() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  pt remove $@
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
