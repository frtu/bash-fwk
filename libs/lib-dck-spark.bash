import lib-docker

# - https://hub.docker.com/r/jupyter/all-spark-notebook/
DCK_IMAGE_SPARK=jupyter/all-spark-notebook

dsstart() {
  usage $# "INSTANCE_NAME:spark" "[NOTEBOOK_PORT]" "[USER_HOME:$USER]"

  local INSTANCE_NAME=${1:-spark}
  local NOTEBOOK_PORT=${2:-8888}
  local USER_HOME=${3:-$USER}

  local OPTIONAL_ARGS="-p ${NOTEBOOK_PORT}:8888 -v $PWD:/home/${USER_HOME}/work -e NB_USER=${USER_HOME}"
  dckstartdaemon jupyter/all-spark-notebook ${INSTANCE_NAME} ${OPTIONAL_ARGS}
  dcklogs ${INSTANCE_NAME}

  dckmport ${NOTEBOOK_PORT}  
}

dsnstart() {
  usage $# "INSTANCE_NAME:spark-notebook" "[LIVY_PORT]" "[USER_HOME:jovyan]"

  local INSTANCE_NAME=${1:-sparkmagic}
  local LIVY_PORT=${2:-$8998}
  local USER_HOME=${3:-jovyan}

  # https://github.com/jupyter-incubator/sparkmagic/blob/master/docker-compose.yml
  local OPTIONAL_ARGS="-p ${LIVY_PORT}:8998  -v $PWD:/home/${USER_HOME}/data"
  dckstartdaemon peralozac/sparkmagic_spark:latest ${INSTANCE_NAME} ${OPTIONAL_ARGS}
  dcklogs ${INSTANCE_NAME}

  dckmport ${NOTEBOOK_PORT}
}
