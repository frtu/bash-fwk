import lib-k8s-minikube

export DOCKER_REGISTRY_CN=https://docker.mirrors.ustc.edu.cn

# https://yq.aliyun.com/articles/221687
inst_cn_minikube() {
  local MINIKUBE_VERSION=1.5.1
  local MINIKUBE_URL_EXEC=https://github.com/kubernetes/minikube/releases/download/v${MINIKUBE_VERSION}/minikube-darwin-amd64
#  local MINIKUBE_URL_EXEC=http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-darwin-amd64
  local MINIKUBE_URL_ISO=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v${MINIKUBE_VERSION}.iso

  echo "Install Docker to allow K8S to work on standalone"
  echo "-------------------------------------------------"
  echo "> Download EXEC from ${MINIKUBE_URL_EXEC}"
  curl -Lo minikube ${MINIKUBE_URL_EXEC} && chmod +x minikube && sudo mv minikube /usr/local/bin/
  echo "> Download ISO from ${MINIKUBE_URL_ISO}"
  kmstartcn --iso-url=${MINIKUBE_URL_ISO}

  kmenv
}

kmstartcnvbox() {
  kmstartcn --vm-driver=virtualbox
}
kmstartcn() {
  kmstartreg "minikube" "${DOCKER_REGISTRY_CN}" " --image-mirror-country cn" $@
}
