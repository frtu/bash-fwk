import lib-zk

export ZOOKEEPER_HOSTNAME=zookeeper

export DEFAULT_KAFKA_HOSTNAME=localhost
export DEFAULT_KAFKA_PORT=9092

kaftopiccreate() {
  usage $# "DCK_IMAGE_NAME" "KAFKA_TOPIC_NAME" "[PARTITION_NUMBER]" "[REPLICATION_FACTOR]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DCK_IMAGE_NAME=$1
  local KAFKA_TOPIC_NAME=$2
  local PARTITION_NUMBER=${3:-1}
  local REPLICATION_FACTOR=${4:-1}

  kaftemplate "${DCK_IMAGE_NAME}" "--create --topic ${KAFKA_TOPIC_NAME} --partitions ${PARTITION_NUMBER} --replication-factor ${REPLICATION_FACTOR} --if-not-exists"
}
kaftopicdescribe() {
  usage $# "DCK_IMAGE_NAME" "KAFKA_TOPIC_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DCK_IMAGE_NAME=$1
  local KAFKA_TOPIC_NAME=$2

  kaftemplate "${DCK_IMAGE_NAME}" "--describe --topic ${KAFKA_TOPIC_NAME}"
}
kafproduce() {
  usage $# "DCK_IMAGE_NAME" "KAFKA_TOPIC_NAME" "MAX_MSG"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DCK_IMAGE_NAME=$1
  local KAFKA_TOPIC_NAME=$2
  local MAX_MSG=$3

  echo "dckbash $DCK_IMAGE_NAME \"kafka-verifiable-producer --topic ${KAFKA_TOPIC_NAME} --max-messages ${MAX_MSG} --broker-list ${DEFAULT_KAFKA_HOSTNAME}:${DEFAULT_KAFKA_PORT}\""
  dckbash $DCK_IMAGE_NAME "kafka-verifiable-producer --topic ${KAFKA_TOPIC_NAME} --max-messages ${MAX_MSG} --broker-list ${DEFAULT_KAFKA_HOSTNAME}:${DEFAULT_KAFKA_PORT}"
}


kaftemplate() {
  usage $# "DCK_IMAGE_NAME" "MORE_ARG"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DCK_IMAGE_NAME=$1
  local MORE_ARG=${@:2}

  echo "dckbash $DCK_IMAGE_NAME \"kafka-topics ${MORE_ARG} --zookeeper $ZOOKEEPER_HOSTNAME:$DEFAULT_ZOOKEEPER_PORT\""
  dckbash $DCK_IMAGE_NAME "kafka-topics ${MORE_ARG} --zookeeper $ZOOKEEPER_HOSTNAME:$DEFAULT_ZOOKEEPER_PORT"
}
