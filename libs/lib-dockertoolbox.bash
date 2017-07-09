import lib-docker

DOCKER_MACHINE_ROOT=~/.docker/machine
DOCKER_MACHINES_FOLDER=$DOCKER_MACHINE_ROOT/machines

dckmloadpersist() {
	if [ -z "$1" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$1
  	fi
  	echo "Persiting BOOT2DOCKER_DEFAULT_INSTANCE=$TAG_NAME!"
  	echo 'export BOOT2DOCKER_DEFAULT_INSTANCE='$TAG_NAME > $LOCAL_SCRIPTS_FOLDER/env-docker-instance.bash
  	dckmload $TAG_NAME
}
dckmload() {
	if [ -z "$1" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$1
  	fi
	eval $(docker-machine env $TAG_NAME)
}

cddckinstances() {
	echo "Going to the folder of all docker machine virtual instance images."
	cd $DOCKER_MACHINES_FOLDER
}

# https://docs.docker.com/machine/migrate-to-machine/
dckmcreate() {
	dckmtemplate "create --driver virtualbox" $1
}
dckmstart() {
	dckmtemplate "start" $1
	dckmload $1
}
dckmssh() {
	dckmtemplate "ssh" $1
}
dckmstop() {
	dckmtemplate "stop" $1
}
dckmrestart() {
	dckmtemplate "restart" $1
	dckmload $1
}
dckmlist() {
	echo "List all the docker machine instance available. Usually only one : default"
	#ls $DOCKER_MACHINES_FOLDER
	docker-machine ls
}
dckmip() {
	if [ -z "$1" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$1
  	fi
	export DOCKER_MACHINE=`docker-machine ip $TAG_NAME`
  	echo "docker-machine ip $TAG_NAME => export DOCKER_MACHINE=$DOCKER_MACHINE"
}
dckmrm() {
	dckmtemplate "rm" $1
}
dckmconfig() {
	dckmtemplate "config" $1
}
dckmgencerts() {
	dckmtemplate "regenerate-certs" $1
}
dckmscp() {
	docker-machine scp $2 $1:$3
}

# https://github.com/boot2docker/boot2docker#insecure-registry
dckmregistryinsecure() {
	if [ -z "$2" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$2
  	fi
	docker-machine ssh $TAG_NAME "echo $'EXTRA_ARGS=\"\$EXTRA_ARGS --insecure-registry http://$1\"' | sudo tee -a /var/lib/boot2docker/profile"
	dckmrestart $TAG_NAME
}
dckmregistry() {
	if [ -z "$2" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$2
  	fi
	docker-machine ssh $TAG_NAME "echo $'EXTRA_ARGS=\"\$EXTRA_ARGS --registry-mirror https://$1\"' | sudo tee -a /var/lib/boot2docker/profile"
	dckmrestart $TAG_NAME
}

dckmtemplate() {
	if [ -z "$2" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$2
  	fi
  	echo "docker-machine $1 $TAG_NAME"
	docker-machine $1 $TAG_NAME
}

dckmpatchiso() {
	cpsafe ~/VMs/_archives_/boot2docker-*.iso $DOCKER_MACHINE_ROOT/cache/boot2docker.iso
}

#Downloading /Users/fred/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v1.11.0/boot2docker.iso...
