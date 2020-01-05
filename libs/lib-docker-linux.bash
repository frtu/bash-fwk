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
