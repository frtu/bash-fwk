import lib-k8s-minikube

export DOCKER_REGISTRY_CN=https://docker.mirrors.ustc.edu.cn

export IMAGE_REPOSITORY=registry.cn-hangzhou.aliyuncs.com/google_containers

# https://yq.aliyun.com/articles/221687
# https://codefarm.me/2018/08/09/http-proxy-docker-minikube/
inst_cn_minikube() {
  local MINIKUBE_VERSION=1.5.1
  local MINIKUBE_URL_EXEC=https://github.com/kubernetes/minikube/releases/download/v${MINIKUBE_VERSION}/minikube-darwin-amd64
#  local MINIKUBE_URL_EXEC=http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-darwin-amd64
  local MINIKUBE_URL_ISO=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v${MINIKUBE_VERSION}.iso

  echo "Install Docker to allow K8S to work on standalone"
  echo "-------------------------------------------------"
  echo "> Download EXEC from ${MINIKUBE_URL_EXEC}"
  inst_dl_bin "minikube" "${MINIKUBE_URL_EXEC}"

  echo "> Download ISO from ${MINIKUBE_URL_ISO}"
  kmstartcn --iso-url=${MINIKUBE_URL_ISO}

  kmenv
}

kmstartcnvbox() {
  kmstartcn --vm-driver=virtualbox
}
kmstartcn() {
  kmstartreg "minikube" "${DOCKER_REGISTRY_CN}" " --image-mirror-country cn" "--image-repository ${IMAGE_REPOSITORY}" $@
}
kchellocn() {
  kchello ${IMAGE_REPOSITORY}
}
