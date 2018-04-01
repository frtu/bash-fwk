import lib-zk

export DEFAULT_KAFKA_HOSTNAME=localhost
export DEFAULT_KAFKA_PORT=9092

kafdckconfigpersist() {
  usage $# "DCK_IMAGE_NAME" "[ZOOKEEPER_HOSTNAME:zookeeper]" "[FILENAME_TO_PERSIST]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "=> Find DCK_IMAGE_NAME at " >&2
    dckps
    return -1
  fi

  local DCK_IMAGE_NAME=$1
  local ZOOKEEPER_HOSTNAME=${2:-zookeeper}
  local FILENAME_TO_PERSIST=${3:-$SERVICE_SCR_dckkafka}
  
  echo "== Enabling docker env at ${FILENAME_TO_PERSIST} =="

  echo "" >> $FILENAME_TO_PERSIST
  echo "export KAFKA_DCK_IMAGE_NAME=${DCK_IMAGE_NAME}" >> $FILENAME_TO_PERSIST
  echo "export ZK_HOSTNAME=${ZOOKEEPER_HOSTNAME}" >> $FILENAME_TO_PERSIST
}

kaftopicls() {
  usage $# "[DCK_IMAGE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DCK_IMAGE_NAME=${1:-$KAFKA_DCK_IMAGE_NAME}
  if [ -z "$DCK_IMAGE_NAME" ]; then echo "DCK_IMAGE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  kaftemplate "${DCK_IMAGE_NAME}" "kafka-topics --list"
}
kaftopiccreate() {
  usage $# "KAFKA_TOPIC_NAME" "[PARTITION_NUMBER]" "[REPLICATION_FACTOR]" "[DCK_IMAGE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KAFKA_TOPIC_NAME=$1
  local PARTITION_NUMBER=${2:-1}
  local REPLICATION_FACTOR=${3:-1}

  local DCK_IMAGE_NAME=${4:-$KAFKA_DCK_IMAGE_NAME}
  if [ -z "$DCK_IMAGE_NAME" ]; then echo "DCK_IMAGE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  kaftemplate "${DCK_IMAGE_NAME}" "kafka-topics --create --topic ${KAFKA_TOPIC_NAME} --partitions ${PARTITION_NUMBER} --replication-factor ${REPLICATION_FACTOR} --if-not-exists"
}
kaftopicdescribe() {
  usage $# "KAFKA_TOPIC_NAME" "[DCK_IMAGE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KAFKA_TOPIC_NAME=$1

  local DCK_IMAGE_NAME=${2:-$KAFKA_DCK_IMAGE_NAME}
  if [ -z "$DCK_IMAGE_NAME" ]; then echo "DCK_IMAGE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  kaftemplate "${DCK_IMAGE_NAME}" "kafka-topics --describe --topic ${KAFKA_TOPIC_NAME}"
}

kafproduce() {
  usage $# "KAFKA_TOPIC_NAME" "[MAX_MSG]" "[DCK_IMAGE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KAFKA_TOPIC_NAME=$1
  local MAX_MSG=${2:-5}

  local DCK_IMAGE_NAME=${3:-$KAFKA_DCK_IMAGE_NAME}
  if [ -z "$DCK_IMAGE_NAME" ]; then echo "DCK_IMAGE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  echo "dckbash $DCK_IMAGE_NAME \"kafka-verifiable-producer --topic ${KAFKA_TOPIC_NAME} --max-messages ${MAX_MSG} --broker-list ${DEFAULT_KAFKA_HOSTNAME}:${DEFAULT_KAFKA_PORT}\""
  dckbash $DCK_IMAGE_NAME "kafka-verifiable-producer --topic ${KAFKA_TOPIC_NAME} --max-messages ${MAX_MSG} --broker-list ${DEFAULT_KAFKA_HOSTNAME}:${DEFAULT_KAFKA_PORT}"
}
kafconsume() {
  usage $# "KAFKA_TOPIC_NAME" "[DCK_IMAGE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KAFKA_TOPIC_NAME=$1

  local DCK_IMAGE_NAME=${2:-$KAFKA_DCK_IMAGE_NAME}
  if [ -z "$DCK_IMAGE_NAME" ]; then echo "DCK_IMAGE_NAME is optional ONLY after calling kafdckconfigpersist"; return -1; fi

  kaftemplate "${DCK_IMAGE_NAME}" "kafka-console-consumer --topic ${KAFKA_TOPIC_NAME} --from-beginning"
}


kaftemplate() {
  usage $# "DCK_IMAGE_NAME" "FULL_CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DCK_IMAGE_NAME=$1
  local FULL_CMD=${@:2}

  ZOOKEEPER_HOSTNAME=${ZK_HOSTNAME:-$DEFAULT_ZOOKEEPER_HOSTNAME}

  echo "dckbash $DCK_IMAGE_NAME \"${FULL_CMD} --zookeeper $ZOOKEEPER_HOSTNAME:$DEFAULT_ZOOKEEPER_PORT\""
  dckbash $DCK_IMAGE_NAME "${FULL_CMD} --zookeeper $ZOOKEEPER_HOSTNAME:$DEFAULT_ZOOKEEPER_PORT"
}
