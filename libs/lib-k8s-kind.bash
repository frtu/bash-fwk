import lib-inst
import lib-k8s
import lib-k8s-argocd

# https://kind.sigs.k8s.io/docs/user/quick-start/
inst_kind() {
  inst kind
}

kd() {
  echo "kind version"
  kind version
}
kdls() {
  echo "kind get clusters"
  kind get clusters
}
alias kdinfo=kddesc
kddesc() {
  usage $# "CLUSTER_NAME"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please provide a CLUSTER_NAME: If you don't know any cluster names run 'kdls'" >&2
    kdls
    return 1
  fi

  local CLUSTER_NAME=$1

  # Every kind instances are prefixed with kind-*
  local CLUSTER_FULL_NAME=kind-${CLUSTER_NAME}

  echo "------- Cluster Info --------";
  echo "kubectl cluster-info --context ${CLUSTER_FULL_NAME}"
  kubectl cluster-info --context ${CLUSTER_FULL_NAME}
  
  echo "------- Running instances --------";
  kdgetnodes $@
  echo "------- Config --------";
  echo "-> kdgetconfig $@"
}

kdgenconfig() {
  usage $# "[CONFIG_FILE]" "[REG_HOST]" "[REG_PORT:5000]"

  local CONFIG_FILE=${1:-kind-config.yaml}
  local REG_HOST=$2
  local REG_PORT=${3:-5000}
  
  cat > $CONFIG_FILE <<EOF
# three node (two workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

  if [ -n "$REG_HOST" ]; then
    echo "Adding docker registry $REG_HOST:$REG_PORT"
    cat >> $CONFIG_FILE <<EOF
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${REG_PORT}"]
    endpoint = ["http://${REG_HOST}:5000"]
EOF
  fi

  echo "== Generated file at ${CONFIG_FILE} =="
  cat ${CONFIG_FILE}
}
kdconfreg() {
  usage $# "[REG_PORT:5000]"
  local REG_PORT=${1:-5000}

  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${REG_PORT}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF
}

kdc() {
  usage $# "[CLUSTER_NAME:kind]" "[CONFIG_FILE]" "[OVERRIDE_IMAGE:kindest/node:v1.23.1]"

  local CLUSTER_NAME=$1
  local CONFIG_FILE=$2
  local OVERRIDE_IMAGE=$3
  local EXTRA_PARAMS=${@:4}
  
  # List of all image at https://hub.docker.com/r/kindest/node/tags
  if [ -n "$OVERRIDE_IMAGE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --image=$OVERRIDE_IMAGE"
  fi
  # Default cluster context name is `kind`
  if [ -f "$CONFIG_FILE" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --config $CONFIG_FILE"
  fi

  kdtpl "create" ${CLUSTER_NAME} ${EXTRA_PARAMS}
}
kdrm() {
  usage $# "[CLUSTER_NAME]"
  kdtpl "delete" $@
}
kdtpl() {
  usage $# "CMD" "[CLUSTER_NAME]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please provide a CLUSTER_NAME: If you don't know any cluster names run 'kdls'" >&2
    kdls
    return 1
  fi

  local CMD=$1
  local CLUSTER_NAME=$2
  local EXTRA_PARAMS=${@:3}
  
  # Default cluster context name is `kind`
  if [ -n "$CLUSTER_NAME" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --name $CLUSTER_NAME"
  fi

  echo "kind ${CMD} cluster ${EXTRA_PARAMS}"
  kind ${CMD} cluster ${EXTRA_PARAMS}
}
# https://kind.sigs.k8s.io/
kdcgo() {
  usage $# "[GO_MODULE]" "[CLUSTER_NAME]" "[CMD]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please provide a CLUSTER_NAME: If you don't know any cluster names run 'kdls'" >&2
    kdls
    return 1
  fi

  local GO_MODULE=${1:-sigs.k8s.io/kind@v0.11.1}
  local CLUSTER_NAME=$2
  local CMD=${3:-create}
  local EXTRA_PARAMS=${@:4}
  
  # Default cluster context name is `kind`
  if [ -n "$CLUSTER_NAME" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --name $CLUSTER_NAME"
  fi
  
  echo "GO111MODULE=\"on\" go install ${GO_MODULE} && kind ${CMD} cluster ${EXTRA_PARAMS}"
  GO111MODULE="on" go install ${GO_MODULE} && kind ${CMD} cluster ${EXTRA_PARAMS}
}

kdgetnodes() {
  kdget nodes $@
}
kdgetconfig() {
  kdget kubeconfig $@
}
kdget() {
  usage $# "RESOURCE:nodes|kubeconfig" "[CLUSTER_NAME]" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local RESOURCE=$1
  local CLUSTER_NAME=$2
  local EXTRA_PARAMS=${@:3}
  
  # Default cluster context name is `kind`
  if [ -n "$CLUSTER_NAME" ]; then
    local EXTRA_PARAMS="$EXTRA_PARAMS --name $CLUSTER_NAME"
  fi

  echo "kind get ${RESOURCE} ${EXTRA_PARAMS}"
  kind get ${RESOURCE} ${EXTRA_PARAMS}
}

alias kdimport=kdload
kdload() {
  usage $# "IMAGE_NAME" "[CLUSTER_NAME]" "[EXTRA_PARAMS]"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "= Please provide a IMAGE_NAME: If you don't know any cluster names run 'dckls'" >&2
    dckls
    return 1
  fi

  local IMAGE_NAME=$1
  local CLUSTER_NAME=$2
  local EXTRA_PARAMS=${@:3}

  # Default cluster context name is `kind`
  if [ -n "$CLUSTER_NAME" ]; then
    echo "== STRANGELY ONLY WORKS WITH kind CLUSTER =="
    # Every kind instances are prefixed with kind-*
    local CLUSTER_FULL_NAME=kind-${CLUSTER_NAME}

    local EXTRA_PARAMS="$EXTRA_PARAMS --name $CLUSTER_FULL_NAME"
  fi

  echo "kind load docker-image ${IMAGE_NAME} ${EXTRA_PARAMS}"
  kind load docker-image ${IMAGE_NAME} ${EXTRA_PARAMS}
}

kdinstdashboard() {
  echo "kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc6/aio/deploy/recommended.yaml"
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc6/aio/deploy/recommended.yaml

  # Login dashboard with
  echo "Login dashboard with => http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login"
  kcproxy
}
kdinstargocd() {
  kubectl create namespace argocd
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
}
kdargocdls() {
  kcls argocd
}
kdargocd() {
  usage $#  "[PORT_MAPPING-8080]" "[EXTRA_PARAMS]"

  local PORT_MAPPING=${1:-8080}:443
  kcportfwd svc/argocd-server ${PORT_MAPPING} argocd ${@:2}
}
kdargocdpassword() {
  echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
}
