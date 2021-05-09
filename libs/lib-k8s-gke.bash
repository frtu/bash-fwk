import lib-k8s

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

gkeaddprj() {
  usage $# "PROJECT_ID" "PROJECT_NAME" "REGION" "[ADDITIONAL_SETTINGS]"
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
  local PROJECT_NAME=$2
  local REGION=$3
  local ADDITIONAL_SETTINGS=${@:4}
  
  echo "Adding project to ${OUTPUT_SERVICE_FILENAME}"
  echo "alias gkeprj${PROJECT_NAME}='gcloud config set project ${PROJECT_ID}; gcloud container clusters get-credentials ${PROJECT_NAME} --region ${REGION}'" >> $OUTPUT_SERVICE_FILENAME
  if [[ -n $ADDITIONAL_SETTINGS ]]; then 
    echo "${ADDITIONAL_SETTINGS}" >> $OUTPUT_SERVICE_FILENAME
  fi

  source $OUTPUT_SERVICE_FILENAME
}