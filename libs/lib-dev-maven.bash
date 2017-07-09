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
  mvnsk versions:set -DnewVersion=$@
}

mvnrepodefault() {
  if [ -z "$1" ]
    then
      local L_MVN_SETTINGS_FILE=settings-$MVN_SETTINGS.xml
    else
      local L_MVN_SETTINGS_FILE=settings-$1.xml
  fi

  if [ ! -f "$MAVEN_HOME/conf/$MVN_SETTINGS" ] 
    then
      echo "== Couldn't find default setting at '$MAVEN_HOME/conf/$MVN_SETTINGS'. Please set MAVEN_HOME correctly! =="
    else
      echo "== Initialize the file with default setting at '$MAVEN_HOME/conf/$MVN_SETTINGS' =="
      cp "$MAVEN_HOME/conf/$MVN_SETTINGS" "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE"
  fi
}

mvnrepopatch() {
  if [ -z "$1" ]
    then
      echo "== You must pass a first parameter of the target maven settings file. ==" >&2
      return
    else
      local L_MVN_SETTINGS_FILE=settings-$1.xml
  fi

  if [ ! -f "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" ] 
    then
      echo "== Couldn't find setting at '$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE'. =="
    else
      cp "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" "$MVN_REPO_ROOT/$MVN_SETTINGS"
  fi
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
  if [ -z "$1" ]
    then
      local L_MVN_ID=$MVN_SETTINGS_NEXUS_DEFAULT
    else
      local L_MVN_ID=$1
  fi
  local L_MVN_SETTINGS_FILE=settings-$L_MVN_ID.xml

  # If MVN_SETTINGS_STANDALONE doesn't exist, try to use Maven one
  if [ ! -f "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" ]; then
      mvnrepodefault "$L_MVN_ID.rename"
      echo "== You must edit the file 'settings-$L_MVN_ID.rename.xml' and add a mirrors.mirror.url the correct repo URL value. Remove the .rename suffix when you're done. =="
      return
  fi
  mvnrepopatch $L_MVN_ID
}

mvnrepoclean() { # Remove all trace of orginal repo from local repo (avoid SNAPSHOT to search for nexus when you cannot reach it)
  find $MVN_REPO_ROOT/repository -type f -name "_remote.repositories" -exec echo {} \; -exec rm -f {} \;
  find $MVN_REPO_ROOT/repository -type f -name "resolver-status.properties" -exec echo {} \; -exec rm -f {} \;
  find $MVN_REPO_ROOT/repository -type f -name "maven-metadata-nexus.*" -exec echo {} \; -exec rm -f {} \;
}
