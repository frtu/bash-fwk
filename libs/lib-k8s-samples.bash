import lib-k8s

# https://kubernetes.io/docs/tutorials/kubernetes-basics/
ksdp() {
  usage $# "[DEPLOYMENT_NAME:sample]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local DEPLOYMENT_NAME=${1:-sample}
  echo "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${DEPLOYMENT_NAME}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ${DEPLOYMENT_NAME}
  template:
    metadata:
      labels:
        app: ${DEPLOYMENT_NAME}
    spec:
      containers:
      - name: ${DEPLOYMENT_NAME}
        image: gcr.io/kubernetes-e2e-test-images/echoserver:2.1
        ports:
        - containerPort: 8080
" | kubectl apply -f -
}
