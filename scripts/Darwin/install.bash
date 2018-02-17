export HOMEBREW_HOME=/usr/local/Library/Homebrew
export HOMEBREW_REPOSITORY=/usr/local/Cellar
export HOMEBREW_OPT=/usr/local/opt
export HOMEBREW_CACHE=/Users/$USER/Library/Caches/Homebrew

alias brewcd='cd $HOMEBREW_REPOSITORY'
alias sdkcd='cd $SDKMAN_DIR'

inst_brew() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap caskroom/homebrew-cask
  brew install brew-cask
  brew tap beeftornado/rmtree
}
uninst() {
  if [ $# -eq 0 ]
    then
      echo "Please supply which package you want to uninstall"
      return
  fi
  brew rmtree $1
}
inst_sdk() {
  # http://sdkman.io/
  curl -s "https://get.sdkman.io" | bash
  source "~/.sdkman/bin/sdkman-init.sh"
}

brew_ls() {
  brew list --versions
}
brew_srh() {
  brew search $1
}
brew_unlk() {
  brew unlink $1
}

inst_wget() {
  brew install wget
}
inst_vagrant() {
  # brew install Caskroom/cask/virtualbox
  #brew install Caskroom/cask/virtualbox-extension-pack

  brew cask install virtualbox
  brew cask install virtualbox-extension-pack

  brew cask install vagrant
  brew cask install vagrant-manager
  brew tap homebrew/completions
  brew install vagrant-completion
}

inst_node() {
  brew install node
  npm install -g grunt-cli
}

inst_gradle() {
  #brew install gradle
  if [ ! -d "$SDKMAN_DIR" ]; then
    inst_sdk
  fi
  sdk install gradle 4.5.1
}
inst_android() {
  brew tap caskroom/cask
  brew cask install android-sdk
}

inst_gvm() {
  curl -s get.gvmtool.net | bash
}
lnk_subl() {
  ln -s /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
  curl -o ~/Library/Application\ Support/Sublime\ Text\ 2/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package%20Control.sublime-package
  # Emmet
}
