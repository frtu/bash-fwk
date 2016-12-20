import lib-docker

DOCKER_MACHINE_ROOT=~/.docker/machine
DOCKER_MACHINES_FOLDER=$DOCKER_MACHINE_ROOT/machines

dckmload() {
	if [ -z "$1" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$1
  	fi
	eval $(/usr/local/bin/docker-machine env $TAG_NAME)
}

cddckinstances() {
	echo "Going to the folder of all docker machine virtual instance images."
	cd $DOCKER_MACHINES_FOLDER
}

dckmproxy() {
    echo "Setting proxy $1 in ~/scripts/service_docker_proxy.bash"
	echo 'DOCKER_OPTS=" --registry-mirror='$1'"' >> ~/scripts/service_docker_proxy.bash
}

# https://docs.docker.com/machine/migrate-to-machine/
dckmcreate() {
	dckmtemplate "create --driver virtualbox" $1
}
dckmstart() {
	dckmtemplate "start" $1
}
dckmssh() {
	dckmtemplate "ssh" $1
}
dckmstop() {
	dckmtemplate "stop" $1
}
dckmrestart() {
	dckmtemplate "restart" $1
}
dckmlist() {
	echo "List all the docker machine instance available. Usually only one : default"
	#ls $DOCKER_MACHINES_FOLDER
	/usr/local/bin/docker-machine ls
}
dckmip() {
	dckmtemplate "ip" $1
}
dckmrm() {
	dckmtemplate "rm" $1
}
dckmconfig() {
	dckmtemplate "config" $1
}
dckmscp() {
	/usr/local/bin/docker-machine scp $2 $1:$3
}

# https://github.com/boot2docker/boot2docker#insecure-registry
dckmregistryinsecure() {
	/usr/local/bin/docker-machine ssh default "echo $'EXTRA_ARGS=\"\$EXTRA_ARGS --insecure-registry $1\"' | sudo tee -a /var/lib/boot2docker/profile && sudo /etc/init.d/docker restart"
}
dckmregistry() {
	/usr/local/bin/docker-machine ssh default "echo $'EXTRA_ARGS=\"\$EXTRA_ARGS --registry-mirror $1\"' | sudo tee -a /var/lib/boot2docker/profile && sudo /etc/init.d/docker restart"
}

dckmtemplate() {
	if [ -z "$2" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$2
  	fi
  	echo "/usr/local/bin/docker-machine $1 $TAG_NAME"
	/usr/local/bin/docker-machine $1 $TAG_NAME
}

dckmpatchiso() {
	cpsafe ~/VMs/_archives_/boot2docker-*.iso $DOCKER_MACHINE_ROOT/cache/boot2docker.iso
}

#Downloading /Users/fred/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v1.11.0/boot2docker.iso...
