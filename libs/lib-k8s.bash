KUBE_FOLDER=~/.kube

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
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
kcgettemplate() {
  usage $# "RESOURCE" "[NAMESPACE]" "[OPTION:wide|yaml]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local RESOURCE=$1
  local NAMESPACE=$2
  local OPTION=$3
  local ADDITIONAL_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS -n $NAMESPACE"
    else
      local EXTRA_PARAMS="$EXTRA_PARAMS --all-namespaces"
  fi
  if [ -n "$OPTION" ]; then
      local EXTRA_PARAMS="$EXTRA_PARAMS -o $OPTION"
  fi

  echo "kubectl get ${RESOURCE} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}"
  kubectl get ${RESOURCE} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}
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
    return -1
  fi

  local NAMESPACE=$1
  local CONTEXT=${2:---current}

  kcconftemplate "set-context ${CONTEXT} --namespace=${NAMESPACE}"
}
kcconf() {
  kcconftemplate "view"
}
kcconftemplate() {
  usage $# "CMD"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CMD=$1
  local EXTRA_PARAMS=${@:2}

  echo "kubectl config ${CMD} ${EXTRA_PARAMS}"
  kubectl config ${CMD} ${EXTRA_PARAMS}
}

kccreate() {
  usage $# "FILE_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FILE_NAME=$1
  local NAMESPACE=$2
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n $NAMESPACE"
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
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CMD=$1
  local IMAGE_NAME=$2
  local INSTANCE_NAME=$3
  local NAMESPACE=$4
  local EXTRA_PARAMS=${@:5}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n $NAMESPACE"
  fi

  # https://kubernetes.io/docs/reference/kubectl/conventions/#generators
  # https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/#docker-run
  echo "kubectl ${CMD} --image=${IMAGE_NAME} ${EXTRA_PARAMS} ${INSTANCE_NAME}"
  kubectl ${CMD} --image=${IMAGE_NAME} ${EXTRA_PARAMS} ${INSTANCE_NAME}
}
kcattach() {
  usage $# "POD_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kclspods'" >&2
    kclspods
    return -1
  fi

  local POD_NAME=$1

  # https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/#docker-attach
  echo "kubectl attach -it ${POD_NAME}"
  kubectl attach -it ${POD_NAME}
}
kcbash() {
  usage $# "POD_NAME" "[COMMANDS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kclspods'" >&2
    kclspods
    return -1
  fi

  local POD_NAME=$1
  if [ -z "$2" ]
    then
      echo "Login into a Bash : ${POD_NAME}"
      kcbash ${POD_NAME} /bin/bash
    else
      local COMMANDS=${@:2}
      echo "kubectl exec -it ${POD_NAME} -- ${COMMANDS}"
      kubectl exec -it ${POD_NAME} -- ${COMMANDS}
  fi
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
    return -1
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
    return -1
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
    return -1
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
    return -1
  fi

  local CMD=$1
  local NAMESPACE=$2

  echo "kubectl ${CMD} namespace ${NAMESPACE} ${@:3}"
  kubectl ${CMD} namespace ${NAMESPACE} ${@:3}
}

alias kcpodls='kubectl get pods'
alias kcpodlsfull='kcpodls --all-namespaces -o wide'

kcpodlabel() {
  echo "kubectl get pods --show-labels"
  kubectl get pods --show-labels
}
kcpodid() {
  usage $# "POD_NAME" "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    kcpodlsfull
    return -1
  fi

  local POD_NAME=$1
  local NAMESPACE=$2

  echo "kubectl describe pod ${POD_NAME} -n ${NAMESPACE}"
  kcpodinfo ${POD_NAME} ${NAMESPACE} | grep 'Container ID'
}

