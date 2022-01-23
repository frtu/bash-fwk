import lib-inst

inst_argocli() {
  # brew tap argoproj/tap && brew install argoproj/tap/argocd
  inst_dl_argocd
}

kalogin() {
  usage $# "[SERVER_URL:localhost:8080]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SERVER_URL=${1:-localhost:8080}
  local EXTRA_PARAMS=${@:2}

  katpl login ${SERVER_URL} --insecure "${EXTRA_PARAMS}"
}
kapwdupd() {
  katpl account update-password $@
}
# Adding ArgoCD service-account to that K8S TARGET_CLUSTER_NAME
katarget() {
  usage $# "TARGET_CLUSTER_NAME:target-k8s" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    kcctx
    return 1
  fi

  local TARGET_CLUSTER_NAME=$1
  local EXTRA_PARAMS=${@:2}
  
  katpl cluster add "${TARGET_CLUSTER_NAME}" "${EXTRA_PARAMS}"
}
katpl() {
  usage $# "CMD" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local EXTRA_PARAMS=${@:2}

  echo "argocd ${CMD} ${EXTRA_PARAMS}"
  argocd ${CMD} ${EXTRA_PARAMS}
}