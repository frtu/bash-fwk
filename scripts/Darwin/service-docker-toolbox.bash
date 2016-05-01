import lib-docker

dckmload() {
	if [ -z "$1" ]
    	then
        	local TAG_NAME=default
	    else
    	    local TAG_NAME=$1
  	fi
	eval $(/usr/local/bin/docker-machine env $TAG_NAME)
}

DOCKER_MACHINE_ROOT=~/.docker/machine
DOCKER_MACHINES_FOLDER=$DOCKER_MACHINE_ROOT/machines
if [[ -d $DOCKER_MACHINES_FOLDER ]]; then
	dckmload
fi

cddckmachine() {
	echo "Going to the folder of all docker machine virtual instance images."
	cd $DOCKER_MACHINES_FOLDER
}

dckmlist() {
	echo "List all the docker machine instance available. Usually only one : default"
	#ls $DOCKER_MACHINES_FOLDER
	/usr/local/bin/docker-machine ls
}
dckmcreate() {
	dckmtemplate "create --driver virtualbox" $1
}
dckmstart() {
	dckmtemplate "start" $1
}
dckmconfig() {
	dckmtemplate "config" $1
}
dckmip() {
	dckmtemplate "ip" $1
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
dckmrm() {
	dckmtemplate "rm" $1
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
