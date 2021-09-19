import lib-k8s

# https://kubernetes.io/docs/tutorials/kubernetes-basics/
ksdp() {
  usage $# "[APP_NAME:sample]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local APP_NAME=${1:-sample}
  echo "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}
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
        image: gcr.io/kubernetes-e2e-test-images/echoserver:2.1
        ports:
        - containerPort: 8080
" | kubectl apply -f -

  kcdpls ${APP_NAME}
}
kssvc() {
  usage $# "[SVC_NAME:sample]" "[APP_NAME:sample]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SVC_NAME=${1:-sample}
  local APP_NAME=${2:-$SVC_NAME}
  echo "
apiVersion: v1
kind: Service
metadata:
  name: ${SVC_NAME}-svc
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: ${APP_NAME}
" | kubectl apply -f -

  kcsvcls ${APP_NAME}
}
# https://kubernetes.io/docs/concepts/services-networking/ingress/
ksingress() {
  usage $# "[INGRESS_NAME:sample]" "[APP_NAME:sample]" "[PATH:sample]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local INGRESS_NAME=${1:-sample}
  local APP_NAME=${2:-$INGRESS_NAME}
  local APP_PATH=${3:-$APP_NAME}
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
  kcingls ${APP_NAME}
}
