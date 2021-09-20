import lib-k8s

# https://kubernetes.io/docs/tutorials/kubernetes-basics/
krpod() {
  usage $# "APP_NAME" "IMAGE_NAME" "PORT" "[ARGS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local APP_NAME=$1
  local IMAGE_NAME=$2
  local PORT=$3
  local ARGS=$4

  echo "krpod $@"
  echo "
kind: Pod
apiVersion: v1
metadata:
  name: ${APP_NAME}-app
  labels:
    app: ${APP_NAME}
spec:
  containers:
  - name: ${APP_NAME}-app
    image: ${IMAGE_NAME}
    ports:
    - containerPort: ${PORT}
    args:
    - "${ARGS}"
" | kubectl apply -f -

  kcpodls ${APP_NAME}
}
krnginx() {
  usage $# "[APP_NAME:nginx]" "[IMAGE_NAME:nginx:1.14.2]" "[PORT:80]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local APP_NAME=${1:-nginx}
  local IMAGE_NAME=${2:-nginx:1.14.2}
  local PORT=${3:-80}

  krdp ${APP_NAME} ${IMAGE_NAME} ${PORT}
}
krdp() {
  usage $# "APP_NAME" "IMAGE_NAME" "PORT" "[ARGS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local APP_NAME=$1
  local IMAGE_NAME=$2
  local PORT=$3
  local ARGS=$4
  echo "krdp $@"
  echo "
kind: Deployment
apiVersion: apps/v1
metadata:
  name: ${APP_NAME}-deployment
  labels:
    app: ${APP_NAME}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    metadata:
      labels:
        app: ${APP_NAME}
    spec:
      containers:
      - name: ${APP_NAME}
        image: ${IMAGE_NAME}
        ports:
        - containerPort: ${PORT}
" | kubectl apply -f -

  kcdpls ${APP_NAME}
}
krsvc() {
  usage $# "TARGET_PORT" "[PORT:80]" "[SVC_NAME:sample]" "[APP_NAME:sample]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local TARGET_PORT=$1
  local PORT=${2:-80}
  local SVC_NAME=${3:-sample}
  local APP_NAME=${4:-$SVC_NAME}

  echo "krsvc $@"
  echo "
kind: Service
apiVersion: v1
metadata:
  name: ${SVC_NAME}-service
spec:
  selector:
    app: ${APP_NAME}
  ports:
  - port: ${PORT}
    targetPort: ${TARGET_PORT}
" | kubectl apply -f -

  kcsvcls ${SVC_NAME}
}
# https://kubernetes.io/docs/concepts/services-networking/ingress/
kringress() {
  usage $# "TARGET_PORT" "[INGRESS_NAME:sample]" "[APP_NAME:sample-service]" "[PATH:sample]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local TARGET_PORT=$1
  local INGRESS_NAME=${2:-sample}
  local APP_NAME=${3:-$INGRESS_NAME-service}
  local APP_PATH=${4:-$APP_NAME}

  echo "kringress $@"
  echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${INGRESS_NAME}-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /${APP_PATH}
        pathType: Prefix
        backend:
          service:
            name: ${APP_NAME}
            port:
              number: 80
" | kubectl apply -f -

  echo "== Access using : curl http://[CLUSTER_IP]/${APP_PATH}"
  kcingls ${INGRESS_NAME}
}
