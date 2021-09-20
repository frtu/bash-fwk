import lib-k8s
import lib-docker
import lib-inst

MINIKUBE_ROOT=~/.minikube
MINIKUBE_MACHINES_FOLDER=$MINIKUBE_ROOT/machines
MINIKUBE_PERSIST_FILE=$LOCAL_SCRIPTS_FOLDER/env-minikube-instance.bash

MINIKUBE_VAR=/var/lib/minikube

cdkm() {
  cd $MINIKUBE_ROOT
}
cdkmvar() {
  cd $MINIKUBE_VAR
}

# https://kubernetes.io/docs/tasks/tools/install-minikube/#install-minikube-via-direct-download
inst_dl_minikube() {
  usage $# "[VERSION:latest]" "[EXEC_URL:storage.googleapis.com/../minikube-linux-amd64]" "[BIN_PATH:/usr/local/bin/]"
  echo "== Check release version at https://github.com/kubernetes/minikube/tags =="

  local VERSION=$1
  local EXEC_URL=$2
  local BIN_PATH=${3:-/usr/local/bin/}

  if [[ -z ${EXEC_URL} ]]; then
    if [[ -z ${VERSION} ]]; then
      VERSION=latest
    fi
    local OS=$(uname | tr '[:upper:]' '[:lower:]')
    local EXEC_URL=https://storage.googleapis.com/minikube/releases/${VERSION}/minikube-${OS}-amd64
  fi

  inst_dl_bin "minikube" "${EXEC_URL}" "${BIN_PATH}"

  # ADD IF MOVE THE SCRIPT OUT : enablelib k8s-minikube
  km
}

alias kmls=kcctx

km() {
  echo "------- Host CMD version --------";
  minikube version

  echo "------- VM internal version --------";
  minikube ssh cat /etc/VERSION

  echo "------- Virtual box --------";
  cat ~/.minikube/machines/minikube/config.json | grep DriverName
}

# https://minikube.sigs.k8s.io/docs/reference/drivers/none/
kmconfdriverset() {
  # hyperkit : https://github.com/moby/hyperkit
  usage $# "DRIVER_NAME:none|virtualbox|hyperkit"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local DRIVER_NAME=$1
  kmconftpl set vm-driver ${DRIVER_NAME}
}
kmconfmute() {
  kmconftpl set WantUpdateNotification false
}
kmconfvi() {
  vi ${MINIKUBE_ROOT}/config/config.json
}
kmconftpl() {
  usage $# "CMD:set" "EXTRA_PARAMS"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local EXTRA_PARAMS=${@:2}

  echo "minikube config ${CMD} ${EXTRA_PARAMS}"
  minikube config ${CMD} ${EXTRA_PARAMS}
}

kmstartlocal() {
  usage $# "[K8S_VERSION]" "[DRIVER_NAME:none]" "[INSTANCE_NAME:minikube]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local K8S_VERSION=$1
  local DRIVER_NAME=${2:-none}
  local INSTANCE_NAME=${3:-minikube}

  if [ -n "$K8S_VERSION" ]; then
    local EXTRA_PARAMS="${EXTRA_PARAMS} --kubernetes-version ${K8S_VERSION}"
  fi
  echo "sudo /usr/local/bin/minikube start --vm-driver=${DRIVER_NAME} --apiserver-ips 127.0.0.1 --apiserver-name localhost ${EXTRA_PARAMS}"
  sudo /usr/local/bin/minikube start --vm-driver=${DRIVER_NAME} --apiserver-ips 127.0.0.1 --apiserver-name localhost ${EXTRA_PARAMS}
}
kmstartdriver() {
  # hyperkit : https://github.com/moby/hyperkit
  usage $# "DRIVER_NAME:virtualbox|hyperkit|none" "[INSTANCE_NAME]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local DRIVER_NAME=$1
  local INSTANCE_NAME=${2:-minikube}
  local EXTRA_PARAMS=${@:3}

  kmstart ${INSTANCE_NAME} --vm-driver=${DRIVER_NAME} ${EXTRA_PARAMS}
}
# only impacts those images with no repository prefix - images that come from the Docker official registry
kmstartreg() {
  usage $# "[INSTANCE_NAME]" "[REGISTRY_URL]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

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
kmstartversion() {
  usage $# "VERSION:v1.16.2" "[INSTANCE_NAME]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "== Check release version at https://github.com/kubernetes/kubernetes/releases =="
    return 1; 
  fi

  local VERSION=$1
  local INSTANCE_NAME=${2:-minikube}
  local EXTRA_PARAMS=${@:3}

  kmstart ${INSTANCE_NAME} --kubernetes-version ${VERSION} ${EXTRA_PARAMS}
}
kmstart() {
  usage $# "[INSTANCE_NAME]" "[EXTRA_PARAMS]"

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
kmstatus() {
  usage $# "[INSTANCE_NAME]"
  kmtemplate "status" $@
}
kmhello() {
  kmsvc "hello-minikube"
}
kmsvc() {
  usage $# "SERVICE_NAME" "[INSTANCE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SERVICE_NAME=$1
  local INSTANCE_NAME=${2:-minikube}
  kmtemplate "service" ${INSTANCE_NAME} ${SERVICE_NAME} "--url"
}
kmdashboard() {
  kmtemplate "dashboard" $@
}

kmssh() {
  usage $# "[INSTANCE_NAME]" "[COMMANDS]"

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
  usage $# "[INSTANCE_NAME]"
  kmtemplate "ip" $@
}
kmlogs() {
  usage $# "[INSTANCE_NAME]"
  kmtemplate "logs" $@
}
kmstop() {
  usage $# "[INSTANCE_NAME]"
  kmtemplate "stop" $@
}
kmrm() {
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a INSTANCE_NAME you want to delete : If you don't know any names run 'kmls'" >&2
    kmls
    return 1
  fi

  kmtemplate "delete" $@
}
kmtemplate() {
  usage $# "CMD" "[CONTEXT:kcctx()]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

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
kmloadrm() {
  echo "unset MINIKUBE_DEFAULT_INSTANCE"
  unset MINIKUBE_DEFAULT_INSTANCE
  
  echo "unset EXTRA_KUBE_PARAMS"
  unset EXTRA_KUBE_PARAMS
  
  echo "rm $MINIKUBE_PERSIST_FILE"
  rm $MINIKUBE_PERSIST_FILE
}

