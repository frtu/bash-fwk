import lib-inst
source inst-brew.bash

export SUBL_HOME=/Applications/Sublime\ Text.app
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse

export INSTALL_TOOL=brew
export UNINSTALL_TOOL="brew uninstall"
export CHECK_SUDO=false

inst_zlib() {
  inst zlib
  brew link zlib
}

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

alias inst_git=inst_xcode
inst_xcode() {
  xcode-select --install
  xcode-select --reset
}
uninst_xcode() {
  echo "sudo rm -rf /Library/Developer/CommandLineTools"
  sudo rm -rf /Library/Developer/CommandLineTools
}
# Git Large File System
inst_git_lfs() {
  inst git-lfs
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

inst_caffe() {
  # http://caffe.berkeleyvision.org/install_osx.html
  brew install -vd snappy leveldb gflags glog szip lmdb
  brew install hdf5 opencv

  brew install --with-python3 --without-python --build-from-source --with-python -vd protobuf
  brew install --with-python3 --without-python --build-from-source -vd boost boost-python

  ln -s /usr/local/Cellar/boost-python3/1.67.0/lib/libboost_python36.dylib /anaconda3/lib/libboost_python3.dylib
  ln -s /usr/local/Cellar/boost-python3/1.67.0/lib/libboost_python36.a /anaconda3/lib/libboost_python3.dylib
}

inst_grpc_gui() {
  inst --cask bloomrpc
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

inst_dbeaver() {
  echo "brew install --cask dbeaver-community"
  brew install --cask dbeaver-community
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

# CPU and Memory Widget
inst_stats() {
  inst stats
}

# --------------------------------
# Develop
# --------------------------------
inst_cmake() {
  inst cmake
}

alias inst_conda=inst_conda_m1
# Already include python & package mgmt
# ARM
inst_conda_m1() {
  ## Anaconda & Miniconda
  ## https://docs.anaconda.com/anaconda/install/silent-mode/
  # curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/miniconda.sh
  # bash ~/miniconda.sh -b -p $HOME/miniconda
  # eval "$($HOME/miniconda/bin/conda shell.bash hook)"

  ## Miniforge3
  curl -fsSLo Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh"
  bash Miniforge3.sh -u -b -p "${HOME}/conda"
  source "${HOME}/conda/etc/profile.d/conda.sh"
  conda activate

  enablelib dev-py-conda
  binappend ~/conda/bin/conda
}
# x86
inst_conda_x86() {
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
  binappend /opt/homebrew/bin/
}
# https://realpython.com/intro-to-pyenv/
inst_pyenv() {
  echo "brew install openssl readline sqlite3 xz zlib"
  brew install openssl readline sqlite3 xz zlib

  echo "curl https://pyenv.run | bash"
  curl https://pyenv.run | bash
}
upg_pyenv() {
  echo "brew update && brew upgrade pyenv"
  brew update && brew upgrade pyenv
}

inst_protobuf() {
  # brew tap homebrew/versions
  # brew install protobuf241
  inst protobuf
}

# --------------------------------
# AI
# --------------------------------
inst_ctags() {
  inst universal-ctags
  ctags --version
}
inst_jupyter() {
  inst jupyter
}
inst_pytorch() {
  inst torch torchvision torchaudio
}