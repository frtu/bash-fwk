#!/bin/sh
MVN_REPO_ROOT=~/.m2

MVN_SETTINGS=settings.xml
MVN_SETTINGS_STANDALONE=settings_STANDALONE.xml
MVN_SETTINGS_NEXUS=settings_NEXUS.xml

mvnsk() { # Skip all tests and enforcer
  mvn -DskipTests -Denforcer.skip $@
}

mvnsrc() { # Download in local repo all the source
  mvn dependency:resolve -Dclassifier=sources
}
mvndep() { # list all dependencies, you may want to redirect the output into a file
  mvn dependency:tree
}

mvnrepobck() {
  if [ ! -f "$MAVEN_HOME/conf/$MVN_SETTINGS" ] 
    then
      echo "Couldn't find default setting at '$MAVEN_HOME/conf/$MVN_SETTINGS'. Please set MAVEN_HOME correctly!"
    else
      cp "$MAVEN_HOME/conf/$MVN_SETTINGS" "$MVN_REPO_ROOT/$MVN_SETTINGS_STANDALONE"
  fi
}
mvnrepostandalone() {
  if [ ! -f "$MVN_REPO_ROOT/$MVN_SETTINGS_STANDALONE" ]; then
      mvnrepobck
  fi

  if [ ! -f "$MVN_REPO_ROOT/$MVN_SETTINGS_STANDALONE" ] 
    then
      echo "Couldn't find setting at '$MVN_REPO_ROOT/$MVN_SETTINGS_STANDALONE'. Please set MAVEN_HOME correctly!"
    else
      cp "$MVN_REPO_ROOT/$MVN_SETTINGS_STANDALONE" "$MVN_REPO_ROOT/$MVN_SETTINGS"
  fi
}
mvnreponexus() {
  if [ ! -f "$MVN_REPO_ROOT/$MVN_SETTINGS_NEXUS" ] 
    then
      cp "$MVN_REPO_ROOT/$MVN_SETTINGS_STANDALONE" "$MVN_REPO_ROOT/$MVN_SETTINGS_NEXUS"
      echo "PLEASE configure correctly your NEXUS repo into this file '$MVN_REPO_ROOT/$MVN_SETTINGS_NEXUS'."
    else
      cp "$MVN_REPO_ROOT/$MVN_SETTINGS_NEXUS" "$MVN_REPO_ROOT/$MVN_SETTINGS"
  fi
}

mvnrepoclean() { # Remove all trace of orginal repo from local repo (avoid SNAPSHOT to search for nexus when you cannot reach it)
  find $MVN_REPO_ROOT/repository -type f -name "_remote.repositories" -exec echo {} \; -exec rm -f {} \;
}
