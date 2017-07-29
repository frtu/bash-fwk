import "lib-dockertoolbox"

if [ -z "$BOOT2DOCKER_DEFAULT_INSTANCE" ]
  then
    local BOOT2DOCKER_DEFAULT_INSTANCE=default
fi

# Load docker toolbox, if a boot2docker instances root folder is found
if [[ -d $DOCKER_MACHINES_FOLDER ]]; then
	echo "== Loading boot2docker instance named $BOOT2DOCKER_DEFAULT_INSTANCE =="
	dckmstart $BOOT2DOCKER_DEFAULT_INSTANCE
	dckmload $BOOT2DOCKER_DEFAULT_INSTANCE
fi

dckmdeactivate() {
	dckmstop $BOOT2DOCKER_DEFAULT_INSTANCE
	srv_deactivate dockertoolbox
}
