import lib-docker

DOCKER_MACHINE_ROOT=~/.docker/machine
DOCKER_MACHINES_FOLDER=$DOCKER_MACHINE_ROOT/machines

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

# Regular scripts
dckmload() {
	if [ -z "$1" ]
  	then
    	local IMAGE_NAME=$DOCKER_MACHINE_NAME
    else
	    local IMAGE_NAME=$1
	fi
	echo "dckmload $IMAGE_NAME"
	eval $(docker-machine env $IMAGE_NAME)
}
dckmloadpersist() {
	dckmload
  	echo "Persiting BOOT2DOCKER_DEFAULT_INSTANCE=$DOCKER_MACHINE_NAME!"
  	echo 'export BOOT2DOCKER_DEFAULT_INSTANCE='$DOCKER_MACHINE_NAME > $LOCAL_SCRIPTS_FOLDER/env-docker-instance.bash
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
	if [ -z "$2" ]
  	then
    	local IMAGE_NAME=$DOCKER_MACHINE_NAME
    else
	    local IMAGE_NAME=$2
	fi
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
	if [ -z "$1" ]
  	then
    	local IMAGE_NAME=$DOCKER_MACHINE_NAME
    else
	    local IMAGE_NAME=$1
	fi
	export DOCKER_MACHINE=`docker-machine ip $IMAGE_NAME`
	echo "docker-machine ip $IMAGE_NAME => export DOCKER_MACHINE=$DOCKER_MACHINE"
}
# https://docs.docker.com/engine/userguide/networking/
dckmnethosts() {
	if [ -z "$1" ]
  	then
    	local IMAGE_NAME=$DOCKER_MACHINE_NAME
    else
	    local IMAGE_NAME=$1
	fi
	dckmssh $IMAGE_NAME "cat /etc/hosts"
}
dckmport() {
  if [ $# -eq 0 ]; then
    echo "Please specify a PORT and optionally an \[IMAGE_NAME\]. If you don't know any names run 'dckmls' and look at the first column NAMES"
    dckmls
    return -1
  fi
  local PORT=$1
  if [ -z "$2" ]
    then
      local IMAGE_NAME=$DOCKER_MACHINE_NAME
    else
      local IMAGE_NAME=$2
  fi
  echo "== Mapping virtualbox port=$PORT image=$IMAGE_NAME => If port already exist, you can ignore VBoxManage raised exception=="
  echo "VBoxManage controlvm $IMAGE_NAME natpf1 \"tcp-port$PORT,tcp,,$PORT,,$PORT\";"
  #VBoxManage modifyvm $IMAGE_NAME natpf1 "tcp-port$PORT,tcp,,$PORT,,$PORT";
  VBoxManage controlvm $IMAGE_NAME natpf1 "tcp-port$PORT,tcp,,$PORT,,$PORT";
}

dckmprofile() {
	if [ -z "$1" ]
  	then
    	local IMAGE_NAME=$DOCKER_MACHINE_NAME
    else
	    local IMAGE_NAME=$1
	fi
	dckmssh $IMAGE_NAME "cat /var/lib/boot2docker/profile"
}
dckmconfig() {
	dckmtemplate "config" $1
}

# https://github.com/boot2docker/boot2docker#insecure-registry
dckmregistryinsecure() {
	if [ -z "$2" ]
  	then
    	local IMAGE_NAME=$DOCKER_MACHINE_NAME
    else
	    local IMAGE_NAME=$2
	fi
	dckmssh $IMAGE_NAME "echo $'EXTRA_ARGS=\"\$EXTRA_ARGS --insecure-registry http://$1\"' | sudo tee -a /var/lib/boot2docker/profile"
	echo "DON'T FORGET TO RESTART using : dckmrestart IMAGE_NAME"
}
dckmregistry() {
	if [ -z "$2" ]
  	then
    	local IMAGE_NAME=$DOCKER_MACHINE_NAME
    else
	    local IMAGE_NAME=$2
	fi
	dckmssh $IMAGE_NAME "echo $'EXTRA_ARGS=\"\$EXTRA_ARGS --registry-mirror https://$1\"' | sudo tee -a /var/lib/boot2docker/profile"
	echo "DON'T FORGET TO RESTART using : dckmrestart IMAGE_NAME"
}

# https://docs.docker.com/machine/migrate-to-machine/
dckmcreate() {
	if [ -z "$1" ]
  	then
      	local IMAGE_NAME=default
    else
  	    local IMAGE_NAME=$1
	fi
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
