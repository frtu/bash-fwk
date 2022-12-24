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
  brew --prefix
}

brls() {
  brew list --versions
}
brsrh() {
  brew search $1
}
brunlk() {
  brew unlink $1
}

inst_python() {
  sudo chown -R $(whoami) /usr/local/Frameworks/Python.framework
  inst python
}
