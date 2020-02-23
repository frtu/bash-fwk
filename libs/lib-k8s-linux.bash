import lib-k8s
import lib-systemctl

# https://docs.bitnami.com/aws/infrastructure/kubernetes-sandbox/get-started/control-services/
SERVICE_NAME=kubelet

kcsrvstatus() {
  srvstatus ${SERVICE_NAME}
}
kcsrvstart() {
  srvstart ${SERVICE_NAME}
  kcsrvstatus
}
kcsrvstop() {
  srvstop ${SERVICE_NAME}
  kcsrvstatus
}
kcsrvrestart() {
  srvrestart ${SERVICE_NAME}
  kcsrvstatus
}
