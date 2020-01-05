import lib-k8s

# https://www.baeldung.com/kubernetes-helm
hm() { 
  echo "helm version"
  helm version
}
hminit() { 
  echo "== Initialize Helm server (Tiller) into the current K8s context =="

  echo "helm init $@"
  helm init $@
}
hmupg() { 
  usage $# "[SERVICE_ACCOUNT:tiller]"

  local SERVICE_ACCOUNT=${1:-tiller}
  hmsrvinit ${SERVICE_ACCOUNT} --upgrade
}
hmsrvinit() {
  usage $# "[SERVICE_ACCOUNT:tiller]"

  echo "== ATTENTION service account MUST be created before https://github.com/helm/helm/issues/4685#issuecomment-531239132 =="

  local SERVICE_ACCOUNT=${1:-tiller}
  hminit --service-account ${SERVICE_ACCOUNT} ${@:2}

  echo "helm repo add stable https://kubernetes-charts.storage.googleapis.com/"
  helm repo add stable https://kubernetes-charts.storage.googleapis.com/

  echo "helm repo update"
  helm repo update              # Make sure we get the latest list of charts
}
hmsrvinfo() {
  usage $# "[NAMESPACE:kube-system]"

  local NAMESPACE=${1:-kube-system}
  kcdpinfo "tiller-deploy" "${NAMESPACE}"
}
hmsrvrm() {
  kubectl -n kube-system delete deployment tiller-deploy
  kubectl -n kube-system delete service/tiller-deploy
} 

hmcreate() { 
  hmtpl "create" $@
}
hmgen() { 
  hmtpl "lint" $@
  hmtpl "template" $@
}
hmpkg() { 
  hmtpl "package" $@
}
hmhistory() { 
  hmtpl "history" $@
}
hmtpl() { 
  if [ -z "$2" ]; then
    echo "Please supply argument(s) \"CHART_FOLDER\"." >&2
    return 1
  fi
  echo "helm $@"
  helm $@
}

hmls() { 
  hmtpl "ls" "--all"
}
hminstall() { 
  usage $# "CHART_FOLDER" "[INSTANCE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CHART_FOLDER=$1
  local INSTANCE_NAME=$2

  if [ -n "$INSTANCE_NAME" ]
    then
      local INSTANCE_NAME=--name ${INSTANCE_NAME}
    else
      local INSTANCE_NAME="--generate-name"
  fi

  hmtpl "install" ${CHART_FOLDER} ${INSTANCE_NAME}
}
hmupgrade() { 
  usage $# "CHART_FOLDER" "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CHART_FOLDER=$1
  local INSTANCE_NAME=$2

  hmtpl "upgrade" ${INSTANCE_NAME} ${CHART_FOLDER}
}
hmrollback() { 
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  hmtpl "rollback" ${INSTANCE_NAME} 1
}
hmrm() { 
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  hmtpl "delete" "--purge" ${INSTANCE_NAME}
}
