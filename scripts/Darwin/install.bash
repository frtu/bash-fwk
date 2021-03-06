export HOMEBREW_HOME=/usr/local/Library/Homebrew
export HOMEBREW_REPOSITORY=/usr/local/Cellar
export HOMEBREW_OPT=/usr/local/opt
export HOMEBREW_CACHE=/Users/$USER/Library/Caches/Homebrew

export SUBL_HOME=/Applications/Sublime\ Text.app
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse

export INSTALL_TOOL=brew
export UNINSTALL_TOOL="brew rmtree"
export CHECK_SUDO=false
import lib-inst

inst_brew() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap caskroom/homebrew-cask
  brew install brew-cask
  brew tap beeftornado/rmtree
}
inst_update() {
  brew upgrade
  brew cask upgrade
}
inst_zlib() {
  inst zlib
  brew link zlib
}

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
# For Docker host
enabledockertoolbox() {
  enablelib dockertoolbox
  srv_activate dockertoolbox
}
inst_kubectl_brew() {
  inst kubectl
}
inst_minikube_brew() {
  usage $# "[PROXY]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PROXY=$1
  if [ -z "$PROXY" ]; then
    export HTTP_PROXY=http://${PROXY}
    export HTTPS_PROXY=http://${PROXY}
    export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24
  fi
  
  echo 'brew cask install minikube'
  brew cask install minikube

  echo 'enablelib docker-minikube'
  enablelib docker-minikube

  refresh
}
inst_helm() {
  inst kubernetes-helm
}

inst_python() {
  usage $# "[PYTHON_VERSION]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PYTHON_VERSION=${1:-3.7.2}
  echo "Installation > pyenv install -v ${PYTHON_VERSION}"
  inst pyenv
  CFLAGS="-I$(xcrun --show-sdk-path)/usr/include" pyenv install -v ${PYTHON_VERSION}

  CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)" 
  CFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix sqlite)/include" 
  LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix sqlite)/lib" 
  pyenv install ${PYTHON_VERSION}
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
inst_caffe() {
  # http://caffe.berkeleyvision.org/install_osx.html
  brew install -vd snappy leveldb gflags glog szip lmdb
  brew install hdf5 opencv

  brew install --with-python3 --without-python --build-from-source --with-python -vd protobuf
  brew install --with-python3 --without-python --build-from-source -vd boost boost-python

  ln -s /usr/local/Cellar/boost-python3/1.67.0/lib/libboost_python36.dylib /anaconda3/lib/libboost_python3.dylib
  ln -s /usr/local/Cellar/boost-python3/1.67.0/lib/libboost_python36.a /anaconda3/lib/libboost_python3.dylib
}

enable_nginx() {
  enablelib nginx "alias ngcd=/usr/local/etc/nginx/"
}

enable_node() {
  enablelib dev-node
  njversion
}
inst_node() {
  brew install node
  npm install -g grunt-cli
  enable_node
}
inst_nvm() {
  inst nvm
  mkdir -p ~/.nvm

  echo "- Create local env in $LOCAL_SCRIPTS_FOLDER/env-nvm.bash"
  echo 'export NVM_DIR=~/.nvm' > $LOCAL_SCRIPTS_FOLDER/env-nvm.bash
  echo '[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"' >> $LOCAL_SCRIPTS_FOLDER/env-nvm.bash
  echo '[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"' >> $LOCAL_SCRIPTS_FOLDER/env-nvm.bash
  echo '' >> $LOCAL_SCRIPTS_FOLDER/env-nvm.bash
  
  echo 'import lib-dev-nvm' >> $LOCAL_SCRIPTS_FOLDER/env-nvm.bash

  source $LOCAL_SCRIPTS_FOLDER/env-nvm.bash
  njversion

  echo "> nvminst 'VERSION'"
}
inst_nvm_get() {
  usage $# "[VERSION]"
  local VERSION=${1:-v10.13.0}

  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
  nvm install ${VERSION}
}

inst_android() {
  brew tap caskroom/cask
  brew cask install android-sdk
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
