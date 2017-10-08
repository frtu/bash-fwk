import lib-docker
import lib-virtualbox

DOCKER_MACHINE_ROOT=~/.docker/machine
DOCKER_MACHINES_FOLDER=$DOCKER_MACHINE_ROOT/machines

DOCKER_PERSIST_FILE=$LOCAL_SCRIPTS_FOLDER/env-docker-instance.bash

cddckinstances() {
	echo "Going to the folder of all docker machine virtual instance images."
	cd $DOCKER_MACHINES_FOLDER
}
dckmls() {
	echo "List all the docker machine instance available. Usually only one : default"
	#ls $DOCKER_MACHINES_FOLDER
	docker-machine ls
}

dckmnginx() {
  dcknginx $@
  if [ -n "$2" ]; then
    dckmport $2
  fi
}
dckmphp() {
  dckphp $@
  if [ -n "$2" ]; then
    dckmport $2
  fi
}

# Regular scripts
dckmload() {
	local IMAGE_NAME=${1:-$DOCKER_MACHINE_NAME}
	echo "dckmload $IMAGE_NAME"
	eval $(docker-machine env $IMAGE_NAME)
}
dckmloadpersist() {
  local IMAGE_NAME=${1:-$DOCKER_MACHINE_NAME}
	dckmload $IMAGE_NAME
  echo "Persiting BOOT2DOCKER_DEFAULT_INSTANCE=$IMAGE_NAME!"
  echo "export BOOT2DOCKER_DEFAULT_INSTANCE=$IMAGE_NAME" > $DOCKER_PERSIST_FILE
}
dckmloadunset() {
  echo "unset BOOT2DOCKER_DEFAULT_INSTANCE"
  unset BOOT2DOCKER_DEFAULT_INSTANCE
  
  echo "rm $DOCKER_PERSIST_FILE"
  rm $DOCKER_PERSIST_FILE
}

dckmstart() {
	dckmtemplate "start" $1
	dckmload $1
}
dckmstop() {
	dckmtemplate "stop" $1
}
dckmrestart() {
	dckmtemplate "restart" $1
	dckmload $1
}
dckmtemplate() {
  local IMAGE_NAME=${2:-$DOCKER_MACHINE_NAME}

	echo "docker-machine $1 $IMAGE_NAME"
	docker-machine $1 $IMAGE_NAME
}

# Administrative
dckmscp() {
	docker-machine scp $2 $1:$3
}
## dckmssh IMAGE_NAME [CMD_LINE] [CMD_LINE] [CMD_LINE]
dckmssh() {
	if [ -z "$2" ]
  	then
		  dckmtemplate "ssh" $1
    else
      local IMAGE_NAME=$1
      shift 1
      echo "CALL : root@$IMAGE_NAME> $@"
      echo "$@" | dckmtemplate "ssh" $IMAGE_NAME
	fi
}

dckmip() {
  local IMAGE_NAME=${1:-$DOCKER_MACHINE_NAME}

	export DOCKER_MACHINE=`docker-machine ip $IMAGE_NAME`
	echo "docker-machine ip $IMAGE_NAME => export DOCKER_MACHINE=$DOCKER_MACHINE"
}
# https://docs.docker.com/engine/userguide/networking/
dckmnethosts() {
  local IMAGE_NAME=${1:-$DOCKER_MACHINE_NAME}
	dckmssh $IMAGE_NAME "cat /etc/hosts"
}
dckmport() {
  if [ $# -eq 0 ]; then
    echo "Please specify a PORT and optionally an \[IMAGE_NAME\]. If you don't know any names run 'dckmls' and look at the first column NAMES"
    dckmls
    return -1
  fi
  
  local PORT=$1
  local IMAGE_NAME=${2:-$DOCKER_MACHINE_NAME}

  vboxport $IMAGE_NAME $PORT
}

dckmprofile() {
  local IMAGE_NAME=${1:-$DOCKER_MACHINE_NAME}
	dckmssh $IMAGE_NAME "cat /var/lib/boot2docker/profile"
}
dckmconfig() {
	dckmtemplate "config" $1
}

# https://github.com/boot2docker/boot2docker#insecure-registry
dckmregistryinsecure() {
  local IMAGE_NAME=${2:-$DOCKER_MACHINE_NAME}

	dckmssh $IMAGE_NAME "echo $'EXTRA_ARGS=\"\$EXTRA_ARGS --insecure-registry http://$1\"' | sudo tee -a /var/lib/boot2docker/profile"
	echo "DON'T FORGET TO RESTART using : dckmrestart IMAGE_NAME"
}
dckmregistry() {
  local IMAGE_NAME=${2:-$DOCKER_MACHINE_NAME}

	dckmssh $IMAGE_NAME "echo $'EXTRA_ARGS=\"\$EXTRA_ARGS --registry-mirror https://$1\"' | sudo tee -a /var/lib/boot2docker/profile"
	echo "DON'T FORGET TO RESTART using : dckmrestart IMAGE_NAME"
}

# https://docs.docker.com/machine/migrate-to-machine/
dckmcreate() {
  local IMAGE_NAME=${1:-default}

	dckmtemplate "create --driver virtualbox" $IMAGE_NAME
  dckmload $IMAGE_NAME
}
# Fix & desctructive
dckmrm() {
  if [ $# -eq 0 ]; then
    echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckmls' and look at the first column NAMES"
    dckmls
    return -1
  fi
  dckmtemplate "rm" $1
}
dckmgencerts() {
  if [ $# -eq 0 ]; then
    echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckmls' and look at the first column NAMES"
    dckmls
    return -1
  fi
  dckmtemplate "regenerate-certs" $1
}

dckmpatchiso() {
	cpsafe ~/VMs/_archives_/boot2docker-*.iso $DOCKER_MACHINE_ROOT/cache/boot2docker.iso
}

#Downloading /Users/fred/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v1.11.0/boot2docker.iso...
