import lib-docker

# - https://hub.docker.com/r/jupyter/all-spark-notebook/
DCK_IMAGE_SPARK=jupyter/all-spark-notebook

dsstart() {
  usage $# "INSTANCE_NAME:spark" "[NOTEBOOK_PORT]" "[USER_HOME:$USER]"

  local INSTANCE_NAME=${1:-spark}
  local NOTEBOOK_PORT=${2:-8888}
  local USER_HOME=${3:-$USER}

  local OPTIONAL_ARGS="-p ${NOTEBOOK_PORT}:8888 -v $PWD:/home/${USER_HOME}/work"
  dckstartdaemon jupyter/all-spark-notebook ${INSTANCE_NAME} ${OPTIONAL_ARGS}
  dcklogs ${INSTANCE_NAME}

  dckmport ${NOTEBOOK_PORT}  
}
