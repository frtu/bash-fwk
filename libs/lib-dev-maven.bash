#!/bin/sh
MVN_REPO_ROOT=~/.m2

MVN_SETTINGS=settings.xml
MVN_SETTINGS_STANDALONE=STANDALONE
MVN_SETTINGS_NEXUS_DEFAULT=NEXUS

mvnsk() { # Skip all tests and enforcer
  mvn -DskipTests -Denforcer.skip $@
}

mvnsrc() { # Download in local repo all the source
  mvn dependency:resolve -Dclassifier=sources
}
mvndep() { # list all dependencies, you may want to redirect the output into a file
  mvn dependency:tree
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

mvnrepodefault() {
  local MVN_SETTINGS_ID=${1:-$MVN_SETTINGS}

  L_MVN_SETTINGS_FILE=settings-$MVN_SETTINGS.xml
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
      mvnrepodefault $MVN_SETTINGS_STANDALONE
  fi
  mvnrepopatch $MVN_SETTINGS_STANDALONE
}

mvnreponexus() {
  local MVN_SETTINGS_ID=${1:-$MVN_SETTINGS_NEXUS_DEFAULT}
  
  L_MVN_SETTINGS_FILE=settings-$MVN_SETTINGS_ID.xml
  # If MVN_SETTINGS_STANDALONE doesn't exist, try to use Maven one
  if [ ! -f "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" ]; then
      mvnrepodefault "$MVN_SETTINGS_ID.rename"
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
