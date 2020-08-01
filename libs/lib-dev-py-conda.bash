import lib-dev-py-pip

CONDA_PKG=${CONDA_ROOT_FOLDER}/lib/python3.8/site-packages
pcls() {
  ll ${CONDA_PKG}
}

pc() {
  echo "conda info"
  conda info

  echo "conda config --show-sources"
  conda config --show-sources

  echo "conda list --show-channel-urls"
  conda list --show-channel-urls
}
pcenvcreate() {
  usage $# "ENV_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ENV_NAME=$1
  echo "conda create --name ${ENV_NAME}"
  conda create --name ${ENV_NAME}

  pcenv ${ENV_NAME}
}
pcenv() {
  usage $# "ENV_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ENV_NAME=$1
  
  echo "conda activate ${ENV_NAME}"
  conda activate ${ENV_NAME}
}
pcenvdeactivate() {
  echo "conda deactivate"
  conda deactivate
}

pcugd() {
  echo "conda update conda"
  conda update conda
}
pcupd() {
  echo "conda update --all"
  conda update --all
}
pcinst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "conda install $@"
  conda install $@
}
pcrepo() {
  usage $# "CHANNEL_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CHANNEL_NAME=$1

  echo "conda config --add channels ${CHANNEL_NAME}"
  conda config --add channels ${CHANNEL_NAME}
}
pcrepoforge() {
  pcrepo conda-forge
}
pcinstforge() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "Find doc at https://anaconda.org/conda-forge/$@"
  pcinst -c conda-forge $@
}
