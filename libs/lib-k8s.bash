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
# https://kubernetes.io/docs/reference/kubectl/overview/#resource-types
kcls() {
  usage $# "[NAMESPACE]"
  echo "------- Namespaces --------";
  kclsnamespaces $@
  echo "------- Pods --------";
  kclspods $@
  echo "------- Services --------";
  kclsservices $@
  echo "------- Deployment --------";
  kclsdeployments $@
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
kclsevents() {
  usage $# "[NAMESPACE]"
  kcgettemplate "events" $@
}
kclsapi() {
  usage $# "[NAMESPACE]"
  kcgettemplate "apiservice" $@
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
  
  if [ -n "$NAMESPACE" ]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
    else
      local EXTRA_PARAMS="$EXTRA_PARAMS --all-namespaces"
  fi

  echo "kubectl describe ${RESOURCE_TYPE} ${RESOURCE_NAME} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}"
  kubectl describe ${RESOURCE_TYPE} ${RESOURCE_NAME} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}
}
kcgettemplate() {
  usage $# "RESOURCE" "[NAMESPACE]" "[OPTION:wide|yaml]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE=$1
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

  echo "kubectl get ${RESOURCE} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}"
  kubectl get ${RESOURCE} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}
}
kcyaml() {
  usage $# "[RESOURCE:deploy,sts,svc,configmap,secret]" "[NAMESPACE:default]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE=${1:-deploy,sts,svc,configmap,secret}
  local NAMESPACE=${2:-default}

  kcgettemplate ${RESOURCE} ${NAMESPACE} "yaml"
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
kcbash() {
  usage $# "POD_NAME" "[NAMESPACE]" "[COMMANDS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodls'" >&2
    kcpodls
    return 1
  fi

  local POD_NAME=$1
  local NAMESPACE=$2
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  if [ -z "$3" ]; then
      echo "kubectl exec -it ${POD_NAME} ${EXTRA_PARAMS} -- /bin/bash"
      kubectl exec -it ${POD_NAME} ${EXTRA_PARAMS} -- /bin/bash
    else
      local COMMANDS=${@:3}
      echo "kubectl exec -it ${POD_NAME} ${EXTRA_PARAMS} -- ${COMMANDS}"
      kubectl exec -it ${POD_NAME} ${EXTRA_PARAMS} -- ${COMMANDS}
  fi
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
  echo "kcpodinfo [POD_NAME] : get more info from this pod"

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
  echo "kcpodinfo [POD_NAME] : get more info from this pod"

  echo "kcpodyaml [POD_NAME] : get more YAML from this pod"
  echo "kcedit [POD_NAME] [SERVICE_NAME] : edit its YAML"
  echo "kcrm [POD_NAME] : to stop and remove"
}
kcruntpl() {
  usage $# "CMD" "IMAGE_NAME" "INSTANCE_NAME" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local IMAGE_NAME=$2
  local INSTANCE_NAME=$3
  local NAMESPACE=$4
  local EXTRA_PARAMS=${@:5}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi

  # https://kubernetes.io/docs/reference/kubectl/conventions/#generators
  # https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/#docker-run
  echo "kubectl ${CMD} --image=${IMAGE_NAME} ${EXTRA_PARAMS} ${INSTANCE_NAME}"
  kubectl ${CMD} --image=${IMAGE_NAME} ${EXTRA_PARAMS} ${INSTANCE_NAME}
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

kcpodls() {
  usage $# "[CONTAINING_TEXT]" "[NAMESPACE]"

  local CONTAINING_TEXT=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n ${NAMESPACE}"
  fi
  if [ -z "$CONTAINING_TEXT" ]; then
      echo "kubectl get pods ${EXTRA_PARAMS}"
      kubectl get pods ${EXTRA_PARAMS}
    else
      echo "== List all existing pods containing [${CONTAINING_TEXT}] =="
      echo "kubectl get pods ${EXTRA_PARAMS} | grep ${CONTAINING_TEXT}"
      kubectl get pods ${EXTRA_PARAMS} | grep ${CONTAINING_TEXT}
  fi
}
alias kcpodinfo=kcpoddescribe
kcpoddescribe() {
  usage $# "POD_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    return 1
  fi
  kcdesc "pod" $@
}
kcpodid() {
  usage $# "POD_NAME" "[NAMESPACE]"
  kcpoddescribe $@ | grep 'Container ID'
}
kcpodyaml() {
  usage $# "POD_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    return 1
  fi

  kcyaml $@
}
kcpodlabel() {
  echo "kubectl get pods $@ --show-labels"
  kubectl get pods $@ --show-labels
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
  kcruntpl "run --generator=run-pod/v1" "${IMAGE_NAME}" "${INSTANCE_NAME}" "${NAMESPACE}" "${EXTRA_PARAMS}"
}

alias kcpodlogs=kclogsns
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

alias kcsvcls=kclsservices
alias kcsvcyaml=kcyaml
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

alias kcdpls=kclsdeployments
alias kcdpyaml=kcyaml
# https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/
kcdprun() {
  usage $# "IMAGE_NAME" "DEPLOYMENT_NAME" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  kcruntpl "create deployment" $@
}
kcdpinfo() {
  usage $# "DEPLOYMENT_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a deployment name from a namespace: If you don't know any pod names run 'kclsdeployments'" >&2
    return 1
  fi

  kcdesc "deployment" $@
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

  echo "kubectl delete pod,service,deployment ${RESOURCE} ${EXTRA_PARAMS}"
  kubectl delete pod,service,deployment ${RESOURCE} ${EXTRA_PARAMS}
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

  echo "kubectl -n ${NAMESPACE} delete po,svc,deployment --all "
  kubectl -n ${NAMESPACE} delete po,svc,deployment --all 
}
