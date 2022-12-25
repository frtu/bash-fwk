import lib-dev-py-pip

CONDA_PKG=${CONDA_ROOT_FOLDER}/lib/python3.8/site-packages
pcls() {
  echo "conda list $@"
  conda list $@
}

pc() {
  echo "conda --version"
  conda --version

  echo "conda info"
  conda info

  echo "conda config --show-sources"
  conda config --show-sources

  echo "conda list --show-channel-urls"
  conda list --show-channel-urls
}
pcinit() {
  echo "conda init $@"
  conda init $@
}
pccreate() {
  usage $# "ENV_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ENV_NAME=$1
  echo "conda create --name ${ENV_NAME}"
  conda create --name ${ENV_NAME}

  pcenv ${ENV_NAME}
}
pcenvcreate() {
  usage $# "[FILE_NAME]" "[ENV_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FILE_NAME=${1:-environment.yaml}
  local ENV_NAME=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$ENV_NAME" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --name ${ENV_NAME}"
  fi

  if [ -f "$FILE_NAME" ]; then
      EXTRA_PARAMS="$EXTRA_PARAMS -f ${FILE_NAME}"
  fi

  echo "conda env create ${EXTRA_PARAMS}"
  conda env create ${EXTRA_PARAMS}
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
  echo "conda update conda $@"
  conda update conda $@
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
pcinstanaconda() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "Find doc at https://anaconda.org/anaconda/$@"
  pcinst -c anaconda $@
}
pcinstplotly() {
	pcinst -c https://conda.anaconda.org/plotly plotly
}
pcinstinfluxdb() {
	pcinst -c mcrot influxdb
}

pcinstbasemap() {
  ppinst geos
  pcinstforge proj4
  pcinstforge basemap
  pcinstforge basemap-data-hires
}
pcinstbasemap() {
  pcinstforge proj4 cartopy
}
