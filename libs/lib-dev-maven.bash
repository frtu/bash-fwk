#!/bin/sh
MVN_REPO_ROOT=~/.m2

MVN_SETTINGS=settings.xml
MVN_SETTINGS_STANDALONE=STANDALONE
MVN_SETTINGS_NEXUS_DEFAULT=NEXUS

DEPENDENCY_GAV=com.github.ferstl:depgraph-maven-plugin:3.2.0
ARCHETYPE_VERSION=0.3.0

mvnsk() { # Skip all tests and enforcer
  mvn -DskipTests -Denforcer.skip $@
}

mvnsrc() { # Download in local repo all the source
  mvn dependency:resolve -Dclassifier=sources
}
mvndep() { # list all dependencies, you may want to redirect the output into a file
  mvn dependency:tree
}
mvndepgraph() {
  usage $# "[CONFIG_FILE]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "[CONFIG_FILE], [FOR MORE PARAM : -Dincludes=gav*]"
  echo "PARAM : https://github.com/ferstl/depgraph-maven-plugin"

  local CONFIG_FILE=$1
  if [ -f "${CONFIG_FILE}" ]; then
    # https://github.com/ferstl/depgraph-maven-plugin/blob/master/src/main/resources/default-style.json
    # https://github.com/ferstl/depgraph-maven-plugin/wiki/Styling
    EXTRA_PARAM=-DcustomStyleConfiguration=${CONFIG_FILE}
  fi  

  # https://ferstl.github.io/depgraph-maven-plugin/plugin-info.html
  echo "mvn ${DEPENDENCY_GAV}:graph -DcreateImage=true -DshowGroupIds=true ${EXTRA_PARAM} ${@:2}"
  mvn ${DEPENDENCY_GAV}:graph -DcreateImage=true -DshowGroupIds=true ${EXTRA_PARAM} ${@:2}
}
mvndepaggregate() {
  usage $# "[CONFIG_FILE]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "[CONFIG_FILE], [FOR MORE PARAM : -Dincludes=gav*]"
  echo "PARAM : https://github.com/ferstl/depgraph-maven-plugin"

  local CONFIG_FILE=$1
  if [ -f "${CONFIG_FILE}" ]; then
    # https://github.com/ferstl/depgraph-maven-plugin/blob/master/src/main/resources/default-style.json
    # https://github.com/ferstl/depgraph-maven-plugin/wiki/Styling
    EXTRA_PARAM=-DcustomStyleConfiguration=${CONFIG_FILE}
  fi  

  # https://ferstl.github.io/depgraph-maven-plugin/plugin-info.html
  echo "mvn ${DEPENDENCY_GAV}:aggregate -DcreateImage=true -DshowGroupIds=true ${EXTRA_PARAM} ${@:2}"
  mvn ${DEPENDENCY_GAV}:aggregate -DcreateImage=true -DshowGroupIds=true ${EXTRA_PARAM} ${@:2}
}
mvndepoffline() {
  mvn dependency:go-offline   
}
mvnsetversion() {
  mvnsk versions:set -DnewVersion=$1
}
mvnsetversionsnapshot() {
  mvnsk versions:set -DnewVersion=$1-SNAPSHOT
}

mvnimportjar() {
  # MIN NUM OF ARG
  if [[ "$#" < "3" ]]; then
      echo "Usage : mvnimportjar GROUP_ID ARTIFACT_ID ARTIFACT_VERSION [FILE_PATH]" >&2
      return -1
  fi

  local GROUP_ID=$1
  local ARTIFACT_ID=$2
  local ARTIFACT_VERSION=$3
  local FILE_PREFIX=$ARTIFACT_ID-$ARTIFACT_VERSION
  local FILE_PATH=${4:-$FILE_PREFIX.jar}

  local SOURCE_PATH="${FILE_PREFIX}-sources.jar"
  local POM_PATH="${FILE_PREFIX}.pom"

  if [ ! -f "$FILE_PATH" ]; then
    echo "Cannot find $FILE_PATH. Please specify the optional parmater FILE_PATH" >&2
    echo "Usage : mvnimportjar GROUP_ID ARTIFACT_ID ARTIFACT_VERSION [FILE_PATH]" >&2
    return -1
  fi  
  echo "mvn install:install-file -Dfile=$FILE_PATH -DgroupId=$GROUP_ID -DartifactId=$ARTIFACT_ID -Dversion=$ARTIFACT_VERSION -Dpackaging=jar -DgeneratePom=true"
  mvn install:install-file -Dfile=$FILE_PATH -DgroupId=$GROUP_ID -DartifactId=$ARTIFACT_ID -Dversion=$ARTIFACT_VERSION -Dpackaging=jar -DgeneratePom=true
}

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

mvnrepoinit() {
  local MVN_SETTINGS_ID=${1:-$MVN_SETTINGS}

  L_MVN_SETTINGS_FILE=settings-$MVN_SETTINGS_ID.xml
  if [ ! -f "$MAVEN_HOME/conf/$MVN_SETTINGS" ] 
    then
      echo "== Couldn't find default setting at '$MAVEN_HOME/conf/$MVN_SETTINGS'. Please set MAVEN_HOME correctly! ==" >&2
    else
      echo "== Initialize the file with default setting at '$MAVEN_HOME/conf/$MVN_SETTINGS' =="
      cp "$MAVEN_HOME/conf/$MVN_SETTINGS" "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE"
  fi
}

mvnrepopatch() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
      echo "== You must pass a first parameter of the target maven settings file. ==" >&2
      return -1
  fi

  local L_MVN_SETTINGS_FILE=settings-$1.xml

  if [ ! -f "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" ]; then
      echo "== Couldn't find setting at '$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE'. ==" >&2
      return -1
  fi

  cp "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" "$MVN_REPO_ROOT/$MVN_SETTINGS"
}

mvnrepostandalone() {
  local L_MVN_SETTINGS_FILE=settings-$MVN_SETTINGS_STANDALONE.xml

  # If MVN_SETTINGS_STANDALONE doesn't exist, try to use Maven one
  if [ ! -f "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" ]; then
      mvnrepoinit $MVN_SETTINGS_STANDALONE
  fi
  mvnrepopatch $MVN_SETTINGS_STANDALONE
}

mvnreponexus() {
  local MVN_SETTINGS_ID=${1:-$MVN_SETTINGS_NEXUS_DEFAULT}
  
  L_MVN_SETTINGS_FILE=settings-$MVN_SETTINGS_ID.xml
  # If MVN_SETTINGS_STANDALONE doesn't exist, try to use Maven one
  if [ ! -f "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" ]; then
      mvnrepoinit "$MVN_SETTINGS_ID.rename"
      echo "== You must edit the file 'settings-$MVN_SETTINGS_ID.rename.xml' and add a mirrors.mirror.url the correct repo URL value. Remove the .rename suffix when you're done. =="
      return -1
  fi
  mvnrepopatch $MVN_SETTINGS_ID
}

mvnrepoclean() { # Remove all trace of orginal repo from local repo (avoid SNAPSHOT to search for nexus when you cannot reach it)
  find $MVN_REPO_ROOT/repository -type f -name "_remote.repositories" -exec echo {} \; -exec rm -f {} \;
  find $MVN_REPO_ROOT/repository -type f -name "resolver-status.properties" -exec echo {} \; -exec rm -f {} \;
  find $MVN_REPO_ROOT/repository -type f -name "maven-metadata-nexus.*" -exec echo {} \; -exec rm -f {} \;
}
