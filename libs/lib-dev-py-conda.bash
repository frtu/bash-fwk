import lib-dev-py-pip

CONDA_PKG=${CONDA_ROOT_FOLDER}/lib/python3.8/site-packages

pcls() {
  usage $# "[ENV_NAME]" "[EXTRA_PARAMS]"

  local ENV_NAME=$1
  local EXTRA_PARAMS=${@:2}

  if [ -n "$ENV_NAME" ]; then
    local EXTRA_PARAMS="-n ${ENV_NAME} ${EXTRA_PARAMS}"
  fi

  echo "conda list ${EXTRA_PARAMS}"
  conda list ${EXTRA_PARAMS}
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

## CONFIGURE ENV VARS
pcconf() {
  usage $# "CONF_NAME" "CONF_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CONF_NAME=$1
  local CONF_VALUE=$2

  echo "conda env config vars set ${CONF_NAME}=${CONF_VALUE}"
  conda env config vars set ${CONF_NAME}=${CONF_VALUE}
}
pcconfm1() {
  pcconf CONDA_SUBDIR "osx-arm64" $@
}
pcconfdeactivateauto() {
  echo "conda config --set auto_activate_base false"
  conda config --set auto_activate_base false
}
pcconfyes() {
  echo "conda config --env --set always_yes true"
  conda config --env --set always_yes true
}
pcconfno() {
  echo "conda config --env --remove-key always_yes"
  conda config --env --remove-key always_yes
}

## MANAGE ISOLATED ENV
pcenv() {
  usage $# "[ENV_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local ENV_NAME=$1
  if [ -n "$ENV_NAME" ]
    then
      echo "conda activate ${ENV_NAME}"
      conda activate ${ENV_NAME}
    else
      pcenvls
  fi
}
pcenvls() {
  echo "conda env list"
  conda env list
}
pcenvdeactivate() {
  echo "conda deactivate"
  conda deactivate
}
pcenvcreate() {
  usage $# "ENV_NAME" "[PACKAGES:python=3.8 numpy=1.19.5]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local ENV_NAME=$1
  echo "conda create --name ${ENV_NAME} ${@:2}"
  conda create --name ${ENV_NAME} ${@:2}

  pcenv ${ENV_NAME}
}
pcenvcreatefile() {
  usage $# "[FILE_NAME]" "[ENV_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

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

  if [ -n "$ENV_NAME" ]; then
    echo "conda activate ${ENV_NAME}"
    conda activate "${ENV_NAME}"
  fi
}
pcenvrm() {
  usage $# "ENV_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local ENV_NAME=$1
  
  pcenvdeactivate
  
  echo "conda env remove -n ${ENV_NAME}"
  conda env remove -n ${ENV_NAME}
}

## ADDING REPO
pcugdbase() {
  pcugd -n base -c conda-forge
}
pcugd() {
  echo "conda update $@ conda"
  conda update $@ conda
}
pcupd() {
  echo "conda update --all"
  conda update --all
}

pcinst() {
  usage $# "[PACKAGE]" "[VERSION]"

  local PACKAGE=$1
  local VERSION=$2

  if [ -n "$PACKAGE" ]
    then
      if [ -n "$VERSION" ]
        then
          local INST_ARG="${PACKAGE}==${VERSION}"
        else
          local INST_ARG="${PACKAGE}"
      fi
    else
      if [[ -f "${REQ_FILENAME}" ]] 
        then 
          local INST_ARG="--file ${REQ_FILENAME}"
        else
          echo "Please pass a PACKAGE name or run in a folder that contains ${REQ_FILENAME}" >&2
          return 1
      fi      
  fi
  
  echo "conda install -y ${INST_ARG}"
  conda install -y ${INST_ARG}
}
pcuninst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PACKAGE=$1

  echo "conda uninstall ${PACKAGE}"
  conda uninstall ${PACKAGE}
}

pcrepo() {
  usage $# "CHANNEL_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CHANNEL_NAME=$1

  echo "conda config --add channels ${CHANNEL_NAME}"
  conda config --add channels ${CHANNEL_NAME}
}
pcrepols() {
  echo "conda config --show channels"
  conda config --show channels
}
pcrepoclean() {
  pcenvdeactivate
  
  echo "conda clean --all --yes"
  conda clean --all --yes
}

pcrepoforge() {
  pcrepo conda-forge
}
pcinstrepoforge() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "Find doc at https://anaconda.org/conda-forge/$@"
  echo "conda install -y -c conda-forge $@"
  conda install -y -c conda-forge $@
}
pcinstanaconda() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "Find doc at https://anaconda.org/anaconda/$@"
  echo "conda install -y -c anaconda $@"
  conda install -y -c anaconda $@
}

pcinstdotenv() {
  pcinst python-dotenv
}
pcinstplotly() {
  echo "conda install -y -c https://conda.anaconda.org/plotly plotly"
	conda install -y -c https://conda.anaconda.org/plotly plotly
}
pcinstopencv() {
  echo "conda install -y -c conda-forge opencv torchvision omegaconf invisible-watermark einops pytorch_lightning"
	conda install -y -c conda-forge opencv torchvision omegaconf invisible-watermark einops pytorch_lightning
}
pcinstinfluxdb() {
  echo "conda install -y -c mcrot influxdb"
	conda install -y -c mcrot influxdb
}
pcinstbasemap() {
  ppinst geos
  pcinstrepoforge proj4
  pcinstrepoforge basemap
  pcinstrepoforge basemap-data-hires
}
pcinstbasemap() {
  pcinstrepoforge proj4 cartopy
}

pcarchm1() {
  envcreate "CONDA_SUBDIR" "osx-arm64"
  # TO BE RUN IN SPECIFIC ENV
  pcconfm1
}
