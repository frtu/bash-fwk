import lib-k8s
import lib-inst

# https://kind.sigs.k8s.io/docs/user/quick-start/
inst_kind() {
  inst kind
}

kdls() {
  echo "kind get clusters"
  kind get clusters
}
kdinfo() {
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

  echo "kubectl cluster-info --context ${CLUSTER_FULL_NAME}"
  kubectl cluster-info --context ${CLUSTER_FULL_NAME}
}

kdgenconfig() {
  usage $# "[CONFIG_FILE]"

  local CONFIG_FILE=${1:-kind-config.yaml}

  cat > $CONFIG_FILE <<EOF
# three node (two workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

  echo "== Generated file at ${CONFIG_FILE} =="
  cat ${CONFIG_FILE}
}
kdc() {
  usage $# "[CLUSTER_NAME:kind]" "[CONFIG_FILE]" "[OVERRIDE_IMAGE:kindest/node:v1.17.2]"

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
    # Every kind instances are prefixed with kind-*
    local CLUSTER_FULL_NAME=kind-${CLUSTER_NAME}

    local EXTRA_PARAMS="$EXTRA_PARAMS --name $CLUSTER_FULL_NAME"
  fi

  echo "kind load docker-image ${IMAGE_NAME} ${EXTRA_PARAMS}"
  kind load docker-image ${IMAGE_NAME} ${EXTRA_PARAMS}
}

kddashboard() {
  echo "kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc6/aio/deploy/recommended.yaml"
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc6/aio/deploy/recommended.yaml

  # Login dashboard with
  echo "Login dashboard with => http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login"
  kcproxy
}
