#!/bin/sh
sprun() {
  echo "mvn spring-boot:run"
  mvnsk spring-boot:run
}

splog() {
  usage $# "LOGGER_NAME" "[BASE_URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Please pass a parameter LOGGER_NAME"
    splogtpl ""
    return 1
  fi

  local LOGGER_NAME=$1
  local BASE_URL=$2

  splogtpl "${LOGGER_NAME}" ${BASE_URL}
}
splogset() {
  usage $# "LOGGER_NAME" "LEVEL:TRACE|DEBUG|INFO|WARN|ERROR" "[BASE_URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local LOGGER_NAME=$1
  local LEVEL=$2
  local BASE_URL=${3:-http://localhost:8080}

  local PAYLOAD="{\"configuredLevel\": \"${LEVEL}\"}"

  echo "curl -i -X POST -H 'Content-Type: application/json' -d '${PAYLOAD}' ${BASE_URL}/actuator/loggers/${LOGGER_NAME}"
  curl -i -X POST -H 'Content-Type: application/json' -d "${PAYLOAD}" ${BASE_URL}/actuator/loggers/${LOGGER_NAME}
}
splogtpl() {
  usage $# "[LOGGER_NAME]" "[BASE_URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local LOGGER_NAME=$1
  local BASE_URL=${2:-http://localhost:8080}
  local EXTRA_PARAMS=${@:3}

  echo "curl ${EXTRA_PARAMS} ${BASE_URL}/actuator/loggers/${LOGGER_NAME}"
  curl ${EXTRA_PARAMS} ${BASE_URL}/actuator/loggers/${LOGGER_NAME}
}
