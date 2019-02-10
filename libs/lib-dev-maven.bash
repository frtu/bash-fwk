#!/bin/sh
MVN_REPO_ROOT=~/.m2

MVN_SETTINGS=settings.xml
MVN_SETTINGS_STANDALONE=STANDALONE
MVN_SETTINGS_NEXUS_DEFAULT=NEXUS

DEPENDENCY_GAV=com.github.ferstl:depgraph-maven-plugin:3.2.0
SCHEMA_REGISTRY_GAV=io.confluent:kafka-schema-registry-maven-plugin:3.3.0

mvnsk() { # Skip all tests and enforcer
  echo "mvn -DskipTests -Denforcer.skip $@"
  mvn -DskipTests -Denforcer.skip $@
}

mvnsrc() { # Download in local repo all the source
  mvnsk dependency:resolve -Dclassifier=sources
}
mvndoc() {
  mvnsk javadoc:javadoc
}
mvnrun() {
  mvnsk exec:java
}
mvndep() { # list all dependencies, you may want to redirect the output into a file
  mvnsk dependency:tree
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
  mvnsk dependency:go-offline   
}
mvnsetversion() {
  mvnsk versions:set -DnewVersion=$1
}
mvnsetversionsnapshot() {
  mvnsk versions:set -DnewVersion=$1-SNAPSHOT
}

mvndljar() {
  if [[ "$#" < "1" ]]; then
      usage $# "GROUP_ID|GAV" "ARTIFACT_ID" "ARTIFACT_VERSION" "[TARGET_FOLDER]"
      return -1
  fi

  if [[ "$#" < "3" ]]
    then
      if [[ ! $1 == *\:* ]]; then
        usage $# "GROUP_ID|GAV" "ARTIFACT_ID" "ARTIFACT_VERSION" "[TARGET_FOLDER]"
        return -1
      fi

      local ARTIFACT_VERSION="${1##*\:}"
      local GROUP_ARTIFACT="${1%\:*}"

      local GROUP_ID="${GROUP_ARTIFACT%\:*}"
      local ARTIFACT_ID="${GROUP_ARTIFACT##*\:}"

      local TARGET_FOLDER=$2
    else
      local GROUP_ID=$1
      local ARTIFACT_ID=$2
      local ARTIFACT_VERSION=$3
      local TARGET_FOLDER=$4
  fi
  local GROUP_ID=`echo "$GROUP_ID" | sed 's/\./\//g'`
  local FILE_PATH=$ARTIFACT_ID-$ARTIFACT_VERSION.jar

  if [ -n "$TARGET_FOLDER" ]; then
    local EXTRA_ARGS="--directory-prefix=${TARGET_FOLDER} ${EXTRA_ARGS}"
  fi

  echo "wget ${EXTRA_ARGS} http://repo.maven.apache.org/maven2/${GROUP_ID}/${ARTIFACT_ID}/${ARTIFACT_VERSION}/${FILE_PATH}"
  wget ${EXTRA_ARGS} http://repo.maven.apache.org/maven2/${GROUP_ID}/${ARTIFACT_ID}/${ARTIFACT_VERSION}/${FILE_PATH}
}

mvnimportjar() {
  usage $# "GROUP_ID" "ARTIFACT_ID" "ARTIFACT_VERSION" "[FILE_PATH]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
  usage $# "SETTING_SUFFIX"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

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

mvnschemaregister() {
  usage $# "[SCHEMA_REGISTRY_URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SCHEMA_REGISTRY_URL=$1
  if [ -n "${SCHEMA_REGISTRY_URL}" ]; then
    # https://github.com/ferstl/depgraph-maven-plugin/blob/master/src/main/resources/default-style.json
    # https://github.com/ferstl/depgraph-maven-plugin/wiki/Styling
    local EXTRA_PARAM=-Dschemaregistry.url=${SCHEMA_REGISTRY_URL}
  fi  

  echo "mvn ${SCHEMA_REGISTRY_GAV}:register -Dmaven.repo.remote=https://packages.confluent.io/maven/ ${EXTRA_PARAM} ${@:2}"
  mvn ${SCHEMA_REGISTRY_GAV}:register -Dmaven.repo.remote=https://packages.confluent.io/maven/ ${EXTRA_PARAM} ${@:2}
}