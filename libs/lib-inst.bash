if [[ -z "$INSTALL_TOOL" ]] ; then INSTALL_TOOL="apt -y" ; fi
if [[ -z "$UNINSTALL_TOOL" ]] ; then UNINSTALL_TOOL="apt purge" ; fi

if [[ -z "$CHECK_SUDO" ]] && [[ $(id -u) -ne 0 ]] ; then 
  export INSTALL_TOOL="sudo $INSTALL_TOOL"
  export UNINSTALL_TOOL="sudo $UNINSTALL_TOOL"
  # ONLY needed when not root
  export SUDO_CONDITIONAL="sudo "
fi

inst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "$INSTALL_TOOL install $@"
  $INSTALL_TOOL install $@
}
uninst() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "== ATTENTION you will have to manually type 'y' to confirm. =="

  echo "$UNINSTALL_TOOL $@"
  $UNINSTALL_TOOL $@

  $CLEANUP_TOOL
}
upd() {
  $INSTALL_TOOL update $@
}
upg() {
  $INSTALL_TOOL upgrade $@
}
inst_dl_bin() {
  usage $# "EXEC_NAME" "EXEC_URL" "[BIN_PATH:/usr/local/bin/]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local EXEC_NAME=$1
  local EXEC_URL=$2
  local BIN_PATH=${3:-/usr/local/bin/}

  echo "curl -Lo ${EXEC_NAME} ${EXEC_URL}"
  curl -Lo ${EXEC_NAME} "${EXEC_URL}" && chmod +x ${EXEC_NAME} && bincp ${EXEC_NAME}
}
bincp() {
  usage $# "EXEC_FILE_NAME" "[EXEC_FINAL_NAME]" "[BIN_PATH:/usr/local/bin/]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local EXEC_FILE_NAME=$1
  local EXEC_FINAL_NAME=${2:-$1}
  local BIN_PATH=${3:-/usr/local/bin/}
  sudo cp ${EXEC_FILE_NAME} ${BIN_PATH}/${EXEC_FINAL_NAME}
}

inst_m1() {
  inst cmake pkg-config
}

inst_wget() {
  inst wget
}
inst_maven() {
  inst maven
}

# https://cluster-api.sigs.k8s.io/clusterctl/overview.html
inst_clusterctl() {
  inst clusterctl
}
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
inst_dl_kubectl() {
  # https://github.com/kubernetes/kubernetes/releases
  usage $# "[VERSION:latest]" "[BIN_PATH:/usr/local/bin/]"
  echo "== Check release version at https://github.com/kubernetes/kubernetes/tags =="

  local VERSION=$1
  local BIN_PATH=${2:-/usr/local/bin/}

  if [[ -z ${VERSION} ]]; then
    VERSION=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`
  fi
  local OS=$(uname | tr '[:upper:]' '[:lower:]')
  local EXEC_URL=https://storage.googleapis.com/kubernetes-release/release/${VERSION}/bin/${OS}/amd64/kubectl

  inst_dl_bin "kubectl" "${EXEC_URL}" "${BIN_PATH}"

  # ADD IF MOVE THE SCRIPT OUT : enablelib k8s
  kc
}
# https://kind.sigs.k8s.io/docs/user/quick-start/
inst_dl_kind() {
  usage $# "[VERSION:v0.11.1]" "[EXEC_URL:https://kind.sigs.k8s.io/dl/xxx]" "[BIN_PATH:/usr/local/bin/]"

  local VERSION=$1
  local EXEC_URL=$2
  local BIN_PATH=${3:-/usr/local/bin/}

  if [[ -z ${EXEC_URL} ]]; then
    if [[ -z ${VERSION} ]]; then
      VERSION=latest
    fi
    local OS=$(uname | tr '[:upper:]' '[:lower:]')
    local EXEC_URL=https://kind.sigs.k8s.io/dl/${VERSION}/kind-${OS}-amd64
  fi

  inst_dl_bin "kind" "${EXEC_URL}" "${BIN_PATH}"
}

# https://github.com/argoproj/argo-cd/releases
inst_dl_argocd() {
  usage $# "[VERSION:v2.2.2]" "[EXEC_URL:https://github.com/argoproj/argo-cd/releases/download/xxx]" "[BIN_PATH:/usr/local/bin/]"

  local VERSION=${1:-v2.2.2}
  local EXEC_URL=$2
  local BIN_PATH=${3:-/usr/local/bin/}

  if [[ -z ${EXEC_URL} ]]; then
    if [[ -z ${VERSION} ]]; then
      VERSION=latest
    fi
    local OS=$(uname | tr '[:upper:]' '[:lower:]')
    local EXEC_URL=https://github.com/argoproj/argo-cd/releases/download/${VERSION}/argocd-${OS}-amd64
  fi

  inst_dl_bin "argocd" "${EXEC_URL}" "${BIN_PATH}"
}
