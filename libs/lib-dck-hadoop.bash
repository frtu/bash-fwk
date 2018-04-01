DCK_IMAGE_HADOOP=sequenceiq/hadoop-docker:2.7.0

dhmcreate(){
  dckmcreate hadoop

  # https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
  DCK_IMAGE_ID=${DCK_IMAGE_HADOOP//\//_}
  DCK_IMAGE_ID=${DCK_IMAGE_ID//\:/-}

  dckimport ${DCK_IMAGE_ID}
}
dhmstart() {
  dckmstart hadoop
}
dhmstop() {
  dckmstop hadoop
}

dhinit() {
  local DCK_INSTANCE_NAME=${1:-hadoop}

  local NAMENODE_UI_PORT=${2:-50070}
  local RESOURCE_MGR_PORT=${3:-8088}
  local HISTORY_SERVER_PORT=${4:-8188}
  local DATANODE_PORT=${5:-8042}
  local NODE_MGR_PORT=${6:-50075}

  local OPTIONAL_ARGS="-p ${NAMENODE_UI_PORT}:50070"
  OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${RESOURCE_MGR_PORT}:8088"
  OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${HISTORY_SERVER_PORT}:8188"
  OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${DATANODE_PORT}:8042"
  #OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${NODE_MGR_PORT}:50075"

  dckstartdaemon ${DCK_IMAGE_HADOOP} ${DCK_INSTANCE_NAME} "${OPTIONAL_ARGS}"
  dckmport ${NAMENODE_UI_PORT}
  dckmport ${RESOURCE_MGR_PORT}


  local FILENAME_TO_PERSIST=${SERVICE_LOCAL_BASH_PREFIX}dh-instance-${DCK_INSTANCE_NAME}-env.bash
  echo "== Enabling docker env at ${FILENAME_TO_PERSIST} =="
  echo "" >> $FILENAME_TO_PERSIST
  echo "export DCK_INSTANCE_NAME_HADOOP=${DCK_INSTANCE_NAME}" >> $FILENAME_TO_PERSIST

  echo "echo \"== Connect to NAMENODE_UI using http://localhost:${NAMENODE_UI_PORT} ==\"" > $FILENAME_TO_PERSIST
  echo "echo \"== Connect to RESOURCE_MGR using http://localhost:${RESOURCE_MGR_PORT} ==\"" >> $FILENAME_TO_PERSIST
}

# FIXME : Add script at startup
dhscript() {
  COMMAND=`{
    echo "tee /etc/bashrc <<EOF";
    echo "alias ll='ls -la'"
    echo 'export PATH=$PATH:$HADOOP_PREFIX/bin'
    echo "EOF";
  }`
  printf %s "$COMMAND" | docker exec -i ${DCK_INSTANCE_NAME} bash

  cd $HADOOP_PREFIX
  bin/hadoop version
}

dhstart() {
  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_HADOOP}
  dckstart ${DCK_INSTANCE_NAME}  

  local FILENAME_TO_PERSIST=${SERVICE_LOCAL_BASH_PREFIX}dh-instance-${DCK_INSTANCE_NAME}-env.bash
  cat $FILENAME_TO_PERSIST
}

dhbash() {
  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_HADOOP}
  dckbash ${DCK_INSTANCE_NAME}  
}

dhstop() {
  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_HADOOP}
  dckstop ${DCK_INSTANCE_NAME}
  dckps
}
