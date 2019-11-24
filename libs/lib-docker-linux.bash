import lib-docker

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
dckrestart() {
  # ubuntu 14
  # sudo service docker restart
  # ubuntu 16
  sudo systemctl start docker
}

# https://github.com/docker/compose/releases/download/1.11.2/docker-compose-Linux-x86_64
# https://nickjanetakis.com/blog/docker-tip-50-running-an-insecure-docker-registry