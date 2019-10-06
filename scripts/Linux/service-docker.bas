import lib-docker

alias docker='sudo docker'

dckcheck() {
  ## Follow https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
  sudo systemctl status docker
}