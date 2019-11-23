import lib-ssocks

inst_pip() {
  apt -y install python3-pip
}
inst_ssocks() {
  usage $# "PASSWORD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local PASSWORD=$1
  local HOSTNAME=`hostname -I`

  inst_pip
  sudo pip3 install shadowsocks
  
  ssconf ${PASSWORD} ${HOSTNAME}

  STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
      echo "Installation Success!"
      echo "- sudo vi /usr/local/lib/python3.6/dist-packages/shadowsocks/crypto/openssl.py"
      echo "- Change all : EVP_CIPHER_CTX_cleanup => EVP_CIPHER_CTX_reset"
      echo ""
      echo "Launch and Stop application with :"
      echo "> ssstart"
      echo "> ssstop"
    else
      echo "== Install error, please read logs. ==" >&2
  fi
}
inst_youtube() {
  apt -y install youtube-dl
}

inst_docker_ubuntu() {
  # FOLOW : https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce
  apt install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt update
  apt install -y docker-ce
  sudo docker run hello-world
  sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}
inst_minikube_standalone_ubuntu() {
  echo "Install Docker to allow K8S to work on standalone"
  echo "-------------------------------------------------"
  inst_docker_ubuntu

  echo "Install Minikube"
  echo "-------------------------------------------------"
  sudo apt-get update && sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl

  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
  sudo mkdir -p /usr/local/bin/
  sudo install minikube /usr/local/bin/

  k8mloadpersist minikube --vm-driver=none
}

inst_node() {
  usage $# "VERSION:10/12"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local VERSION=$1

  apt install curl
  curl -sL https://deb.nodesource.com/setup_${VERSION}.x | sudo -E bash -

  apt update
  apt install nodejs

  enablelib dev-node
  njversion
}
inst_node10() {
  inst_node 10
}
uninst_node() {
  uninst nodejs
  apt autoremove --purge
}