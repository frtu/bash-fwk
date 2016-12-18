load_if_exist "$SCRIPTS_FOLDER/bdockertoolbox.lib"

BOOT2DOCKER_DEFAULT_INSTANCE=default

# Load docker toolbox, if a boot2docker instances root folder is found
if [[ -d $DOCKER_MACHINES_FOLDER ]]; then
	echo "== Loading boot2docker instance named $BOOT2DOCKER_DEFAULT_INSTANCE =="
	dckmload $BOOT2DOCKER_DEFAULT_INSTANCE
fi
