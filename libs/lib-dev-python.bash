export REQ_FILENAME=requirements.txt

inst_pyenv() {
  echo "curl https://pyenv.run | bash"
  curl https://pyenv.run | bash
}
upg_pyenv() {
  echo "brew update && brew upgrade pyenv"
  brew update && brew upgrade pyenv
}

# https://stackoverflow.com/questions/122327/how-do-i-find-the-location-of-my-python-site-packages-directory
py() {
  python --version
  echo "================="
  which python
  echo "================="
  python -m site
}

# https://github.com/pyenv/pyenv/blob/master/COMMANDS.md
pyv() {
  usage $# "[VERSION:3.12]" "[MODE:shell|local|global]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=${1:--l}
  local MODE=${2:-install}

  echo "pyenv ${MODE} ${VERSION}"
  pyenv ${MODE} ${VERSION}
}
# https://github.com/pyenv/pyenv?tab=readme-ov-file#switch-between-python-versions
# select just for current shell session
pyvs() {
  usage $# "VERSION:3.12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=$1
  pyv ${VERSION} shell
}
# automatically select whenever you are in the current directory (or its subdirectories)
pyvl() {
  usage $# "VERSION:3.12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=$1
  pyv ${VERSION} local
}
# select globally for your user account
pyvg() {
  usage $# "VERSION:3.12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local VERSION=$1
  pyv ${VERSION} global
}

pyvuninst() {
  usage $# "VERSION:3.12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    pyv
    return 1; 
  fi
  
  local VERSION=$1
  echo "pyenv uninstall ${VERSION}"
  pyenv uninstall ${VERSION}
}
