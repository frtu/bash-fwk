import lib-k8s

MINIKUBE_ROOT=~/.minikube
MINIKUBE_MACHINES_FOLDER=$MINIKUBE_ROOT/machines
MINIKUBE_PERSIST_FILE=$LOCAL_SCRIPTS_FOLDER/env-minikube-instance.bash

cdkm() {
  cd $MINIKUBE_ROOT
}

kmenv() {
  echo "------- Host CMD version --------";
  minikube version

  echo "------- VM internal version --------";
  minikube ssh cat /etc/VERSION

  echo "------- Virtual box --------";
  cat ~/.minikube/machines/minikube/config.json | grep DriverName
}
kmstart() {
  usage $# "[IMAGE_NAME]" "[REGISTRY_URL]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local IMAGE_NAME=$1
  local REGISTRY_URL=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$IMAGE_NAME" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -p ${IMAGE_NAME}"
  fi

  if [[ $REGISTRY_URL == https* ]]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS --registry-mirror=${REGISTRY_URL}"
    else
      if [[ $REGISTRY_URL == http* ]] ; then local EXTRA_PARAMS="$EXTRA_PARAMS --insecure-registry=${REGISTRY_URL}" ; fi
  fi

  kmtemplate "start" "${EXTRA_PARAMS}"

  echo "------- Help --------";
  echo "kmdashboard ${IMAGE_NAME} : to display dashboard"
  echo "kmlogs ${IMAGE_NAME} : to see logs"
  echo "kmssh ${IMAGE_NAME} : to SSH"
  echo "kmstop ${IMAGE_NAME} : to stop"
  echo "kmrm ${IMAGE_NAME} : to stop and remove image"
}
kmstartproxy() {
  usage $# "[IMAGE_NAME]" "[REGISTRY_URL]" "[PROXY_URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local IMAGE_NAME=$1
  local REGISTRY_URL=$2
  local PROXY_URL=$3
  local EXTRA_PARAMS=${@:4}

  if [[ $PROXY_URL == https* ]] 
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS --docker-env HTTPS_PROXY=${PROXY_URL}"
    else
      if [[ $PROXY_URL == http* ]] ; then local EXTRA_PARAMS="$EXTRA_PARAMS --docker-env HTTP_PROXY=${PROXY_URL}" ; fi
  fi

  kmstart "${IMAGE_NAME}" "${REGISTRY_URL}" "${EXTRA_PARAMS} --v 9999"
}
kmhello() {
  kmtemplate "service" "hello-minikube"
}
kmdashboard() {
  kmtemplate "dashboard" $@
}
kmssh() {
  if [ -z "$2" ]
  then
    kmtemplate "ssh" $1
  else
    local IMAGE_NAME=$1
    shift 1
    echo "CALL : root@$IMAGE_NAME> $@"
    echo "$@" | kmtemplate "ssh" $IMAGE_NAME
  fi
}
kmlogs() {
  kmtemplate "logs" $@
}
kmmutenotification() {
  kmtemplate "config" set WantUpdateNotification false
}

kmstop() {
  kmtemplate "stop" $@
}
kmrm() {
  kmtemplate "delete" $@
}
kmtemplate() {
  usage $# "CMD" "[CONTEXT:kcctx()]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CMD=$1
  local CONTEXT=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$CONTEXT" ]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS -p ${CONTEXT}"
    else
      if [ -n "$MINIKUBE_DEFAULT_INSTANCE" ]; then
        local EXTRA_PARAMS="$EXTRA_PARAMS -p ${MINIKUBE_DEFAULT_INSTANCE}"
      fi
  fi
  if [ -n "$EXTRA_KUBE_PARAMS" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS $EXTRA_KUBE_PARAMS"
  fi

  echo "minikube $1 ${EXTRA_PARAMS}"
  minikube $1 ${EXTRA_PARAMS}
}

kmload() {
  local IMAGE_NAME=$1
  echo "${FUNCNAME} ${IMAGE_NAME}"

  if [ -n "$1" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -p $1"
  fi
  minikube docker-env ${OPTIONAL_ARGS} | grep "DOCKER_HOST"
  eval $(minikube docker-env ${OPTIONAL_ARGS})
}
kmunload() {
  local IMAGE_NAME=$1
  echo "${FUNCNAME} ${IMAGE_NAME}"

  if [ -n "$1" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -p $1"
  fi
  minikube docker-env -u ${OPTIONAL_ARGS}
  eval $(minikube docker-env -u ${OPTIONAL_ARGS})
}
kmloadpersist() {
  local IMAGE_NAME=$1
  local EXTRA_KUBE_PARAMS=${@:2}

  if [ -n "$IMAGE_NAME" ]; then
    echo "Persiting MINIKUBE_DEFAULT_INSTANCE=$IMAGE_NAME!"
    echo "export MINIKUBE_DEFAULT_INSTANCE=$IMAGE_NAME" > $MINIKUBE_PERSIST_FILE
    source $MINIKUBE_PERSIST_FILE
  fi
  if [ -n "$EXTRA_KUBE_PARAMS" ]; then
    echo "Add EXTRA_KUBE_PARAMS=$EXTRA_KUBE_PARAMS!"
    echo "export EXTRA_KUBE_PARAMS=$EXTRA_KUBE_PARAMS" >> $MINIKUBE_PERSIST_FILE
    source $MINIKUBE_PERSIST_FILE
  fi

  kmload $IMAGE_NAME
}
kmloadpersistrm() {
  echo "unset MINIKUBE_DEFAULT_INSTANCE"
  unset MINIKUBE_DEFAULT_INSTANCE
  
  echo "unset EXTRA_KUBE_PARAMS"
  unset EXTRA_KUBE_PARAMS
  
  echo "rm $MINIKUBE_PERSIST_FILE"
  rm $MINIKUBE_PERSIST_FILE
}

