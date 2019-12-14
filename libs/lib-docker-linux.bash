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
  sudo usermod -aG docker $USER
  activate docker
}
## Follow https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
dcksrvvi() {
  sudo vi $DOCKER_CONFIG
}
dcksrvcheck() {
  status docker
}
dcksrvstatus() {
  status docker
}
dcksrvstart() {
  # ubuntu 14
  # sudo service docker restart
  # ubuntu 16
  start docker
}
dcksrvstop() {
  stop docker
}
dcksrvrestart() {
  restart docker
}

inst_dck() {
  inst docker.io
}

# https://github.com/docker/compose/releases/download/1.11.2/docker-compose-Linux-x86_64
# https://nickjanetakis.com/blog/docker-tip-50-running-an-insecure-docker-registry

inst_kubectl_linux() {
  usage $# "[BIN_PATH:/usr/local/bin/]"

  local EXEC_URL=https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  local BIN_PATH=${1:-/usr/local/bin/}

  inst_dl_bin "kubectl" "${EXEC_URL}" "${BIN_PATH}"
}
