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