kcpodrun() {
  usage $# "IMAGE_NAME" "INSTANCE_NAME" "[NAMESPACE]" "[PORT]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
kcpodtop() {
  usage $# "POD_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kclspods'" >&2
    kclspods
    return -1
  fi

  local POD_NAME=$1
  local EXTRA_PARAMS=${@:2}

  echo "kubectl top pod ${POD_NAME} ${EXTRA_PARAMS}"
  kubectl top pod ${POD_NAME} ${EXTRA_PARAMS}
}
kcpodtail() {
  usage $# "POD_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kclspods'" >&2
    kclspods
    return -1
  fi

  local POD_NAME=$1
  kcpodlogs ${POD_NAME} -f
}
kcpodlogs() {
  usage $# "POD_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kclspods'" >&2
    kclspods
    return -1
  fi

  local POD_NAME=$1
  local EXTRA_PARAMS=${@:2}

  echo "kubectl logs ${EXTRA_PARAMS} ${POD_NAME}"
  kubectl logs ${EXTRA_PARAMS} ${POD_NAME}
}

kcpodyaml() {
  usage $# "POD_NAME" "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    kcpodlsfull
    return -1
  fi

  local POD_NAME=$1
  local NAMESPACE=$2
  
  kcpodtemplate "get" ${POD_NAME} ${NAMESPACE} yaml
}
kcpodinfo() {
  usage $# "POD_NAME" "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    kcpodlsfull
    return -1
  fi

  kcpodtemplate "describe" $@
}
kcpodrm() {
  usage $# "POD_NAME" "NAMESPACE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    kcpodlsfull
    return -1
  fi

  kcpodtemplate "delete" $@
}
kcpodtemplate() {
  usage $# "CMD" "POD_NAME" "NAMESPACE" "[OPTION:yaml]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcpodlsfull'" >&2
    kcpodlsfull
    return -1
  fi

  local CMD=$1
  local POD_NAME=$2
  local NAMESPACE=$3
  local OPTION=$4
  local ADDITIONAL_PARAMS=${@:5}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n $NAMESPACE"
  fi
  if [ -n "$OPTION" ]; then
      local EXTRA_PARAMS="$EXTRA_PARAMS -o $OPTION"
  fi

  echo "kubectl ${CMD} pod ${POD_NAME} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}"
  kubectl ${CMD} pod ${POD_NAME} ${EXTRA_PARAMS} ${ADDITIONAL_PARAMS}
}

alias kcsvcls=kclsservices

kcstschk() {
  usage $# "SERVICE_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SERVICE_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}

  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n $NAMESPACE"
  fi

  echo "kubectl rollout status sts/${DEPLOYMENT_NAME} ${EXTRA_PARAMS}"
  kubectl rollout status sts/${DEPLOYMENT_NAME} ${EXTRA_PARAMS}
}

alias kcdpls=kclsdeployments
# https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/
kcdprun() {
  usage $# "IMAGE_NAME" "DEPLOYMENT_NAME" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  kcruntpl "create deployment" $@
}
kcdpinfo() {
  usage $# "DEPLOYMENT_NAME" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DEPLOYMENT_NAME=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}
  kcdptpl "describe" "${DEPLOYMENT_NAME}" "${NAMESPACE}"
}
kcdpexpose() {
  usage $# "DEPLOYMENT_NAME" "SERVICE_NAME" "PORT" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
kcdptpl() {
  usage $# "CMD" "DEPLOYMENT_NAME" "NAMESPACE" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a pod name from a namespace: If you don't know any pod names run 'kcdpls'" >&2
    kcdpls
    return 1
  fi

  local CMD=$1
  local DEPLOYMENT_NAME=$2
  local NAMESPACE=$3
  local EXTRA_PARAMS=${@:4}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n $NAMESPACE"
  fi

  echo "kubectl ${CMD} deployment ${DEPLOYMENT_NAME} ${EXTRA_PARAMS}"
  kubectl ${CMD} deployment ${DEPLOYMENT_NAME} ${EXTRA_PARAMS}
}

kcnetlookup() {
  usage $# "DOMAIN_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  kcexec nslookup $@
}
kcexec() {
  usage $# "CMD"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  kubectl exec -ti busybox -- $@
}

kcedit() {
  usage $# "RESOURCE"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local RESOURCE=$1

  echo "kubectl edit ${RESOURCE}"
  kubectl edit ${RESOURCE}
}
kcrm() {
  usage $# "RESOURCE" "[NAMESPACE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please select a POD or SERVICE name: If you don't know any pod names run 'kclspods' or 'kclsservices'" >&2
    return -1
  fi

  local RESOURCE=$1
  local NAMESPACE=$2
  local EXTRA_PARAMS=${@:3}
  
  if [ -n "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n $NAMESPACE"
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
    return -1
  fi

  local NAMESPACE=$1

  echo "kubectl -n ${NAMESPACE} delete po,svc,deployment --all "
  kubectl -n ${NAMESPACE} delete po,svc,deployment --all 
}
