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

br() {
  brew --version
}
brupgall() {
  brew update
  brupg
  brcupg
}
brupg() {
  usage $# "[PACKAGE_NAME]"

  echo "brew upgrade $@"
  brew upgrade $@
}

brcls() {
  echo "brew list --cask"
  brew list --cask
}
brcupg() {
  usage $# "[PACKAGE_NAME]"
  
  if [ -n "$1" ]
    then
      echo "brew upgrade --cask $@"
      brew upgrade --cask $@
    else
      brcupg "$(brew list --cask)"
  fi
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
