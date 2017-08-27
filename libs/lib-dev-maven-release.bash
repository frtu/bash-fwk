import lib-dev-maven

MVN_RELEASE_REPO=target/checkout

# Release
mvnreleasetag() {
  local OPTIONAL_ARGS=-DautoVersionSubmodules=true 
  
  # Setting the next release version : 0.1.0
  if [ -n "$1" ]; then
    OPTIONAL_ARGS="$OPTIONAL_ARGS -DreleaseVersion=$1 -Dtag=version-$1"
  fi
  # Setting the following release version : 1.0.0
  if [ -n "$2" ]; then
    OPTIONAL_ARGS="$OPTIONAL_ARGS -DdevelopmentVersion=$2-SNAPSHOT"
  fi
  echo "mvn clean release:prepare $OPTIONAL_ARGS"
  mvn clean release:prepare $OPTIONAL_ARGS
}
mvnreleasedeploy() {
  cp release.properties release.properties_BAK

  echo "mvn clean package verify release:prepare"
  mvn clean package verify release:prepare

  echo "mvn clean package verify release:prepare-with-pom release:perform"
  mvn clean package verify release:prepare-with-pom release:perform
}

mvnreleasecd() {
  cd $MVN_RELEASE_REPO
}
mvnreleasesign() {
  mvn package gpg:sign
}

# Rollback
mvnreleaseclean() {
  echo "Attention : using this command will erase all release.properties that prevent you to resume any current release !!"
  echo "=> You have 5 sec to Ctrl+C before it runs!"
  sleep 5
  mvn release:clean
}
mvnreleaserollback() {
  mvn release:rollback
}