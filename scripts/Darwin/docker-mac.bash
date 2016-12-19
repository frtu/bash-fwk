DOCKER_OSX_ROOT=/Users/fred/Library/Group\ Containers/group.com.docker/bin

dckactive() {
  echo "import lib-docker" > ~/scripts/service-docker.bash	
}

# Docker machine
dckmenv() {
	env | grep DOCKER
}
dckmunset() {
	unset ${!DOCKER_*}
}

dckmactivate() {
  mv docker.backup docker
  mv docker-compose.backup docker-compose
  mv docker-machine.backup docker-machine
  srv_activate dockertoolbox
  reload
}
dckmdeactivate() {
  dckmunset
  mv docker docker.backup
  mv docker-compose docker-compose.backup
  mv docker-machine docker-machine.backup
}

dckosxdeactivate() {
  rm $USR_BIN/docker
  rm $USR_BIN/docker-compose
  rm $USR_BIN/docker-machine
}
dckosxactivate() {
  ln -s "$DOCKER_OSX_ROOT/docker" "$USR_BIN/docker"
  ln -s "$DOCKER_OSX_ROOT/docker-compose" "$USR_BIN/docker-compose"
  ln -s "$DOCKER_OSX_ROOT/docker-machine" "$USR_BIN/docker-machine"
}