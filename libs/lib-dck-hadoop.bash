import lib-docker

# Based on Centos 6.5 : https://github.com/sequenceiq/hadoop-docker/blob/master/Dockerfile
# Hadoop : 2.7.0 2015-04-10T18:40Z
DCK_IMAGE_HADOOP=sequenceiq/hadoop-docker:2.7.0

dhmcreate(){
  # Loading optional dockertoolbox
  import lib-dockertoolbox

  dckmcreate hadoop

  # https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
  DCK_IMAGE_ID=${DCK_IMAGE_HADOOP//\//_}
  DCK_IMAGE_ID=${DCK_IMAGE_ID//\:/-}

  dckimport ${DCK_IMAGE_ID}

  echo "if not done, enable dockertoolbox permanently with > enabledockertoolbox"
}
dhmstart() {
  dckmstart hadoop
}
dhmstop() {
  dckmstop hadoop
}

dhinit() {
  echo "Usage : ${FUNCNAME[0]} [DCK_INSTANCE_NAME] [VOLUME] [NAMENODE_UI_PORT] [RESOURCE_MGR_PORT] [HISTORY_SERVER_PORT] [DATANODE_PORT] [NODE_MGR_PORT]"
  echo "- ${FUNCNAME[0]} hadoop \$PWD => Map the local folder to the /root for convenience"

  local DCK_INSTANCE_NAME=${1:-hadoop}
  local VOLUME=$2

  local NAMENODE_UI_PORT=${3:-50070}
  local RESOURCE_MGR_PORT=${4:-8088}
  local HISTORY_SERVER_PORT=${5:-8188}
  local DATANODE_PORT=${6:-8042}
  local NODE_MGR_PORT=${7:-50075}

  local OPTIONAL_ARGS="-p ${NAMENODE_UI_PORT}:50070"
  OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${RESOURCE_MGR_PORT}:8088"
  OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${HISTORY_SERVER_PORT}:8188"
  OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${DATANODE_PORT}:8042"
  #OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${NODE_MGR_PORT}:50075"

  local FILENAME_TO_PERSIST=${SERVICE_LOCAL_BASH_PREFIX}dh-instance-${DCK_INSTANCE_NAME}-env.bash

  if [ -n "$VOLUME" ]; then
    echo "=> A Volume has been defined '$VOLUME'. Map it to the /root folder inside the VM"
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -v ${VOLUME}:/root/"

    echo "echo \"> cd${DCK_INSTANCE_NAME}() : Go to the mapped volume of hadoop /root \"" > $FILENAME_TO_PERSIST
    echo "" >> $FILENAME_TO_PERSIST
    echo "cd${DCK_INSTANCE_NAME}() { cd ${VOLUME}; }" >> $FILENAME_TO_PERSIST
    source $FILENAME_TO_PERSIST
  fi

  dckstartdaemon ${DCK_IMAGE_HADOOP} ${DCK_INSTANCE_NAME} "${OPTIONAL_ARGS}"
  dckmport ${NAMENODE_UI_PORT}
  dckmport ${RESOURCE_MGR_PORT}

  echo "== Enabling docker env at ${FILENAME_TO_PERSIST} =="
  echo "" >> $FILENAME_TO_PERSIST
  echo "export DCK_INSTANCE_NAME_HADOOP=${DCK_INSTANCE_NAME}" >> $FILENAME_TO_PERSIST

  echo "echo \"== Connect to NAMENODE_UI using http://localhost:${NAMENODE_UI_PORT} ==\"" >> $FILENAME_TO_PERSIST
  echo "echo \"== Connect to RESOURCE_MGR using http://localhost:${RESOURCE_MGR_PORT} ==\"" >> $FILENAME_TO_PERSIST
}

INNER_BASE_PATH=/root/scr-local/base.bash
dhscript() {
  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_HADOOP}
  local BASH_SCRIPT=${2:-/root/.bashrc}
  COMMAND=`{
    echo "tee ${BASH_SCRIPT} <<EOF";
    echo "alias ll='ls -la'"
    echo "source ${INNER_BASE_PATH}"
    echo "EOF";
  }`
  printf %s "$COMMAND" | docker exec -i ${DCK_INSTANCE_NAME} bash

  dhscriptpath
}
dhscriptbase() {
  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_HADOOP}
  COMMAND=`{
    echo "tee ${INNER_BASE_PATH} <<EOF";
    echo 'export PATH=$PATH:$HADOOP_PREFIX/bin'
    echo 'cdhadoop() { cd ${HADOOP_PREFIX}; }'
    echo "EOF";
  }`
  printf %s "$COMMAND" | docker exec -i ${DCK_INSTANCE_NAME} bash
}

dhstart() {
  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_HADOOP}
  dckstart ${DCK_INSTANCE_NAME}

  local FILENAME_TO_PERSIST=${SERVICE_LOCAL_BASH_PREFIX}dh-instance-${DCK_INSTANCE_NAME}-env.bash
  source $FILENAME_TO_PERSIST
}

dhbash() {
  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_HADOOP}
  dckbash ${DCK_INSTANCE_NAME} ${@:2}
}

dhstop() {
  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_HADOOP}
  dckstop ${DCK_INSTANCE_NAME}
  dckps
}
