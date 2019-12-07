import lib-k8s

MINIKUBE_ROOT=~/.minikube
MINIKUBE_MACHINES_FOLDER=$MINIKUBE_ROOT/machines
MINIKUBE_PERSIST_FILE=$LOCAL_SCRIPTS_FOLDER/env-minikube-instance.bash

cdkm() {
  cd $MINIKUBE_ROOT
}

km() {
  echo "------- Host CMD version --------";
  minikube version

  echo "------- VM internal version --------";
  minikube ssh cat /etc/VERSION

  echo "------- Virtual box --------";
  cat ~/.minikube/machines/minikube/config.json | grep DriverName
}
kmstartdriver() {
  usage $# "DRIVER_NAME:virtualbox|hyperkit|none" "INSTANCE_NAME" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DRIVER_NAME=$1
  local INSTANCE_NAME=$2
  local EXTRA_PARAMS=${@:3}

  kmstart ${INSTANCE_NAME} --vm-driver=${DRIVER_NAME} ${EXTRA_PARAMS}
}
# only impacts those images with no repository prefix - images that come from the Docker official registry
kmstartreg() {
  usage $# "[INSTANCE_NAME]" "[REGISTRY_URL]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  local REGISTRY_URL=$2
  local EXTRA_PARAMS=${@:3}

  if [[ $REGISTRY_URL == https* ]]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS --registry-mirror=${REGISTRY_URL}"
    else
      if [[ $REGISTRY_URL == http* ]] ; then local EXTRA_PARAMS="$EXTRA_PARAMS --insecure-registry=${REGISTRY_URL}" ; fi
  fi
  kmstart "${INSTANCE_NAME}" "${EXTRA_PARAMS}"
}
kmstartproxy() {
  usage $# "[INSTANCE_NAME]" "[PROXY_URL]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  local PROXY_URL=$2
  local EXTRA_PARAMS=${@:3}

  # https://minikube.sigs.k8s.io/docs/reference/networking/proxy/
  if [[ $PROXY_URL == https* ]] 
    then
      EXTRA_PARAMS="$EXTRA_PARAMS --docker-env HTTPS_PROXY=${PROXY_URL}"
    else
      if [[ $PROXY_URL == http* ]] ; then EXTRA_PARAMS="$EXTRA_PARAMS --docker-env HTTP_PROXY=${PROXY_URL}" ; fi
  fi
  EXTRA_PARAMS="$EXTRA_PARAMS --docker-env no_proxy=localhost,127.0.0.1,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24"

  kmstart "${INSTANCE_NAME}" "${EXTRA_PARAMS} --v 9999"
}
kmstart() {
  usage $# "[INSTANCE_NAME]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  local EXTRA_PARAMS=${@:2}

  kmtemplate "start" "${INSTANCE_NAME}" "${EXTRA_PARAMS}"

  echo "------- Help --------";
  echo "kmdashboard ${INSTANCE_NAME} : to display dashboard"
  echo "kmlogs ${INSTANCE_NAME} : to see logs"
  echo "kmssh ${INSTANCE_NAME} : to SSH"
  echo "kmstop ${INSTANCE_NAME} : to stop"
  echo "kmrm ${INSTANCE_NAME} : to stop and remove image"
}
kmhello() {
  kmtemplate "service" "hello-minikube"
}
kmdashboard() {
  kmtemplate "dashboard" $@
}

kmssh() {
  usage $# "INSTANCE_NAME" "[COMMANDS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  if [ -z "$2" ]
    then
      kmtemplate "ssh" ${INSTANCE_NAME}
    else
      shift 1
      echo "CALL : root@${INSTANCE_NAME}> $@"
      echo "$@" | kmtemplate "ssh" ${INSTANCE_NAME}
  fi
}
kmip() {
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  kmtemplate "ip" $@
}
kmlogs() {
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  kmtemplate "logs" $@
}
kmstop() {
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  kmtemplate "stop" $@
}
kmrm() {
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

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

kmmutenotification() {
  kmtemplate "config" set WantUpdateNotification false
}
kmload() {
  local INSTANCE_NAME=$1
  echo "${FUNCNAME} ${INSTANCE_NAME}"

  if [ -n "$1" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -p $1"
  fi
  minikube docker-env ${OPTIONAL_ARGS} | grep "DOCKER_HOST"
  eval $(minikube docker-env ${OPTIONAL_ARGS})
}
kmunload() {
  local INSTANCE_NAME=$1
  echo "${FUNCNAME} ${INSTANCE_NAME}"

  if [ -n "$1" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -p $1"
  fi
  minikube docker-env -u ${OPTIONAL_ARGS}
  eval $(minikube docker-env -u ${OPTIONAL_ARGS})
}
kmloadpersist() {
  local INSTANCE_NAME=$1
  local EXTRA_KUBE_PARAMS=${@:2}

  if [ -n "$INSTANCE_NAME" ]; then
    echo "Persiting MINIKUBE_DEFAULT_INSTANCE=$INSTANCE_NAME!"
    echo "export MINIKUBE_DEFAULT_INSTANCE=$INSTANCE_NAME" > $MINIKUBE_PERSIST_FILE
    source $MINIKUBE_PERSIST_FILE
  fi
  if [ -n "$EXTRA_KUBE_PARAMS" ]; then
    echo "Add EXTRA_KUBE_PARAMS=$EXTRA_KUBE_PARAMS!"
    echo "export EXTRA_KUBE_PARAMS=$EXTRA_KUBE_PARAMS" >> $MINIKUBE_PERSIST_FILE
    source $MINIKUBE_PERSIST_FILE
  fi

  kmload $INSTANCE_NAME
}
kmloadpersistrm() {
  echo "unset MINIKUBE_DEFAULT_INSTANCE"
  unset MINIKUBE_DEFAULT_INSTANCE
  
  echo "unset EXTRA_KUBE_PARAMS"
  unset EXTRA_KUBE_PARAMS
  
  echo "rm $MINIKUBE_PERSIST_FILE"
  rm $MINIKUBE_PERSIST_FILE
}

