import "lib-dockertoolbox"

dckmdeactivate() {
	dckmstop $BOOT2DOCKER_DEFAULT_INSTANCE
	srv_deactivate dockertoolbox
}

# Load docker toolbox, if a boot2docker instances root folder is found
if [ ! -d $DOCKER_MACHINES_FOLDER ]; then
	echo "boot2docker folder $DOCKER_MACHINES_FOLDER doesn't exist. Stop script service-dockertoolbox.bash"
	echo "=> Use cmd 'dckmdeactivate' to deactivate this service"
	return -1
fi

if [ -n "$BOOT2DOCKER_DEFAULT_INSTANCE" ]; then
	echo "== Loading boot2docker instance named $BOOT2DOCKER_DEFAULT_INSTANCE =="
	dckmstart $BOOT2DOCKER_DEFAULT_INSTANCE
	dckmload $BOOT2DOCKER_DEFAULT_INSTANCE
fi
