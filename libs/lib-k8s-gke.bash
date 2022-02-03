import lib-k8s

gkeinst() {
  echo "inst --cask google-cloud-sdk"
  inst --cask google-cloud-sdk
}
gkeupd() {
  echo "gcloud components update"
  gcloud components update
}

gke() {
  echo "gcloud info"
  gcloud info
}
gkelogin() {
  echo "gcloud auth login"
  gcloud auth login
}
gkeinit() {
  echo "gcloud init"
  gcloud init
}
gkediagnostics() {
  echo "gcloud info --run-diagnostics"
  gcloud info --run-diagnostics
}

# Config
gkeconf() {
  echo "gcloud help config"
  gcloud help config
}
gkeconfregion() {
  usage $# "REGION_NAME:asia-east2"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gkeconfset compute/region $1
}
gkeconfzone() {
  usage $# "ZONE_NAME:asia-east2-c"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gkeconfset compute/zone $1
}
gkeconfreporting() {
  usage $# "[CONF_PARAM_NAME:true|false]"
  local CONF_PARAM_NAME=${1:-false}
  gkeconfset disable_usage_reporting ${CONF_PARAM_NAME}
}
gkeconfset() {
  usage $# "CONF_PARAM_NAME" "CONF_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CONF_PARAM_NAME=$1
  local CONF_PARAM_VALUE=$2

  echo "gcloud config set $CONF_PARAM_NAME \"$CONF_PARAM_VALUE\""
  gcloud config set $CONF_PARAM_NAME "$CONF_PARAM_VALUE"
}

# Manage a K8s cluster at https://console.cloud.google.com/kubernetes/
gkeprjset() {
  usage $# "PROJECT_ID:zeta-surf-123456" "[ADDITIONAL_SETTINGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
 
  local PROJECT_ID=$1
  local ADDITIONAL_SETTINGS=${@:2}
  
  echo "gcloud config set project ${PROJECT_ID} ${ADDITIONAL_SETTINGS}"
  gcloud config set project ${PROJECT_ID} ${ADDITIONAL_SETTINGS}
}
gkeprjgetcredential() {
  usage $# "PROJECT_ID:zeta-surf-123456" "CLUSTER_NAME:cluster-asia-east" "REGION:asia-east2" "[ADDITIONAL_SETTINGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PROJECT_ID=$1
  local CLUSTER_NAME=$2
  local REGION=$3
  local ADDITIONAL_SETTINGS=${@:4}

  echo "gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${REGION} --project ${PROJECT_ID} ${ADDITIONAL_SETTINGS}"
  gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${REGION} --project ${PROJECT_ID} ${ADDITIONAL_SETTINGS}
}
gkeprjadd() {
  usage $# "PROJECT_ID:zeta-surf-123456" "CLUSTER_NAME:cluster-asia-east" "REGION:asia-east2" "[ADDITIONAL_SETTINGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  ##################################
  local LIB_NAME_WITHOUT_PREFIX=k8s-gke
  local OUTPUT_SERVICE_FILENAME=$SERVICE_LOCAL_BASH_PREFIX$LIB_NAME_WITHOUT_PREFIX.bash
  ##################################
  # CREATE IF NOT EXIST
  if [ ! -f "$OUTPUT_SERVICE_FILENAME" ]; then
    enablelib ${LIB_NAME_WITHOUT_PREFIX}
  fi
  ##################################
  
  local PROJECT_ID=$1
  local CLUSTER_NAME=$2
  local REGION=$3
  local ADDITIONAL_SETTINGS=${@:4}
  
  echo "Adding project to ${OUTPUT_SERVICE_FILENAME}"
  echo "alias gkeprj${CLUSTER_NAME}='gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${REGION}  --project ${PROJECT_ID}'" >> $OUTPUT_SERVICE_FILENAME
  
  if [[ -n $ADDITIONAL_SETTINGS ]]; then 
    echo "${ADDITIONAL_SETTINGS}" >> $OUTPUT_SERVICE_FILENAME
  fi

  source $OUTPUT_SERVICE_FILENAME
  echo "PLEASE RUN : gkeprj${CLUSTER_NAME}"
}

# https://cloud.google.com/container-registry/docs/quickstart?hl=en_US&_ga=2.266249671.958204232.1643861732-1066249181.1615732322#before-you-begin
gkereg() {
  echo "gcloud auth configure-docker"
  gcloud auth configure-docker
}
