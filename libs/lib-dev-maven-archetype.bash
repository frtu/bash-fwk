#!/bin/sh
mvngenlocal() {
  usage $# "ARCHETYPE:base|kotlin|plt-kafka|plt-spark|avro" "AID" "[GID]" "[VERSION:0.0.1-SNAPSHOT]" "[EXTRA_PARAM]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local VERSION=${4:-0.0.1-SNAPSHOT}

  local GID=${3:-$DEFAULT_GID}
  if [[ -z $GID ]]; then 
    local GID=$2 
  fi

  mvngen $1 $2 ${GID} ${VERSION} -DarchetypeCatalog=local ${@:5}
}
mvngen() {
  usage $# "ARCHETYPE:base|kotlin|plt-kafka|plt-spark|avro" "[AID]" "[GID]" "[VERSION:0.0.1-SNAPSHOT]" "[EXTRA_PARAM]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local ARCHETYPE=$1
  local AID=$2
  local GID=${3:-$DEFAULT_GID}
  local VERSION=${4:-0.0.1-SNAPSHOT}

  local OPTIONAL_ARGS=${@:5}
  if [ -n "${GID}" ]; then
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -DgroupId=${GID}"
  fi
  if [ -n "${AID}" ]; then
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -DartifactId=${AID}"
  fi
  if [ -n "${VERSION}" ]; then
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -Dversion=${VERSION}"
  fi

  echo "= Override version using 'enablemvngen [ARCHETYPE_VERSION]' current ARCHETYPE_VERSION=${ARCHETYPE_VERSION} ="

  echo "mvn archetype:generate -DarchetypeGroupId=com.github.frtu.archetype -DarchetypeArtifactId=${ARCHETYPE}-project-archetype -DarchetypeVersion=${ARCHETYPE_VERSION} ${OPTIONAL_ARGS}"
  mvn archetype:generate -DarchetypeGroupId=com.github.frtu.archetype -DarchetypeArtifactId=${ARCHETYPE}-project-archetype -DarchetypeVersion=${ARCHETYPE_VERSION} ${OPTIONAL_ARGS}
}
# https://github.com/openjdk/jmh
mvngenbenchmark() {
  # https://repo.maven.apache.org/maven2/org/openjdk/jmh/
  usage $# "ARCHETYPE:java|kotlin|groovy|scala|simple" "[AID]" "[GID]" "[VERSION:0.0.1-SNAPSHOT]" "[EXTRA_PARAM]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local ARCHETYPE=$1
  local AID=$2
  local GID=${3:-$DEFAULT_GID}
  local VERSION=${4:-0.0.1-SNAPSHOT}

  local OPTIONAL_ARGS=${@:5}
  if [ -n "${GID}" ]; then
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -DgroupId=${GID}"
  fi
  if [ -n "${AID}" ]; then
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -DartifactId=${AID}"
  fi
  if [ -n "${VERSION}" ]; then
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -Dversion=${VERSION}"
  fi

  echo "= Override version using 'enablemvngen [ARCHETYPE_VERSION]' current ARCHETYPE_VERSION=${ARCHETYPE_VERSION} ="

  echo "mvn archetype:generate -DinteractiveMode=false -DarchetypeGroupId=org.openjdk.jmh -DarchetypeArtifactId=jmh-${ARCHETYPE}-benchmark-archetype ${OPTIONAL_ARGS}"
  mvn archetype:generate -DinteractiveMode=false -DarchetypeGroupId=org.openjdk.jmh -DarchetypeArtifactId=jmh-${ARCHETYPE}-benchmark-archetype ${OPTIONAL_ARGS}
}
mvninst() {
  echo "mvn clean install"
  mvn clean install
}
