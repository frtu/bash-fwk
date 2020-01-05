import lib-docker
import lib-systemctl

#alias docker-compose='sudo docker-compose'

# Ubuntu Repo : https://download.docker.com/linux/ubuntu/dists/
# Centos Repo : https://download.docker.com/linux/centos/7/x86_64/stable/Packages/

# https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/ubuntu/
# https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/centos/
export DOCKER_IMAGES_FOLDER=/var/lib/docker/
# ubuntu 14
# export DOCKER_CONFIG=/etc/default/docker
# ubuntu 16 and Centos
export DOCKER_CONFIG=/etc/docker/daemon.json

cddckimages() {
  cd $DOCKER_IMAGES_FOLDER
}

activatedck() {
  srvactivate docker
  
  echo "> sudo usermod -aG docker $USER"
  sudo usermod -aG docker $USER
}
## Follow https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
dcksrvvi() {
  sudo vi $DOCKER_CONFIG
}
dcksrvcheck() {
  srvstatus docker
}
dcksrvstatus() {
  srvstatus docker
}
dcksrvstart() {
  # ubuntu 14
  # sudo service docker restart
  # ubuntu 16
  srvstart docker

  dcksrvstatus
}
dcksrvstop() {
  srvstop docker
}
dcksrvrestart() {
  srvrestart docker
}

# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
inst_kubectl() {
  # https://github.com/kubernetes/kubernetes/releases
  usage $# "[VERSION]" "[BIN_PATH:/usr/local/bin/]"

  local VERSION=$1
  local BIN_PATH=${2:-/usr/local/bin/}

  if [[ -z ${VERSION} ]]; then
    VERSION=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`
  fi
  local EXEC_URL=https://storage.googleapis.com/kubernetes-release/release/${VERSION}/bin/linux/amd64/kubectl

  inst_dl_bin "kubectl" "${EXEC_URL}" "${BIN_PATH}"
}
# https://kubernetes.io/docs/tasks/tools/install-minikube/#install-minikube-via-direct-download
inst_minikube() {
  usage $# "[VERSION:latest]" "[EXEC_URL:storage.googleapis.com/../minikube-linux-amd64]" "[BIN_PATH:/usr/local/bin/]"
  echo "== Check release version at https://github.com/kubernetes/minikube/releases =="

  local VERSION=$1
  local EXEC_URL=$2
  local BIN_PATH=${3:-/usr/local/bin/}

  if [[ -z ${EXEC_URL} ]]; then
    if [[ -z ${VERSION} ]]; then
      VERSION=latest
    fi
    local EXEC_URL=https://storage.googleapis.com/minikube/releases/${VERSION}/minikube-linux-amd64
  fi

  inst_dl_bin "minikube" "${EXEC_URL}" "${BIN_PATH}"
}
