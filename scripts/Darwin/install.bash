export HOMEBREW_REPOSITORY=/usr/local/Homebrew
export HOMEBREW_CACHE=/Users/$USER/Library/Caches/Homebrew

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
  brew install gradle
}

inst_tomcat() {
  brew install tomcat
  export TOMCAT_HOME=/Library/Tomcat
  sudo ln -s /usr/local/Cellar/tomcat/8.0.18/libexec $TOMCAT_HOME
  sudo chown -R $USER $TOMCAT_HOME
  sudo chmod +x $TOMCAT_HOME/bin/*.sh
}

inst_gvm() {
  curl -s get.gvmtool.net | bash
}
lnk_subl() {
  ln -s /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
  curl -o ~/Library/Application\ Support/Sublime\ Text\ 2/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package%20Control.sublime-package
  # Emmet
}
