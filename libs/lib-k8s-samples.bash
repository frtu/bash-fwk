import lib-k8s-resources

# https://kubernetes.io/docs/tutorials/kubernetes-basics/
# https://awkwardferny.medium.com/getting-started-with-kubernetes-ingress-nginx-on-minikube-d75e58f52b6c
kspodecho() {
  usage $# "[APP_NAME:sample]" "[ECHO:hello]" "[IMAGE_NAME:hashicorp/http-echo:0.2.3]" "[PORT:5678]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local APP_NAME=${1:-sample}
  local ECHO=${2:-hello}
  local IMAGE_NAME=${3:-hashicorp/http-echo:0.2.3}
  local PORT=${4:-5678}
  
  krpod ${APP_NAME} ${IMAGE_NAME} ${PORT} "-text=${ECHO}"
}
kssvc() {
  usage $# "[TARGET_PORT:8080]" "[PORT:80]" "[SVC_NAME:sample]" "[APP_NAME:sample]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local TARGET_PORT=$1
  local PORT=${2:-80}
  local SVC_NAME=${3:-sample}
  local APP_NAME=${4:-$SVC_NAME}

  krsvc ${TARGET_PORT} ${PORT} ${SVC_NAME} ${APP_NAME}
}
# https://kubernetes.io/docs/concepts/services-networking/ingress/
ksingress() {
  usage $# "[TARGET_PORT:80]" "[INGRESS_NAME:sample]" "[APP_NAME:sample]" "[PATH:sample]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local TARGET_PORT=${1:-80}
  local INGRESS_NAME=${2:-sample}
  local APP_NAME=${3:-$INGRESS_NAME-service}
  local APP_PATH=${4:-$APP_NAME}

  kringress ${TARGET_PORT} ${INGRESS_NAME} ${APP_NAME} ${APP_PATH}
}
