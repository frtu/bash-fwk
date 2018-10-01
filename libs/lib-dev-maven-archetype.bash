#!/bin/sh
ARCHETYPE_VERSION=0.3.0

mvngenlocal() {
  usage $# "ARCHETYPE:kafka" "GID" "AID" "[VERSION:0.0.1-SNAPSHOT]" "[EXTRA_PARAM]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local VERSION=${4:-0.0.1-SNAPSHOT}

  mvngen $1 $2 $3 $VERSION -DarchetypeCatalog=local ${@:5}
}
mvngen() {
  usage $# "ARCHETYPE:kafka" "[GID]" "[AID]" "[VERSION:0.0.1-SNAPSHOT]" "[EXTRA_PARAM]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ARCHETYPE=$1
  local GID=$2
  local AID=$3
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

  echo "mvn archetype:generate -DarchetypeGroupId=com.github.frtu.archetype -DarchetypeArtifactId=${ARCHETYPE}-project-archetype -DarchetypeVersion=${ARCHETYPE_VERSION} ${OPTIONAL_ARGS}"
  mvn archetype:generate -DarchetypeGroupId=com.github.frtu.archetype -DarchetypeArtifactId=${ARCHETYPE}-project-archetype -DarchetypeVersion=${ARCHETYPE_VERSION} ${OPTIONAL_ARGS}
}

