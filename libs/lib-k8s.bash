KUBECONFIG_FILE=~/.kube/config
KUBE_FOLDER=~/.kube

alias k='kubectl'

# https://kubernetes.io/docs/reference/kubectl/cheatsheet/
cdk() {
  cd ${KUBE_FOLDER}
}
kc() {
  echo "------- CLI and Server version --------";
  kubectl version
  echo "------- List contexts (or 'clusters') --------";
  kctx 
  echo "------- Running instances --------";
  kubectl get nodes
  echo "------- Cluster Info --------";
  kubectl cluster-info
}

khello() {
  usage $# "[IMAGE_REPOSITORY:k8s.gcr.io]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local IMAGE_REPOSITORY=${1:-k8s.gcr.io}
  kubectl create deployment hello-minikube --image=${IMAGE_REPOSITORY}/echoserver:1.10
}
# https://kind.sigs.k8s.io/docs/user/ingress/
kingress() {
  echo "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
}
# https://kubernetes.io/docs/reference/kubectl/overview/#resource-types
kls() {
  usage $# "[NAMESPACE]"
  echo "------- Namespaces --------";
  klsnamespaces $@
  echo "------- Pods --------";
  klspods $@
  echo "------- Deployment --------";
  klsdeployments $@
  echo "------- Services --------";
  klsservices $@
  echo "------- PersistentVolumeClaim --------";
  klspvc $@
  echo "------- Ingress --------";
  klsingress $@
  echo "------- ConfigMap --------";
  klsconfigmap $@
}
klsnamespaces() {
  echo "kubectl get namespaces $@"
  kubectl get namespaces $@
}
klspods() {
  usage $# "[NAMESPACE]"
  kgettpl "pods" $@
}
klspodsfull() {
  usage $# "[NAMESPACE]" "[OPTION:wide|yaml]"

  local NAMESPACE=$1
  local OPTION=$2
  local ADDITIONAL_PARAMS=${@:3}
  
  if [ -n "$NAMESPACE" ]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
    else
      local EXTRA_PARAMS="$EXTRA_PARAMS --all-namespaces"
  fi

  if [ -n "$OPTION" ]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS -o $OPTION"
    else
      local EXTRA_PARAMS="$EXTRA_PARAMS -o wide"
  fi

  echo "kubectl get pods ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}"
  kubectl get pods ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}
}
klsservices() {
  usage $# "[NAMESPACE]"
  kgettpl "service" $@
}
klsdeployments() {
  usage $# "[NAMESPACE]"
  kgettpl "deployment" $@
}
klspvc() {
  usage $# "[NAMESPACE]"
  kgettpl "pvc" $@
}
klsingress() {
  usage $# "[NAMESPACE]"
  kgettpl "ingress" $@
}
# https://istio.io/latest/docs/concepts/traffic-management/
klsvs() {
  usage $# "[NAMESPACE]"
  kgettpl "ingress" $@
}
klsevents() {
  usage $# "[NAMESPACE]"
  kgettpl "events" $@
}
klsapi() {
  usage $# "[NAMESPACE]"
  kgettpl "apiservice" $@
}
klsconfigmap() {
  usage $# "[NAMESPACE]"
  kgettpl "configmap" $@
}
klsresources() {
  kubectl api-resources
}
klsresourcesformatted() {
  for kind in `kubectl api-resources | tail +2 | awk '{ print $1 }'`; do kubectl explain $kind; done | grep -e "KIND:" -e "VERSION:"
}

alias kinfo=kdesc
kdesc() {
  usage $# "RESOURCE_TYPE" "RESOURCE_NAME" "[NAMESPACE]"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE_TYPE=$1
  local RESOURCE_NAME=$2
  local NAMESPACE=$3
  local ADDITIONAL_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl describe ${RESOURCE_TYPE} ${RESOURCE_NAME} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}"
  kubectl describe ${RESOURCE_TYPE} ${RESOURCE_NAME} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}
}
kgettpl() {
  usage $# "RESOURCE_TYPE" "[NAMESPACE]" "[OPTION:wide|yaml]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE_TYPE=$1
  local NAMESPACE=$2
  local OPTION=$3
  local ADDITIONAL_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
    else
      local EXTRA_PARAMS="$EXTRA_PARAMS --all-namespaces"
  fi
  if [ -n "$OPTION" ]; then
      local EXTRA_PARAMS="$EXTRA_PARAMS -o $OPTION"
  fi

  echo "kubectl get ${RESOURCE_TYPE} ${ADDITIONAL_PARAMS} ${EXTRA_PARAMS}"
  kubectl get ${RESOURCE_TYPE} ${ADDITIONAL_PARAMS} ${EXTRA_PARAMS}
}

