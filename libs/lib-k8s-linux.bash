import lib-k8s
import lib-systemctl

# https://docs.bitnami.com/aws/infrastructure/kubernetes-sandbox/get-started/control-services/
SERVICE_NAME=kubelet

kcsrvstatus() {
  srvstatus ${SERVICE_NAME}
}
kcsrvstart() {
  srvstart ${SERVICE_NAME}
}
kcsrvstop() {
  srvstop ${SERVICE_NAME}
}
kcsrvrestart() {
  srvrestart ${SERVICE_NAME}
}
