export HOMEBREW_HOME=/usr/local/Library/Homebrew
export HOMEBREW_REPOSITORY=/usr/local/Cellar
export HOMEBREW_OPT=/usr/local/opt
export HOMEBREW_CACHE=/Users/$USER/Library/Caches/Homebrew

alias cdbr='cd $HOMEBREW_REPOSITORY'

inst_brew() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  sudo chown -R $(whoami) /usr/local/Homebrew/
  brew tap caskroom/homebrew-cask
  brew install brew-cask
  brew tap beeftornado/rmtree
}
inst_update() {
  brew upgrade
  brew cask upgrade
}

br() {
  brew --version
}
brpath() {
  usage $# "[PACKAGE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PACKAGE_NAME=$1

  brew --prefix ${PACKAGE_NAME}
}

brls() {
  brew list --versions
}
brsrh() {
  brew search $@
}
brunlk() {
  brew unlink $@
}
brdesc() {
  usage $# "[PACKAGE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PACKAGE_NAME=$1

  brew info --cask ${PACKAGE_NAME}
}

# --------------------------------
# Develop
# --------------------------------
inst_cmake() {
  inst cmake
}

# Already include python & package mgmt
# x86
inst_conda() {
  brew install --cask anaconda
  enablelib dev-py-conda
}
upd_conda() {
  sudo chown -R $(whoami) /Users/fred/.conda
  conda update -n base -c defaults conda
}
inst_python() {
  sudo chown -R $(whoami) /usr/local/Frameworks/Python.framework
  inst python
}

inst_protobuf() {
  # brew tap homebrew/versions
  # brew install protobuf241
  inst protobuf
}
