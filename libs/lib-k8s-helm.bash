import lib-k8s

CHARTS_LOCAL_FOLDER=~/git/helm-charts
CHARTS_PLUGIN_FOLDER=~/Library/helm/plugins

inst_hm() {
  inst helm
}
inst_hmdiff() {
  hmplugininst https://github.com/databus23/helm-diff
}
hmplugin() {
  cd $CHARTS_PLUGIN_FOLDER
}
hmplugininst() {
  usage $# "PACKAGE_LOCATION"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  helm plugin install $@
}
hmpluginls() {
  helm plugin list
}

# https://helm.sh/docs/intro/quickstart/
# https://www.baeldung.com/kubernetes-helm
# https://wkrzywiec.medium.com/how-to-deploy-application-on-kubernetes-with-helm-39f545ad33b8
hm() { 
  echo "helm version"
  helm version
}
hmhub() {
  echo "== Opening browser at https://artifacthub.io/"
  open -a "Google Chrome" "https://artifacthub.io/"
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
  usage $# "CHART_FOLDER"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

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
  usage $# "CMD" "CHART" 

  echo "helm $@"
  helm $@
}

hmls() { 
  # hmtpl "ls" "--all"
  hmtpl "list"
}
hmdesc() { 
  usage $# "CHART_FULLNAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  hmtpl "show" "chart" $@
}
hmdescall() { 
  usage $# "CHART_FULLNAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  hmtpl "show" "all" $@
}
# https://helm.sh/docs/helm/helm_install/
hminst() { 
  usage $# "CHART" "[NAME]" "[NAMESPACE]" "[CUSTOM_CONFIG_FILE]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CHART=$1
  local NAME=$2
  local NAMESPACE=$3
  local CUSTOM_CONFIG_FILE=$4
  local EXTRA_PARAMS=${@:4}

  if [ -z "$NAME" ]; then
      local EXTRA_PARAMS="$EXTRA_PARAMS --generate-name"
  fi
  if [ -f "$NAMESPACE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -f $NAMESPACE"
  fi
  if [ -f "$CUSTOM_CONFIG_FILE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS -n $CUSTOM_CONFIG_FILE --create-namespace"
  fi

  hmtpl "install" ${NAME} ${CHART} ${EXTRA_PARAMS}
}
hmupg() { 
  usage $# "CHART" "NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    hmls
    return 1; 
  fi

  local CHART=$1
  local NAME="--name $2"

  hmtpl "upgrade" ${NAME} ${CHART}
}
hmrollback() { 
  usage $# "NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    hmls
    return 1; 
  fi

  local NAME=$1
  hmtpl "rollback" ${NAME} 1
}
hmrm() { 
  usage $# "NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    hmls
    return 1; 
  fi

  echo "- @Deprecated : ATTENTION removed in v3 : https://helm.sh/docs/topics/v2_v3_migration/"
  echo "- Use for v3 use > hmuninst"

  local NAME=$1
  hmtpl "delete" "--purge" ${NAME}
}
hmuninst() {
  usage $# "NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    hmls
    return 1; 
  fi

  echo "- ATTENTION ONLY in v3 : https://helm.sh/docs/topics/v2_v3_migration/"
  echo "- Use for v2 use > hmrm"

  local NAME=$1
  hmtpl "uninstall" ${NAME}
}

hmrepogit() {
  enablelib git
  git clone https://github.com/helm/charts.git ${CHARTS_LOCAL_FOLDER}

  echo "== Checkout chart repo locally at : ${CHARTS_LOCAL_FOLDER}. Use > hmrepogitcd"
  hmrepogitcd 
}
hmrepogitcd() {
  cd ${CHARTS_LOCAL_FOLDER}
}

hmrepo() {
  usage $# "[REPO_URL:https://charts.helm.sh/stable]" "[REPO_NAME:stable]"

  # https://github.com/helm/charts#how-do-i-enable-the-stable-repository-for-helm-3
  local REPO_URL=${1:-https://charts.helm.sh/stable}
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
  helm search repo ${REPO_NAME} ${@:2}
}

hmrepobitnami() {
  hmrepo https://charts.bitnami.com/bitnami bitnami
}
hmsearchbitnami() {
  hmsearch bitnami $@
}

hminit() { 
  echo "== Initialize Helm server (Tiller) into the current K8s context =="
  echo "- @Deprecated : ATTENTION removed in v3 : https://helm.sh/docs/topics/v2_v3_migration/"

  echo "helm init $@"
  helm init $@
}

hminstchartmuseum() {
  hminst stable/chartmuseum chartmuseum

  local POD_NAME_CHARTMUSEUM=$(kubectl get pods --namespace default -l "app=chartmuseum" -l "release=chartmuseum" -o jsonpath="{.items[0].metadata.name}")
  kubectl port-forward $POD_NAME_CHARTMUSEUM 8080:8080 --namespace default &
  # Test
  curl http://localhost:8080
}

hminstelastic() {
  hmrepo https://helm.elastic.co elastic
  hmrepoupd
  hmsearch elasticsearch --version 7
  helm install elasticsearch --namespace observability --wait --timeout=600 elastic/elasticsearch
}
hminstkibana() {
  helm install kibana elastic/kibana --namespace observability \
     --set ingress.enabled=true \
     --set ingress.hosts[0]=kibana.pv \
     --set service.externalPort=80 
}
