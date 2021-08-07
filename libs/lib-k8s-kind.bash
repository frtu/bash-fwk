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

  echo "kubectl cluster-info --context ${CLUSTER_NAME}"
  kubectl cluster-info --context ${CLUSTER_NAME}
}

kdc() {
  usage $# "[CLUSTER_NAME]"
  kdtpl "create" $@
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
