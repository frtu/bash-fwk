import lib-k8s

# https://www.baeldung.com/kubernetes-helm
hm() { 
  echo "helm version"
  helm version
}
hmsrvupg() { 
  usage $# "[SERVICE_ACCOUNT:tiller]"

  local SERVICE_ACCOUNT=${1:-tiller}
  hmsrvinit ${SERVICE_ACCOUNT} --upgrade
}
hmsrvinit() {
  usage $# "[SERVICE_ACCOUNT:tiller]"

  echo "== ATTENTION service account MUST be created before https://github.com/helm/helm/issues/4685#issuecomment-531239132 =="
  echo "- Attempt to get YAML from https://raw.githubusercontent.com/mspnp/microservices-reference-implementation/master/k8s/tiller-rbac.yaml"
  kcapply https://raw.githubusercontent.com/mspnp/microservices-reference-implementation/master/k8s/tiller-rbac.yaml

  local SERVICE_ACCOUNT=${1:-tiller}

  echo "== Service Account : ${SERVICE_ACCOUNT} ${@:2} =="
  hminit --service-account ${SERVICE_ACCOUNT} ${@:2}

  echo "== Update charts : You need have previously run > hmrepo =="
  hmrepoupd
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
  # hmtpl "ls" "--all"
  hmtpl "list"
}
hminst() { 
  usage $# "CHART_FOLDER" "[INSTANCE_NAME]" "[CUSTOM_CONFIG_FILE]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CHART_FOLDER=$1
  local INSTANCE_NAME=$2
  local CUSTOM_CONFIG_FILE=$3
  local EXTRA_PARAMS=${@:4}

  if [ -n "$INSTANCE_NAME" ]
    then
      local INSTANCE_NAME=--name ${INSTANCE_NAME}
    else
      local INSTANCE_NAME="--generate-name"
  fi
  if [ -f "$CUSTOM_CONFIG_FILE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -f $CUSTOM_CONFIG_FILE"
  fi

  hmtpl "install" ${EXTRA_PARAMS} ${CHART_FOLDER} ${INSTANCE_NAME}
}
hmupg() { 
  usage $# "CHART_FOLDER" "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    hmls
    return 1; 
  fi

  local CHART_FOLDER=$1
  local INSTANCE_NAME="--name $2"

  hmtpl "upgrade" ${INSTANCE_NAME} ${CHART_FOLDER}
}
hmrollback() { 
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    hmls
    return 1; 
  fi

  local INSTANCE_NAME=$1
  hmtpl "rollback" ${INSTANCE_NAME} 1
}
hmrm() { 
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    hmls
    return 1; 
  fi

  echo "- @Deprecated : ATTENTION removed in v3 : https://helm.sh/docs/topics/v2_v3_migration/"
  echo "- Use for v3 use > hmuninst"

  local INSTANCE_NAME=$1
  hmtpl "delete" "--purge" ${INSTANCE_NAME}
}
hmuninst() {
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    hmls
    return 1; 
  fi

  echo "- ATTENTION ONLY in v3 : https://helm.sh/docs/topics/v2_v3_migration/"
  echo "- Use for v2 use > hmrm"

  local INSTANCE_NAME=$1
  hmtpl "uninstall" ${INSTANCE_NAME}
}

hmrepo() {
  usage $# "[REPO_URL:https://kubernetes-charts.storage.googleapis.com/]" "[REPO_NAME:stable]"

  # https://github.com/helm/charts#how-do-i-enable-the-stable-repository-for-helm-3
  local REPO_URL=${1:-https://kubernetes-charts.storage.googleapis.com/}
  local REPO_NAME=${2:-stable}

  echo "helm repo add ${REPO_NAME} ${REPO_URL}"
  helm repo add ${REPO_NAME} ${REPO_URL}
}
hmrepocn() {
  # https://github.com/cloudnativeapp/charts/blob/master/README_en.md
  local REPO_URL=${1:-https://apphub.aliyuncs.com/}
  local REPO_NAME=${2:-apphub}

  hmrepo ${REPO_URL} ${REPO_NAME}
}
hmrepoupd() {
  echo "helm repo update"
  helm repo update              # Make sure we get the latest list of charts
}
hmsearch() {
  usage $# "[REPO_NAME:stable?]"

  local REPO_NAME=$1
  helm search repo ${REPO_NAME}
}

hminit() { 
  echo "== Initialize Helm server (Tiller) into the current K8s context =="
  echo "- @Deprecated : ATTENTION removed in v3 : https://helm.sh/docs/topics/v2_v3_migration/"

  echo "helm init $@"
  helm init $@
}
