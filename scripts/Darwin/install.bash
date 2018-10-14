export HOMEBREW_HOME=/usr/local/Library/Homebrew
export HOMEBREW_REPOSITORY=/usr/local/Cellar
export HOMEBREW_OPT=/usr/local/opt
export HOMEBREW_CACHE=/Users/$USER/Library/Caches/Homebrew

export SUBL_HOME=/Applications/Sublime\ Text.app
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse

alias brewcd='cd $HOMEBREW_REPOSITORY'
alias sdkcd='cd $SDKMAN_DIR'

lnk_subl() {
  ln -s "$SUBL_HOME/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
  # curl -o ~/Library/Application\ Support/Sublime\ Text\ 2/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package%20Control.sublime-package
  # Emmet
}

eclipsecd() {
  cd ${ECLIPSE_HOME}
}
eclipseplugin() {
  usage $# "PLUGIN_FILEPATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PLUGIN_FILEPATH=$1
  cp $PLUGIN_FILEPATH ${ECLIPSE_HOME}/plugins/
}

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
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
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

inst_git() {
  xcode-select --install
  xcode-select --reset
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

inst_pip() {
  local PIP_MODULE=${1:-regex}
  echo "Type your sudo password to be able to skip Permission denied into /Library/Python/ directory"
  echo "> curl https://bootstrap.pypa.io/ez_setup.py -o - | sudo python"
  curl https://bootstrap.pypa.io/ez_setup.py -o - | sudo python
  echo "> easy_install pip"
  /usr/local/bin/easy_install pip
  echo "> pip install $PIP_MODULE"
  pip install $PIP_MODULE
}
inst_node() {
  brew install node
  npm install -g grunt-cli
}

inst_gradle() {
  #brew install gradle
  if [ -z "$SDKMAN_DIR" ]; then
    inst_sdk
  fi
  sdk install gradle 4.5.1
}
inst_android() {
  brew tap caskroom/cask
  brew cask install android-sdk
}
inst_caffe() {
  # http://caffe.berkeleyvision.org/install_osx.html
  brew install -vd snappy leveldb gflags glog szip lmdb
  brew install hdf5 opencv

  brew install --with-python3 --without-python --build-from-source --with-python -vd protobuf
  brew install --with-python3 --without-python --build-from-source -vd boost boost-python

  ln -s /usr/local/Cellar/boost-python3/1.67.0/lib/libboost_python36.dylib /anaconda3/lib/libboost_python3.dylib
  ln -s /usr/local/Cellar/boost-python3/1.67.0/lib/libboost_python36.a /anaconda3/lib/libboost_python3.dylib
}

inst_graphviz() {
  brew install graphviz
}
graphviz() {
  usage $# "DOT_FILE" "[IMAGE_FORMAT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DOT_FILE=$1
  local IMAGE_FORMAT=${2:-png}

  BASENAME=${DOT_FILE%%.*}

  # https://www.graphviz.org/doc/info/command.html
  echo "dot -T${IMAGE_FORMAT} ${DOT_FILE} -o ${BASENAME}.${IMAGE_FORMAT}"
  dot -T${IMAGE_FORMAT} ${DOT_FILE} -o ${BASENAME}.${IMAGE_FORMAT}
}
inst_gvm() {
  curl -s get.gvmtool.net | bash
}

inst_sbt() {
  # https://www.scala-sbt.org/download.html
  brew install sbt@1
  sbt about
  enablesbt
}
