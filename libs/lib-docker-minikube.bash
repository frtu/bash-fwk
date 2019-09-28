MINIKUBE_PERSIST_FILE=$LOCAL_SCRIPTS_FOLDER/env-minikube-instance.bash

k8mstart() {
  k8mtemplate "start" $@
}
k8mssh() {
  if [ -z "$2" ]
  then
    k8mtemplate "ssh" $1
  else
    local IMAGE_NAME=$1
    shift 1
    echo "CALL : root@$IMAGE_NAME> $@"
    echo "$@" | k8mtemplate "ssh" $IMAGE_NAME
  fi
}

k8mstop() {
  k8mtemplate "stop" $@
}
k8mrm() {
  k8mtemplate "delete" $@
}
k8mtemplate() {
  local EXTRA_PARAMS=${@:2}

  echo "minikube $1 ${EXTRA_PARAMS}"
  minikube $1 ${EXTRA_PARAMS}
}

k8mload() {
	local IMAGE_NAME=${1:-$MINIKUBE_NAME}
	echo "${FUNCNAME} ${IMAGE_NAME}"
	eval $(minikube docker-env)
}
k8mloadpersist() {
  local IMAGE_NAME=${1:-$MINIKUBE_NAME}
  k8mload $IMAGE_NAME

  echo "Persiting MINIKUBE_DEFAULT_INSTANCE=$IMAGE_NAME!"
  echo "export MINIKUBE_DEFAULT_INSTANCE=$IMAGE_NAME" > $MINIKUBE_PERSIST_FILE
}
k8mloadunset() {
  echo "unset MINIKUBE_DEFAULT_INSTANCE"
  unset MINIKUBE_DEFAULT_INSTANCE
  
  echo "rm $MINIKUBE_PERSIST_FILE"
  rm $MINIKUBE_PERSIST_FILE
}