kgettpl() {
  usage $# "RESOURCE_TYPE" "[OPTION:wide|yaml]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE_TYPE=$1
  local OPTION=$2
  local ADDITIONAL_PARAMS=${@:3}
  
  if [ -n "$OPTION" ]; then
      local EXTRA_PARAMS="$EXTRA_PARAMS -o $OPTION"
  fi

  echo "kubectl get ${RESOURCE_TYPE} ${ADDITIONAL_PARAMS} ${EXTRA_PARAMS}"
  kubectl get ${RESOURCE_TYPE} ${ADDITIONAL_PARAMS} ${EXTRA_PARAMS}
}
klstpl() {
  usage $# "RESOURCE_TYPE" "[CONTAINING_TEXT]" "[CONTAINING_TEXT]" "[NAMESPACE]"

  local RESOURCE_TYPE=$1
  local CONTAINING_TEXT=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi
  if [ -z "$CONTAINING_TEXT" ]; then
      echo "kubectl get ${RESOURCE_TYPE} ${EXTRA_PARAMS}"
      kubectl get ${RESOURCE_TYPE} ${EXTRA_PARAMS}
    else
      echo "== List all existing ${RESOURCE_TYPE} containing [${CONTAINING_TEXT}] =="
      echo "kubectl get ${RESOURCE_TYPE} ${EXTRA_PARAMS} | grep ${CONTAINING_TEXT}"
      kubectl get ${RESOURCE_TYPE} ${EXTRA_PARAMS} | grep ${CONTAINING_TEXT}
  fi
}
kyaml() {
  usage $# "[RESOURCE_TYPE:deploy,sts,svc,ingress,vs,configmap,secret]" "[RESOURCE_NAME]" "[NAMESPACE:default]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE_TYPE=${1:-pod,deploy,sts,svc,ingress,vs,configmap,secret}
  local RESOURCE_NAME=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kgettpl ${RESOURCE_TYPE} "yaml" ${RESOURCE_NAME} ${EXTRA_PARAMS}
}
kyamlns() {
  usage $# "[NAMESPACE:default]" "[RESOURCE_TYPE:deploy,sts,svc,ingress,vs,configmap,secret]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local NAMESPACE=$1
  local RESOURCE_TYPE=${2:-pod,deploy,sts,svc,ingress,vs,configmap,secret}
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kgettpl ${RESOURCE_TYPE} "yaml" ${RESOURCE_NAME} ${EXTRA_PARAMS}
}
klogsns() {
  usage $# "RESOURCE_NAME" "NAMESPACE" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  klogs ${EXTRA_PARAMS} ${RESOURCE_NAME}
}
klogs() {
  usage $# "RESOURCE_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "kubectl logs $@"
  kubectl logs $@
}
# Interaction
kcpfrom() {
  usage $# "POD_NAME" "SOURCE_FOLDER" "DESTINATION_FOLDER"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local POD_NAME=$1
  local SOURCE_FOLDER=$1
  local DESTINATION_FOLDER=$2

  kcp "${POD_NAME}:${SOURCE_FOLDER}" "${DESTINATION_FOLDER}"
}
kcpto() {
  usage $# "POD_NAME" "SOURCE_FOLDER" "DESTINATION_FOLDER"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local POD_NAME=$1
  local SOURCE_FOLDER=$1
  local DESTINATION_FOLDER=$2

  kcp "${SOURCE_FOLDER}" "${POD_NAME}:${DESTINATION_FOLDER}"
}
kcp() {
  usage $# "SOURCE" "DESTINATION"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SOURCE=$1
  local DESTINATION=$2
  local EXTRA_PARAMS=${@:3}

  echo "= Please make sure tar is installed in your image ="
  echo "kubectl cp ${SOURCE} ${DESTINATION} ${EXTRA_PARAMS}"
  kubectl cp ${SOURCE} ${DESTINATION} ${EXTRA_PARAMS}
}
# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#container-exec
kbash() {
  usage $# "POD_NAME" "[COMMANDS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kpodls'" >&2
    kpodls
    return 1
  fi

  local POD_NAME=$1
  local COMMANDS=${2:-/bin/bash}
  local COMMANDS_ARGS=${@:3}

  kinteractivetpl "exec" "${POD_NAME}" "-- ${COMMANDS} ${COMMANDS_ARGS}"
}
kbashsudo() {
  usage $# "USER_NAME" "POD_NAME" "[COMMANDS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kpodls'" >&2
    kpodls
    return 1
  fi

  local USER_NAME=$1
  local POD_NAME=$2
  local COMMANDS=${3:-/bin/bash}
  local COMMANDS_ARGS=${@:4}

  kinteractivetpl "exec" "${POD_NAME}" "-- gosu ${USER_NAME} ${COMMANDS} ${COMMANDS_ARGS}"
}
# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#container-exec
kbashns() {
  usage $# "POD_NAME" "[CONTAINER]" "[NAMESPACE]" "[COMMANDS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kpodls'" >&2
    kpodls
    return 1
  fi

  local POD_NAME=$1
  local CONTAINER=$2
  local NAMESPACE=$3
  local COMMANDS=${4:-/bin/bash}
  local COMMANDS_ARGS=${@:5}

  if [ -n "$CONTAINER" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -c ${CONTAINER}"
  fi
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kinteractivetpl "exec" "${POD_NAME}" "${EXTRA_PARAMS}" "-- ${COMMANDS} ${COMMANDS_ARGS}"
}
kbashbusybox() {
  usage $# "INSTANCE_NAME" "[NAMESPACE:default]" "[COMMANDS:/bin/sh]"

  local INSTANCE_NAME=$1
  local NAMESPACE=${2:-default}
  local COMMANDS=${3:-/bin/sh}

  kbash "${INSTANCE_NAME}" "${INSTANCE_NAME}" "${NAMESPACE}" "${COMMANDS}"
}
# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#copying-a-pod-while-adding-a-new-container
kcrashedlogs() {
  usage $# "INSTANCE_NAME" "[NAMESPACE]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local INSTANCE_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  klogs --previous ${EXTRA_PARAMS} ${INSTANCE_NAME}
}
kcrasheddebug() {
  usage $# "INSTANCE_NAME" "[IMAGE:ubuntu]" "[NAMESPACE]" "[EXTRA_PARAMS]"

  local INSTANCE_NAME=$1
  local IMAGE=${2:-ubuntu}
  local NAMESPACE=${3:-default}
  local EXTRA_PARAMS=${@:3}

  if [ -n "$IMAGE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --image=${IMAGE}"
  fi
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kcrasheddebugtpl "${INSTANCE_NAME}" "${EXTRA_PARAMS}" "--share-processes"
}
kcrasheddebugsetimage() {
  usage $# "INSTANCE_NAME" "[SET_IMAGE:ubuntu]" "[NAMESPACE]" "[EXTRA_PARAMS]"

  local INSTANCE_NAME=$1
  local SET_IMAGE=${2:-ubuntu}
  local NAMESPACE=${3:-default}
  local EXTRA_PARAMS=${@:3}

  if [ -n "$SET_IMAGE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --set-image=*=${SET_IMAGE}"
  fi
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kcrasheddebugtpl "${INSTANCE_NAME}" "${EXTRA_PARAMS}"
}
kcrasheddebugtpl() {
  usage $# "INSTANCE_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local INSTANCE_NAME=$1
  local EXTRA_PARAMS=${@:2}

  kinteractivetpl "debug" "${INSTANCE_NAME}" "${EXTRA_PARAMS}" "--copy-to=${INSTANCE_NAME}-debug"
}
kinteractivetpl() {
  usage $# "CMD" "POD_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local POD_NAME=$2
  local EXTRA_PARAMS=${@:3}

  echo "kubectl ${CMD} -it ${POD_NAME} ${EXTRA_PARAMS}"
  kubectl ${CMD} -it ${POD_NAME} ${EXTRA_PARAMS}
}

kctx() {
  usage $# "[CONTEXT]"

  local CONTEXT=$1
  if [ -n "$CONTEXT" ]
    then
      kconftemplate "use-context" ${CONTEXT}
    else
      kconftemplate "get-contexts"
  fi
}
# Set default namespace for this context
kctxnamespace() {
  usage $# "NAMESPACE" "[CONTEXT]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a DEFAULT namespace for the current context : If you don't know any names run 'klsnamespaces'" >&2
    klsnamespaces
    return 1
  fi

  local NAMESPACE=$1
  local CONTEXT=${2:---current}

  kconftemplate "set-context ${CONTEXT} --namespace=${NAMESPACE}"
}
kconf() {
  kconftemplate "view"
}
kconfcat() {
  echo "cat ${KUBECONFIG_FILE}"
  cat ${KUBECONFIG_FILE}
}
kconftemplate() {
  usage $# "CMD"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local EXTRA_PARAMS=${@:2}

  echo "kubectl config ${CMD} ${EXTRA_PARAMS}"
  kubectl config ${CMD} ${EXTRA_PARAMS}
}

kcreate() {
  usage $# "FILE_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local FILE_NAME=$1
  local NAMESPACE=$2
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl create -f ${FILE_NAME} ${EXTRA_PARAMS}"
  kubectl create -f ${FILE_NAME} ${EXTRA_PARAMS}

  echo "------- Help --------";
  echo "kctx ${NAMESPACE} : set as current namespace for all following commands"
  echo "kbash [POD_NAME] : attach cmd to daemons"
  echo "kpodtop [POD_NAME] : top this pod"
  echo "kpodlogs [POD_NAME] : see logs"
  echo "---------------------";
  echo "kattach [POD_NAME] : for daemons, attach"
  echo "kpodtail [POD_NAME] : for daemons, tail logs"

  echo "---------------------";
  echo "kpoddesc [POD_NAME] : get more info from this pod"

  echo "kpodyaml [POD_NAME] : get more YAML from this pod"
  echo "kedit [POD_NAME] [SERVICE_NAME] : edit its YAML"
  echo "krm [POD_NAME] : to stop and remove"
}
kapply() {
  usage $# "FILE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local FILE_NAME=$1
  local EXTRA_PARAMS=${@:2}

  echo "kubectl apply -f ${FILE_NAME} ${EXTRA_PARAMS}"
  kubectl apply -f ${FILE_NAME} ${EXTRA_PARAMS}

  echo "------- Help --------";
  echo "kctx ${NAMESPACE} : set as current namespace for all following commands"
  echo "kbash [POD_NAME] : attach cmd to daemons"
  echo "kpodtop [POD_NAME] : top this pod"
  echo "kpodlogs [POD_NAME] : see logs"
  echo "---------------------";
  echo "kattach [POD_NAME] : for daemons, attach"
  echo "kpodtail [POD_NAME] : for daemons, tail logs"

  echo "---------------------";
  echo "kpoddesc [POD_NAME] : get more info from this pod"

  echo "kpodyaml [POD_NAME] : get more YAML from this pod"
  echo "kedit [POD_NAME] [SERVICE_NAME] : edit its YAML"
  echo "krm [POD_NAME] : to stop and remove"
}

krunimage() {
  usage $# "INSTANCE_NAME" "[IMAGE_NAME:busybox]" "[NAMESPACE:default]" "[COMMANDS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local INSTANCE_NAME=$1
  local IMAGE_NAME=${2:-busybox}
  local NAMESPACE=${3:-default}
  local COMMANDS=${@:4}

  if [ -n "$COMMANDS" ]; then
    local ADDITIONAL_PARAMS="$ADDITIONAL_PARAMS -- ${COMMANDS}"
  fi

  # https://kubernetes.io/docs/reference/kubectl/conventions/#generators
  kruntpl "run" "${INSTANCE_NAME}" "${IMAGE_NAME}" "${NAMESPACE}" --restart=Never "${ADDITIONAL_PARAMS}"
}
krunimagepause() {
  usage $# "INSTANCE_NAME" "[NAMESPACE:default]" "[IMAGE_NAME:busybox]" "[COMMANDS:sleep 1d]"

  local INSTANCE_NAME=$1
  local IMAGE_NAME=${2:-busybox}
  local NAMESPACE=${3:-default}
  local COMMANDS=${3:-sleep 1d}

  krunimage "${INSTANCE_NAME}" "${IMAGE_NAME}" "${NAMESPACE}" "${COMMANDS}"
}
kruntpl() {
  usage $# "CMD" "INSTANCE_NAME" "[IMAGE_NAME]" "[NAMESPACE]" "[ADDITIONAL_PARAMS:--dry-run]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local INSTANCE_NAME=$2
  local IMAGE_NAME=$3
  local NAMESPACE=$4
  local ADDITIONAL_PARAMS=${@:5}

  if [ -n "$IMAGE_NAME" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --image=${IMAGE_NAME}"
  fi
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  # https://kubernetes.io/docs/reference/kubectl/conventions/#generators
  # https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/#docker-run
  echo "kubectl ${CMD} ${EXTRA_PARAMS} ${INSTANCE_NAME} ${ADDITIONAL_PARAMS}"
  kubectl ${CMD} ${EXTRA_PARAMS} ${INSTANCE_NAME} ${ADDITIONAL_PARAMS}
}
kattach() {
  usage $# "POD_NAME" "[NAMESPACE]" "[CONTAINER_NAME]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'klspods'" >&2
    klspods
    return 1
  fi

  local POD_NAME=$1
  local NAMESPACE=$2
  local CONTAINER_NAME=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi
  if [ -n "$CONTAINER_NAME" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -c ${CONTAINER_NAME}"
  fi
  
  # https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/#docker-attach
  echo "kubectl attach -it ${POD_NAME} ${EXTRA_PARAMS}"
  kubectl attach -it ${POD_NAME} ${EXTRA_PARAMS}
}

alias knsls=klsnamespaces
alias knslsfull='klsnamespaces --show-labels'

alias knsset='kctxnamespace'

knsyaml() {
  usage $# "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a namespace for the current context : If you don't know any names run 'klsnamespaces'" >&2
    knspls
    return 1
  fi

  local NAMESPACE=$1
  knsdump ${NAMESPACE} yaml
}
knsjson() {
  usage $# "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a namespace for the current context : If you don't know any names run 'klsnamespaces'" >&2
    knspls
    return 1
  fi

  local NAMESPACE=$1
  knsdump ${NAMESPACE} json
}
knsdump() {
  usage $# "NAMESPACE" "FORMAT:json|yaml"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a namespace for the current context : If you don't know any names run 'klsnamespaces'" >&2
    knspls
    return 1
  fi

  local NAMESPACE=$1
  local FORMAT=$2
  klsnamespaces ${NAMESPACE} -o ${FORMAT}
}

knscreate() {
  knstpl "create" $@
}
knsinfo() {
  knstpl "describe" $@
}
knsvi() {
  knstpl "edit" $@
}
knsrm() {
  knstpl "delete" $@
  knsls
}
knstpl() {
  usage $# "CMD" "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a namespace for the current context : If you don't know any names run 'klsnamespaces'" >&2
    knspls
    return 1
  fi

  local CMD=$1
  local NAMESPACE=$2

  echo "kubectl ${CMD} namespace ${NAMESPACE} ${@:3}"
  kubectl ${CMD} namespace ${NAMESPACE} ${@:3}
}

alias kpodls='klstpl pod '
alias kpodyaml='kyaml pod '
alias kpoddesc='kdesc pod '
alias kpodinfo=kpoddesc

kpodid() {
  usage $# "POD_NAME" "[NAMESPACE]"
  kpoddesc $@ | grep 'Container ID'
}
kpodlabel() {
  echo "kubectl get pods $@ --show-labels"
  kubectl get pods $@ --show-labels
}
kpodenv() {
  usage $# "POD_NAME" "[CONTAINING_TEXT]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kpodls'" >&2
    kpodls
    return 1
  fi

  local POD_NAME=$1
  local CONTAINING_TEXT=${@:2}

  if [ -z "$CONTAINING_TEXT" ]; then
      kbash "${POD_NAME}" "env"
    else
      kbash "${POD_NAME}" "env"  | grep ${CONTAINING_TEXT}
  fi
}

# Interaction
kpodcp() {
  usage $# "SOURCE" "DESTINATION"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SOURCE=$1
  local DESTINATION=$2

  echo "kubectl cp ${SOURCE} ${DESTINATION}"
  kubectl cp ${SOURCE} ${DESTINATION}
}
kpodcpfrom() {
  usage $# "POD_FULL_NAME:<namespace>/<pod>" "SOURCE_PATH" "DESTINATION_PATH"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local SOURCE_PATH=$1
  local DESTINATION_PATH=$2

  kpodcp ${POD_NAME}:${SOURCE_PATH} ${DESTINATION_PATH}
}
kpodcpto() {
  usage $# "POD_FULL_NAME:<namespace>/<pod>" "SOURCE_PATH" "DESTINATION_PATH"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local SOURCE_PATH=$1
  local DESTINATION_PATH=$2

  kpodcp ${SOURCE_PATH} ${POD_NAME}:${DESTINATION_PATH}
}
kpodrun() {
  usage $# "IMAGE_NAME" "INSTANCE_NAME" "[NAMESPACE]" "[PORT]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local IMAGE_NAME=$1
  local INSTANCE_NAME=$2
  local NAMESPACE=$3
  local PORT=$4

  if [ -n "$PORT" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --port $PORT"
  fi

  # https://kubernetes.io/docs/reference/kubectl/conventions/#generators
  kruntpl "run --generator=run-pod/v1" "${INSTANCE_NAME}" "${IMAGE_NAME}" "${NAMESPACE}" "${EXTRA_PARAMS}"
}

alias kpodlogs=klogs
kpodtail() {
  usage $# "POD_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'klspods'" >&2
    return 1
  fi

  klogs $@ -f
}
kpodtop() {
  usage $# "POD_NAME"
  kpodtemplate "top" $@
}
kpodrm() {
  usage $# "POD_NAME" "[NAMESPACE]"
  kpodtemplate "delete" $@
}
kpodtemplate() {
  usage $# "CMD" "POD_NAME" "[NAMESPACE]" "[EXTRA_PARAMS]"

  local CMD=$1
  local POD_NAME=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi
  kpodtpl ${CMD} ${POD_NAME} ${EXTRA_PARAMS}
}
kpodtpl() {
  usage $# "CMD" "POD_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kpodlsfull'" >&2
    return 1
  fi

  local CMD=$1
  local POD_NAME=$2
  local EXTRA_PARAMS=${@:3}

  echo "kubectl ${CMD} pod ${POD_NAME} ${EXTRA_PARAMS}"
  kubectl ${CMD} pod ${POD_NAME} ${EXTRA_PARAMS}
}

alias ksvcls='klstpl svc '
alias ksvcyaml='kyaml svc '
alias ksvcdesc='kdesc svc '
ksvcchk() {
  usage $# "SERVICE_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SERVICE_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl rollout status sts/${SERVICE_NAME} ${EXTRA_PARAMS}"
  kubectl rollout status sts/${SERVICE_NAME} ${EXTRA_PARAMS}
}
ksvcrm() {
  usage $# "SERVICE_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a service name from a namespace: If you don't know any service names run 'ksvcls'" >&2
    return 1
  fi

  local SERVICE_NAME=$1
  local NAMESPACE=$2

  ksvctpl "delete" "${SERVICE_NAME}" "${NAMESPACE}" ${@:3}
}
ksvctpl() {
  usage $# "CMD" "SERVICE_NAME" "NAMESPACE" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a service name from a namespace: If you don't know any service names run 'ksvcls'" >&2
    return 1
  fi

  local CMD=$1
  local SERVICE_NAME=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl ${CMD} service ${SERVICE_NAME} ${EXTRA_PARAMS}"
  kubectl ${CMD} service ${SERVICE_NAME} ${EXTRA_PARAMS}
}
alias kingls='klstpl ingress '
alias kingyaml='kyaml ingress'
alias kingdesc='kdesc ingress '

alias kvsls='klstpl vs '
alias kvsyaml='kyaml vs '
alias kvsdesc='kdesc vs '
kvsrm() {
  usage $# "VIRTUALSERVICE_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a service name from a namespace: If you don't know any service names run 'ksvcls'" >&2
    return 1
  fi

  local VIRTUALSERVICE_NAME=$1
  local NAMESPACE=$2

  ksvctpl "delete" "${VIRTUALSERVICE_NAME}" "${NAMESPACE}" ${@:3}
}
kvstpl() {
  usage $# "CMD" "VIRTUALSERVICE_NAME" "NAMESPACE" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a service name from a namespace: If you don't know any service names run 'ksvcls'" >&2
    return 1
  fi

  local CMD=$1
  local VIRTUALSERVICE_NAME=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl ${CMD} vs ${VIRTUALSERVICE_NAME} ${EXTRA_PARAMS}"
  kubectl ${CMD} vs ${VIRTUALSERVICE_NAME} ${EXTRA_PARAMS}
}

alias kconfigmapls='klstpl configmap '
alias kconfigmapyaml='kyaml configmap'
alias kconfigmapdesc='kdesc configmap '

alias kdpls='klstpl deployment '
alias kdpyaml='kyaml deployment'
alias kdpdesc='kdesc deployment '
alias kdpinfo=kdpdesc
# https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/
kdprun() {
  usage $# "DEPLOYMENT_NAME" "IMAGE_NAME" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  kruntpl "create deployment" $@
}
kdpexpose() {
  usage $# "DEPLOYMENT_NAME" "SERVICE_NAME" "PORT" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a deployment name from a namespace: If you don't know any pod names run 'klsdeployments'" >&2
    return 1
  fi

  local DEPLOYMENT_NAME=$1
  local SERVICE_NAME=$2
  local PORT=$3
  local NAMESPACE=$4
  local EXTRA_PARAMS=${@:5}

  if [ -n "$PORT" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --port $PORT"
  fi

  # expose a port through a service
  kdptpl "expose" "${DEPLOYMENT_NAME}" "${NAMESPACE}" "--name=${SERVICE_NAME}" "${EXTRA_PARAMS}"
}
kdprm() {
  usage $# "DEPLOYMENT_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a deployment name from a namespace: If you don't know any pod names run 'klsdeployments'" >&2
    return 1
  fi

  local DEPLOYMENT_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}
  kdptpl "delete" "${DEPLOYMENT_NAME}" "${NAMESPACE}"
}
kdptpl() {
  usage $# "CMD" "DEPLOYMENT_NAME" "NAMESPACE" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kdpls'" >&2
    return 1
  fi

  local CMD=$1
  local DEPLOYMENT_NAME=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl ${CMD} deployment ${DEPLOYMENT_NAME} ${EXTRA_PARAMS}"
  kubectl ${CMD} deployment ${DEPLOYMENT_NAME} ${EXTRA_PARAMS}
}

# https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#port-forward
kportfwd() {
  usage $# "POD_NAME|SERVICE_NAME|DEPLOYMENT:service/xx|deployment/yy" "PORT_MAPPING-8080:80" "[EXPOSED_IP]" "[NAMESPACE]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kpodlsfull'" >&2
    kpodlsfull
    return 1
  fi

  local POD_NAME=$1
  local PORT_MAPPING=$2
  local EXPOSED_IP=$3
  local NAMESPACE=$4
  local EXTRA_PARAMS=${@:5}
  
  if [ -n "$EXPOSED_IP" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --address localhost,${EXPOSED_IP}"
  fi
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  # https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/
  echo "kubectl port-forward ${POD_NAME} ${EXTRA_PARAMS} ${PORT_MAPPING}"
  kubectl port-forward ${POD_NAME} ${EXTRA_PARAMS} ${PORT_MAPPING}
}
# https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#proxy
kproxy() {
  usage $# "[POD_NAME]" "[PORT:8001]" "[NAMESPACE]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kpodlsfull'" >&2
    kpodlsfull
    return 1
  fi

  local POD_NAME=$1
  local PORT=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$PORT" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --port=${PORT}"
  fi
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl proxy ${POD_NAME} ${EXTRA_PARAMS}"
  kubectl proxy ${POD_NAME} ${EXTRA_PARAMS}
}

knetlookup() {
  usage $# "DOMAIN_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  kexec nslookup $@
}
kexec() {
  usage $# "CMD"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "kubectl exec -ti busybox -- $@"
  kubectl exec -ti busybox -- $@
}

kedit() {
  usage $# "RESOURCE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE=$1

  echo "kubectl edit ${RESOURCE}"
  kubectl edit ${RESOURCE}
}
krm() {
  usage $# "RESOURCE" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a POD or SERVICE name: If you don't know any pod names run 'klspods' or 'klsservices'" >&2
    return 1
  fi

  local RESOURCE=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl delete pod,deployment,service,ingress,secret ${RESOURCE} ${EXTRA_PARAMS}"
  kubectl delete pod,deployment,service,ingress,secret ${RESOURCE} ${EXTRA_PARAMS}
}
krmall() {
  usage $# "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a NAMESPACE for the current context : If you don't know any names run 'klsnamespaces'" >&2
    klsnamespaces
    return 1
  fi

  local NAMESPACE=$1

  echo "kubectl -n ${NAMESPACE} delete po,deployment,svc,ingress --all "
  kubectl -n ${NAMESPACE} delete po,deployment,svc,ingress --all 
}
