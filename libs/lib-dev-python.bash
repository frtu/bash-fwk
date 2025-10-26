#!/bin/sh
export REQ_FILENAME=requirements.txt
export PYENV_VERSIONS_PATH=~/.pyenv/versions/
export PYTHON_SCRIPT_LOCAL=$LOCAL_SCRIPTS_FOLDER/help-python.bash

# https://stackoverflow.com/questions/122327/how-do-i-find-the-location-of-my-python-site-packages-directory
py() {
  python --version
  echo "================="
  which python
  echo "================="
  python -m site
  echo "================="
  pypltfm
}
pypltfm() {
  pyrun "import sys; import platform; import torch;" \
    "print(f'Python {sys.version}');" \
    "print(f'Python Platform: {platform.platform()}');"
}
pyrunv() {
  usage $# "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "> $@"
  pyrun $@
}
pyrun() {
  usage $# "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo $@ | python
}
pyalias3() {
  scriptappendverbose "${PYTHON_SCRIPT_LOCAL}" "alias python=python3"
  scriptappendverbose "${PYTHON_SCRIPT_LOCAL}" "alias pip=pip3"
}

penv() {
  usage $# "[ENV:.venv]"

  local ENV=${1:-.venv}
  echo "python3 -m venv ${ENV}"
  python3 -m venv ${ENV}
  penvactivate ${ENV} ${@:2}
}
penvactivate() {
  usage $# "[ENV:.venv]"

  local ENV=${1:-.venv}
  echo "source ${ENV}/bin/activate"
  source ${ENV}/bin/activate
}
penvdeactivate() {
  echo "deactivate"
  deactivate
}

pyv() {
  usage $# "[CMD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ -z "$1" ]]; then 
    echo "pyenv -v"
    pyenv -v
    
    echo "================="
    pyv versions
  else
    echo "pyenv $@"
    pyenv $@
  fi
}
pyvcd() {
  echo "cd ${PYENV_VERSIONS_PATH}"
  cd ${PYENV_VERSIONS_PATH}
}
# https://github.com/pyenv/pyenv/blob/master/COMMANDS.md
pyvinst() {
  usage $# "[VERSION:3.12]" "[MODE:shell|local|global]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=${1:--l}
  local MODE=${2:-install}

  pyv ${MODE} ${VERSION}
}
# https://github.com/pyenv/pyenv?tab=readme-ov-file#switch-between-python-versions
# select just for current shell session
pyvs() {
  usage $# "VERSION:3.12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=$1
  pyvinst ${VERSION} shell
}
# automatically select whenever you are in the current directory (or its subdirectories)
pyvl() {
  usage $# "VERSION:3.12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=$1
  pyvinst ${VERSION} local
}
# select globally for your user account
pyvg() {
  usage $# "VERSION:3.12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=$1
  pyvinst ${VERSION} global
}

pyvuninst() {
  usage $# "VERSION:3.12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    pyvinst
    return 1; 
  fi
  
  local VERSION=$1
  echo "pyenv uninstall ${VERSION}"
  pyenv uninstall ${VERSION}
}
