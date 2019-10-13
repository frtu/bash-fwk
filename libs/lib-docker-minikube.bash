import lib-k8s

MINIKUBE_ROOT=~/.minikube
MINIKUBE_MACHINES_FOLDER=$MINIKUBE_ROOT/machines
MINIKUBE_PERSIST_FILE=$LOCAL_SCRIPTS_FOLDER/env-minikube-instance.bash

cdk8s() {
  cd $MINIKUBE_ROOT
}

k8menv() {
  echo "------- Host CMD version --------";
  minikube version

  echo "------- VM internal version --------";
  minikube ssh cat /etc/VERSION

  echo "------- Virtual box --------";
  cat ~/.minikube/machines/minikube/config.json | grep DriverName
}
k8mstart() {
  usage $# "[IMAGE_NAME]" "[REGISTRY_URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local IMAGE_NAME=$1
  local REGISTRY_URL=$2

  if [ -n "$IMAGE_NAME" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -p ${IMAGE_NAME}"
  fi
  if [ -n "$REGISTRY_URL" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --registry-mirror=${REGISTRY_URL}"
  fi

  k8mtemplate "start" "${EXTRA_PARAMS}"

  echo "------- Help --------";
  echo "k8mdashboard ${IMAGE_NAME} : to display dashboard"
  echo "k8mlogs ${IMAGE_NAME} : to see logs"
  echo "k8mssh ${IMAGE_NAME} : to SSH"
  echo "k8mstop ${IMAGE_NAME} : to stop"
  echo "k8mrm ${IMAGE_NAME} : to stop and remove image"
}
k8mdashboard() {
  k8mtemplate "dashboard" $@
}
k8mssh() {
  if [ -z "$2" ]
  then
    k8mtemplate "ssh" $1
  else
    local IMAGE_NAME=$1
    shift 1
    echo "CALL : root@$IMAGE_NAME> $@"
    echo "$@" | k8mtemplate "ssh" $IMAGE_NAME
  fi
}
k8mlogs() {
  k8mtemplate "logs" $@
}
k8mmutenotification() {
  k8mtemplate "config" set WantUpdateNotification false
}

k8mstop() {
  k8mtemplate "stop" $@
}
k8mrm() {
  k8mtemplate "delete" $@
}
k8mtemplate() {
  local EXTRA_PARAMS=${@:2}

  if [ -n "$EXTRA_KUBE_PARAMS" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS $EXTRA_KUBE_PARAMS"
  fi
  if [ -n "$MINIKUBE_DEFAULT_INSTANCE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -p $MINIKUBE_DEFAULT_INSTANCE"
  fi

  echo "minikube $1 ${EXTRA_PARAMS}"
  minikube $1 ${EXTRA_PARAMS}
}

k8mload() {
  local IMAGE_NAME=$1
  echo "${FUNCNAME} ${IMAGE_NAME}"

  if [ -n "$1" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -p $1"
  fi
  minikube docker-env ${OPTIONAL_ARGS} | grep "DOCKER_HOST"
  eval $(minikube docker-env ${OPTIONAL_ARGS})
}
k8munload() {
  local IMAGE_NAME=$1
  echo "${FUNCNAME} ${IMAGE_NAME}"

  if [ -n "$1" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -p $1"
  fi
  minikube docker-env -u ${OPTIONAL_ARGS}
  eval $(minikube docker-env -u ${OPTIONAL_ARGS})
}
k8mloadpersist() {
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

  k8mload $IMAGE_NAME
}
k8mloadpersistrm() {
  echo "unset MINIKUBE_DEFAULT_INSTANCE"
  unset MINIKUBE_DEFAULT_INSTANCE
  
  echo "unset EXTRA_KUBE_PARAMS"
  unset EXTRA_KUBE_PARAMS
  
  echo "rm $MINIKUBE_PERSIST_FILE"
  rm $MINIKUBE_PERSIST_FILE
}

