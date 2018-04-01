import lib-zk

export DEFAULT_KAFKA_HOSTNAME=localhost
export DEFAULT_KAFKA_PORT=9092

dkconfigpersist() {
  usage $# "DCK_INSTANCE_NAME" "[ZOOKEEPER_HOSTNAME:zookeeper]" "[FILENAME_TO_PERSIST]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "=> Find DCK_INSTANCE_NAME at " >&2
    dckps
    return -1
  fi

  local DCK_INSTANCE_NAME=$1
  local ZOOKEEPER_HOSTNAME=${2:-zookeeper}
  local FILENAME_TO_PERSIST=${3:-$SERVICE_SCR_dckkafka}
  
  echo "== Enabling docker env at ${FILENAME_TO_PERSIST} =="

  echo "" >> $FILENAME_TO_PERSIST
  echo "export DCK_INSTANCE_NAME_KAFKA=${DCK_INSTANCE_NAME}" >> $FILENAME_TO_PERSIST
  echo "export ZK_HOSTNAME=${ZOOKEEPER_HOSTNAME}" >> $FILENAME_TO_PERSIST
}

dktopicls() {
  usage $# "[DCK_INSTANCE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DCK_INSTANCE_NAME=${1:-$DCK_INSTANCE_NAME_KAFKA}
  if [ -z "$DCK_INSTANCE_NAME" ]; then echo "DCK_INSTANCE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  dktemplate "${DCK_INSTANCE_NAME}" "kafka-topics --list"
}
dktopiccreate() {
  usage $# "KAFKA_TOPIC_NAME" "[PARTITION_NUMBER]" "[REPLICATION_FACTOR]" "[DCK_INSTANCE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KAFKA_TOPIC_NAME=$1
  local PARTITION_NUMBER=${2:-1}
  local REPLICATION_FACTOR=${3:-1}

  local DCK_INSTANCE_NAME=${4:-$DCK_INSTANCE_NAME_KAFKA}
  if [ -z "$DCK_INSTANCE_NAME" ]; then echo "DCK_INSTANCE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  dktemplate "${DCK_INSTANCE_NAME}" "kafka-topics --create --topic ${KAFKA_TOPIC_NAME} --partitions ${PARTITION_NUMBER} --replication-factor ${REPLICATION_FACTOR} --if-not-exists"
}
dktopicdescribe() {
  usage $# "KAFKA_TOPIC_NAME" "[DCK_INSTANCE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KAFKA_TOPIC_NAME=$1

  local DCK_INSTANCE_NAME=${2:-$DCK_INSTANCE_NAME_KAFKA}
  if [ -z "$DCK_INSTANCE_NAME" ]; then echo "DCK_INSTANCE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  dktemplate "${DCK_INSTANCE_NAME}" "kafka-topics --describe --topic ${KAFKA_TOPIC_NAME}"
}

dkproduce() {
  usage $# "KAFKA_TOPIC_NAME" "[MAX_MSG]" "[DCK_INSTANCE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KAFKA_TOPIC_NAME=$1
  local MAX_MSG=${2:-5}

  local DCK_INSTANCE_NAME=${3:-$DCK_INSTANCE_NAME_KAFKA}
  if [ -z "$DCK_INSTANCE_NAME" ]; then echo "DCK_INSTANCE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  echo "dckbash $DCK_INSTANCE_NAME \"kafka-verifiable-producer --topic ${KAFKA_TOPIC_NAME} --max-messages ${MAX_MSG} --broker-list ${DEFAULT_KAFKA_HOSTNAME}:${DEFAULT_KAFKA_PORT}\""
  dckbash $DCK_INSTANCE_NAME "kafka-verifiable-producer --topic ${KAFKA_TOPIC_NAME} --max-messages ${MAX_MSG} --broker-list ${DEFAULT_KAFKA_HOSTNAME}:${DEFAULT_KAFKA_PORT}"
}
dkconsume() {
  usage $# "KAFKA_TOPIC_NAME" "[DCK_INSTANCE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KAFKA_TOPIC_NAME=$1

  local DCK_INSTANCE_NAME=${2:-$DCK_INSTANCE_NAME_KAFKA}
  if [ -z "$DCK_INSTANCE_NAME" ]; then echo "DCK_INSTANCE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  dktemplate "${DCK_INSTANCE_NAME}" "kafka-console-consumer --topic ${KAFKA_TOPIC_NAME} --from-beginning"
}


dktemplate() {
  usage $# "DCK_INSTANCE_NAME" "FULL_CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DCK_INSTANCE_NAME=$1
  local FULL_CMD=${@:2}

  ZOOKEEPER_HOSTNAME=${ZK_HOSTNAME:-$DEFAULT_ZOOKEEPER_HOSTNAME}

  echo "dckbash $DCK_INSTANCE_NAME \"${FULL_CMD} --zookeeper $ZOOKEEPER_HOSTNAME:$DEFAULT_ZOOKEEPER_PORT\""
  dckbash $DCK_INSTANCE_NAME "${FULL_CMD} --zookeeper $ZOOKEEPER_HOSTNAME:$DEFAULT_ZOOKEEPER_PORT"
}
