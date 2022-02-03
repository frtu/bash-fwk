KUBECONFIG_FILE=~/.kube/config
KUBE_FOLDER=~/.kube

# https://kubernetes.io/docs/reference/kubectl/cheatsheet/
cdkc() {
  cd ${KUBE_FOLDER}
}
kc() {
  echo "------- CLI and Server version --------";
  kubectl version
  echo "------- List contexts (or 'clusters') --------";
  kcctx 
  echo "------- Running instances --------";
  kubectl get nodes
  echo "------- Cluster Info --------";
  kubectl cluster-info
}

kchello() {
  usage $# "[IMAGE_REPOSITORY:k8s.gcr.io]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local IMAGE_REPOSITORY=${1:-k8s.gcr.io}
  kubectl create deployment hello-minikube --image=${IMAGE_REPOSITORY}/echoserver:1.10
}
# https://kind.sigs.k8s.io/docs/user/ingress/
kcingress() {
  echo "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
}
# https://kubernetes.io/docs/reference/kubectl/overview/#resource-types
kcls() {
  usage $# "[NAMESPACE]"
  echo "------- Namespaces --------";
  kclsnamespaces $@
  echo "------- Pods --------";
  kclspods $@
  echo "------- Deployment --------";
  kclsdeployments $@
  echo "------- Services --------";
  kclsservices $@
  echo "------- Ingress --------";
  kclsingress $@
  echo "------- ConfigMaps --------";
  kclsconfigmaps $@
}
kclsnamespaces() {
  echo "kubectl get namespaces $@"
  kubectl get namespaces $@
}
kclspods() {
  usage $# "[NAMESPACE]"
  kcgettemplate "pods" $@
}
kclspodsfull() {
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
kclsservices() {
  usage $# "[NAMESPACE]"
  kcgettemplate "service" $@
}
kclsdeployments() {
  usage $# "[NAMESPACE]"
  kcgettemplate "deployment" $@
}
kclsingress() {
  usage $# "[NAMESPACE]"
  kcgettemplate "ingress" $@
}
kclsevents() {
  usage $# "[NAMESPACE]"
  kcgettemplate "events" $@
}
kclsapi() {
  usage $# "[NAMESPACE]"
  kcgettemplate "apiservice" $@
}
kclsconfigmaps() {
  usage $# "[NAMESPACE]"
  kcgettemplate "configmaps" $@
}
kclsresources() {
  kubectl api-resources
}
kclsresourcesformatted() {
  for kind in `kubectl api-resources | tail +2 | awk '{ print $1 }'`; do kubectl explain $kind; done | grep -e "KIND:" -e "VERSION:"
}

alias kcinfo=kcdesc
kcdesc() {
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
kcgettemplate() {
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

kcgettpl() {
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
kclstpl() {
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
kcyaml() {
  usage $# "[RESOURCE_TYPE:deploy,sts,svc,ingress,configmap,secret]" "[RESOURCE_NAME]" "[NAMESPACE:default]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE_TYPE=${1:-pod,deploy,sts,svc,ingress,configmap,secret}
  local RESOURCE_NAME=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kcgettpl ${RESOURCE_TYPE} "yaml" ${RESOURCE_NAME} ${EXTRA_PARAMS}
}
kcyamlns() {
  usage $# "[NAMESPACE:default]" "[RESOURCE_TYPE:deploy,sts,svc,ingress,configmap,secret]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local NAMESPACE=$1
  local RESOURCE_TYPE=${2:-pod,deploy,sts,svc,ingress,configmap,secret}
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kcgettpl ${RESOURCE_TYPE} "yaml" ${RESOURCE_NAME} ${EXTRA_PARAMS}
}
kclogsns() {
  usage $# "RESOURCE_NAME" "NAMESPACE" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kclogs ${EXTRA_PARAMS} ${RESOURCE_NAME}
}
kclogs() {
  usage $# "RESOURCE_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "kubectl logs $@"
  kubectl logs $@
}
# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#container-exec
kcbash() {
  usage $# "POD_NAME" "[COMMANDS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodls'" >&2
    kcpodls
    return 1
  fi

  local POD_NAME=$1
  local COMMANDS=${2:-/bin/bash}
  local COMMANDS_ARGS=${@:3}

  kcinteractivetpl "exec" "${POD_NAME}" "-- ${COMMANDS} ${COMMANDS_ARGS}"
}
# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#container-exec
kcbashns() {
  usage $# "POD_NAME" "[CONTAINER]" "[NAMESPACE]" "[COMMANDS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodls'" >&2
    kcpodls
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

  kcinteractivetpl "exec" "${POD_NAME}" "${EXTRA_PARAMS}" "-- ${COMMANDS} ${COMMANDS_ARGS}"
}
kcbashbusybox() {
  usage $# "INSTANCE_NAME" "[NAMESPACE:default]" "[COMMANDS:/bin/sh]"

  local INSTANCE_NAME=$1
  local NAMESPACE=${2:-default}
  local COMMANDS=${3:-/bin/sh}

  kcbash "${INSTANCE_NAME}" "${INSTANCE_NAME}" "${NAMESPACE}" "${COMMANDS}"
}
# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#copying-a-pod-while-adding-a-new-container
kccrashedlogs() {
  usage $# "INSTANCE_NAME" "[NAMESPACE]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local INSTANCE_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  kclogs --previous ${EXTRA_PARAMS} ${INSTANCE_NAME}
}
kccrasheddebug() {
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

  kccrasheddebugtpl "${INSTANCE_NAME}" "${EXTRA_PARAMS}" "--share-processes"
}
kccrasheddebugsetimage() {
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

  kccrasheddebugtpl "${INSTANCE_NAME}" "${EXTRA_PARAMS}"
}
kccrasheddebugtpl() {
  usage $# "INSTANCE_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local INSTANCE_NAME=$1
  local EXTRA_PARAMS=${@:2}

  kcinteractivetpl "debug" "${INSTANCE_NAME}" "${EXTRA_PARAMS}" "--copy-to=${INSTANCE_NAME}-debug"
}
kcinteractivetpl() {
  usage $# "CMD" "POD_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local POD_NAME=$2
  local EXTRA_PARAMS=${@:3}

  echo "kubectl ${CMD} -it ${POD_NAME} ${EXTRA_PARAMS}"
  kubectl ${CMD} -it ${POD_NAME} ${EXTRA_PARAMS}
}

kcctx() {
  usage $# "[CONTEXT]"

  local CONTEXT=$1
  if [ -n "$CONTEXT" ]
    then
      kcconftemplate "use-context" ${CONTEXT}
    else
      kcconftemplate "get-contexts"
  fi
}
# Set default namespace for this context
kcctxnamespace() {
  usage $# "NAMESPACE" "[CONTEXT]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a DEFAULT namespace for the current context : If you don't know any names run 'kclsnamespaces'" >&2
    kclsnamespaces
    return 1
  fi

  local NAMESPACE=$1
  local CONTEXT=${2:---current}

  kcconftemplate "set-context ${CONTEXT} --namespace=${NAMESPACE}"
}
kcconf() {
  kcconftemplate "view"
}
kcconfcat() {
  echo "cat ${KUBECONFIG_FILE}"
  cat ${KUBECONFIG_FILE}
}
kcconftemplate() {
  usage $# "CMD"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local EXTRA_PARAMS=${@:2}

  echo "kubectl config ${CMD} ${EXTRA_PARAMS}"
  kubectl config ${CMD} ${EXTRA_PARAMS}
}

kccreate() {
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
  echo "kcctx ${NAMESPACE} : set as current namespace for all following commands"
  echo "kcbash [POD_NAME] : attach cmd to daemons"
  echo "kcpodtop [POD_NAME] : top this pod"
  echo "kcpodlogs [POD_NAME] : see logs"
  echo "---------------------";
  echo "kcattach [POD_NAME] : for daemons, attach"
  echo "kcpodtail [POD_NAME] : for daemons, tail logs"

  echo "---------------------";
  echo "kcpoddesc [POD_NAME] : get more info from this pod"

  echo "kcpodyaml [POD_NAME] : get more YAML from this pod"
  echo "kcedit [POD_NAME] [SERVICE_NAME] : edit its YAML"
  echo "kcrm [POD_NAME] : to stop and remove"
}
kcapply() {
  usage $# "FILE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local FILE_NAME=$1
  local EXTRA_PARAMS=${@:2}

  echo "kubectl apply -f ${FILE_NAME} ${EXTRA_PARAMS}"
  kubectl apply -f ${FILE_NAME} ${EXTRA_PARAMS}

  echo "------- Help --------";
  echo "kcctx ${NAMESPACE} : set as current namespace for all following commands"
  echo "kcbash [POD_NAME] : attach cmd to daemons"
  echo "kcpodtop [POD_NAME] : top this pod"
  echo "kcpodlogs [POD_NAME] : see logs"
  echo "---------------------";
  echo "kcattach [POD_NAME] : for daemons, attach"
  echo "kcpodtail [POD_NAME] : for daemons, tail logs"

  echo "---------------------";
  echo "kcpoddesc [POD_NAME] : get more info from this pod"

  echo "kcpodyaml [POD_NAME] : get more YAML from this pod"
  echo "kcedit [POD_NAME] [SERVICE_NAME] : edit its YAML"
  echo "kcrm [POD_NAME] : to stop and remove"
}

kcrunimage() {
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
  kcruntpl "run" "${INSTANCE_NAME}" "${IMAGE_NAME}" "${NAMESPACE}" --restart=Never "${ADDITIONAL_PARAMS}"
}
kcrunimagepause() {
  usage $# "INSTANCE_NAME" "[NAMESPACE:default]" "[IMAGE_NAME:busybox]" "[COMMANDS:sleep 1d]"

  local INSTANCE_NAME=$1
  local IMAGE_NAME=${2:-busybox}
  local NAMESPACE=${3:-default}
  local COMMANDS=${3:-sleep 1d}

  kcrunimage "${INSTANCE_NAME}" "${IMAGE_NAME}" "${NAMESPACE}" "${COMMANDS}"
}
kcruntpl() {
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
kcattach() {
  usage $# "POD_NAME" "[NAMESPACE]" "[CONTAINER_NAME]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kclspods'" >&2
    kclspods
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

alias kcnsls=kclsnamespaces
alias kcnslsfull='kclsnamespaces --show-labels'

alias kcnsset='kcctxnamespace'

kcnsyaml() {
  usage $# "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a namespace for the current context : If you don't know any names run 'kclsnamespaces'" >&2
    kcnspls
    return 1
  fi

  local NAMESPACE=$1
  kcnsdump ${NAMESPACE} yaml
}
kcnsjson() {
  usage $# "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a namespace for the current context : If you don't know any names run 'kclsnamespaces'" >&2
    kcnspls
    return 1
  fi

  local NAMESPACE=$1
  kcnsdump ${NAMESPACE} json
}
kcnsdump() {
  usage $# "NAMESPACE" "FORMAT:json|yaml"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a namespace for the current context : If you don't know any names run 'kclsnamespaces'" >&2
    kcnspls
    return 1
  fi

  local NAMESPACE=$1
  local FORMAT=$2
  kclsnamespaces ${NAMESPACE} -o ${FORMAT}
}

kcnscreate() {
  kcnstpl "create" $@
}
kcnsinfo() {
  kcnstpl "describe" $@
}
kcnsvi() {
  kcnstpl "edit" $@
}
kcnsrm() {
  kcnstpl "delete" $@
  kcnsls
}
kcnstpl() {
  usage $# "CMD" "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a namespace for the current context : If you don't know any names run 'kclsnamespaces'" >&2
    kcnspls
    return 1
  fi

  local CMD=$1
  local NAMESPACE=$2

  echo "kubectl ${CMD} namespace ${NAMESPACE} ${@:3}"
  kubectl ${CMD} namespace ${NAMESPACE} ${@:3}
}

alias kcpodls='kclstpl pod '
alias kcpodyaml='kcyaml pod '
alias kcpoddesc='kcdesc pod '
alias kcpodinfo=kcpoddesc

kcpodid() {
  usage $# "POD_NAME" "[NAMESPACE]"
  kcpoddesc $@ | grep 'Container ID'
}
kcpodlabel() {
  echo "kubectl get pods $@ --show-labels"
  kubectl get pods $@ --show-labels
}
kcpodenv() {
  usage $# "POD_NAME" "[CONTAINING_TEXT]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodls'" >&2
    kcpodls
    return 1
  fi

  local POD_NAME=$1
  local CONTAINING_TEXT=${@:2}

  if [ -z "$CONTAINING_TEXT" ]; then
      kcbash "${POD_NAME}" "env"
    else
      kcbash "${POD_NAME}" "env"  | grep ${CONTAINING_TEXT}
  fi
}

# Interaction
kcpodcp() {
  usage $# "SOURCE" "DESTINATION"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SOURCE=$1
  local DESTINATION=$2

  echo "kubectl cp ${SOURCE} ${DESTINATION}"
  kubectl cp ${SOURCE} ${DESTINATION}
}
kcpodcpfrom() {
  usage $# "POD_FULL_NAME:<namespace>/<pod>" "SOURCE_PATH" "DESTINATION_PATH"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local SOURCE_PATH=$1
  local DESTINATION_PATH=$2

  kcpodcp ${POD_NAME}:${SOURCE_PATH} ${DESTINATION_PATH}
}
kcpodcpto() {
  usage $# "POD_FULL_NAME:<namespace>/<pod>" "SOURCE_PATH" "DESTINATION_PATH"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local SOURCE_PATH=$1
  local DESTINATION_PATH=$2

  kcpodcp ${SOURCE_PATH} ${POD_NAME}:${DESTINATION_PATH}
}
kcpodrun() {
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
  kcruntpl "run --generator=run-pod/v1" "${INSTANCE_NAME}" "${IMAGE_NAME}" "${NAMESPACE}" "${EXTRA_PARAMS}"
}

alias kcpodlogs=kclogs
kcpodtail() {
  usage $# "POD_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kclspods'" >&2
    return 1
  fi

  kclogs $@ -f
}
kcpodtop() {
  usage $# "POD_NAME"
  kcpodtemplate "top" $@
}
kcpodrm() {
  usage $# "POD_NAME" "[NAMESPACE]"
  kcpodtemplate "delete" $@
}
kcpodtemplate() {
  usage $# "CMD" "POD_NAME" "[NAMESPACE]" "[EXTRA_PARAMS]"

  local CMD=$1
  local POD_NAME=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi
  kcpodtpl ${CMD} ${POD_NAME} ${EXTRA_PARAMS}
}
kcpodtpl() {
  usage $# "CMD" "POD_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    return 1
  fi

  local CMD=$1
  local POD_NAME=$2
  local EXTRA_PARAMS=${@:3}

  echo "kubectl ${CMD} pod ${POD_NAME} ${EXTRA_PARAMS}"
  kubectl ${CMD} pod ${POD_NAME} ${EXTRA_PARAMS}
}

alias kcsvcls='kclstpl svc '
alias kcsvcyaml='kcyaml svc '
alias kcsvcdesc='kcdesc svc '
kcsvschk() {
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
kcsvcrm() {
  usage $# "SERVICE_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a service name from a namespace: If you don't know any service names run 'kcsvcls'" >&2
    return 1
  fi

  local SERVICE_NAME=$1
  local NAMESPACE=$2

  kcsvctpl "delete" "${SERVICE_NAME}" "${NAMESPACE}" ${@:3}
}
kcsvctpl() {
  usage $# "CMD" "SERVICE_NAME" "NAMESPACE" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a service name from a namespace: If you don't know any service names run 'kcsvcls'" >&2
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
alias kcingls='kclstpl ingress '
alias kcingyaml='kcyaml ingress'
alias kcingdesc='kcdesc ingress '

alias kcdpls='kclstpl deployment '
alias kcdpyaml='kcyaml deployment'
alias kcdpdesc='kcdesc deployment '
alias kcdpinfo=kcdpdesc
# https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/
kcdprun() {
  usage $# "DEPLOYMENT_NAME" "IMAGE_NAME" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  kcruntpl "create deployment" $@
}
kcdpexpose() {
  usage $# "DEPLOYMENT_NAME" "SERVICE_NAME" "PORT" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a deployment name from a namespace: If you don't know any pod names run 'kclsdeployments'" >&2
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
  kcdptpl "expose" "${DEPLOYMENT_NAME}" "${NAMESPACE}" "--name=${SERVICE_NAME}" "${EXTRA_PARAMS}"
}
kcdprm() {
  usage $# "DEPLOYMENT_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a deployment name from a namespace: If you don't know any pod names run 'kclsdeployments'" >&2
    return 1
  fi

  local DEPLOYMENT_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}
  kcdptpl "delete" "${DEPLOYMENT_NAME}" "${NAMESPACE}"
}
kcdptpl() {
  usage $# "CMD" "DEPLOYMENT_NAME" "NAMESPACE" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcdpls'" >&2
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
kcportfwd() {
  usage $# "POD_NAME|SERVICE_NAME|DEPLOYMENT:service/xx|deployment/yy" "PORT_MAPPING-8080:80" "[NAMESPACE]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    kcpodlsfull
    return 1
  fi

  local POD_NAME=$1
  local PORT_MAPPING=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  # https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/
  echo "kubectl port-forward ${POD_NAME} ${EXTRA_PARAMS} ${PORT_MAPPING}"
  kubectl port-forward ${POD_NAME} ${EXTRA_PARAMS} ${PORT_MAPPING}
}
# https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#proxy
kcproxy() {
  usage $# "[POD_NAME]" "[PORT:8001]" "[NAMESPACE]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    kcpodlsfull
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

kcnetlookup() {
  usage $# "DOMAIN_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  kcexec nslookup $@
}
kcexec() {
  usage $# "CMD"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "kubectl exec -ti busybox -- $@"
  kubectl exec -ti busybox -- $@
}

kcedit() {
  usage $# "RESOURCE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE=$1

  echo "kubectl edit ${RESOURCE}"
  kubectl edit ${RESOURCE}
}
kcrm() {
  usage $# "RESOURCE" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a POD or SERVICE name: If you don't know any pod names run 'kclspods' or 'kclsservices'" >&2
    return 1
  fi

  local RESOURCE=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  echo "kubectl delete pod,deployment,service,ingress ${RESOURCE} ${EXTRA_PARAMS}"
  kubectl delete pod,deployment,service,ingress ${RESOURCE} ${EXTRA_PARAMS}
}
kcrmall() {
  usage $# "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a NAMESPACE for the current context : If you don't know any names run 'kclsnamespaces'" >&2
    kclsnamespaces
    return 1
  fi

  local NAMESPACE=$1

  echo "kubectl -n ${NAMESPACE} delete po,deployment,svc,ingress --all "
  kubectl -n ${NAMESPACE} delete po,deployment,svc,ingress --all 
}
