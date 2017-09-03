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

  echo "mvn release:prepare"
  mvn release:prepare

  echo "mvn clean release:perform"
  mvn clean release:perform
}

mvnreleasecd() {
  echo "cd $MVN_RELEASE_REPO"
  cd $MVN_RELEASE_REPO
}
mvnreleasesign() {
  echo "mvn package gpg:sign"
  mvn package gpg:sign
}
mvnreleasesigndeploy() {
  if [ ! -f "$1" ]; then
    echo "== Please supply argument(s) > mvnreleasesigndeploy PATH_AND_FILES_WITHOUT_EXTENSION (ex : target/myapp-1.0 ) =="
    return -1
  fi  
  echo "mvn gpg:sign-and-deploy-file -DpomFile=$1.pom -Dfile=$1.jar -Durl=http://oss.sonatype.org/service/local/staging/deploy/maven2/ -DrepositoryId=sonatype_oss"
  mvn gpg:sign-and-deploy-file -DpomFile=$1.pom -Dfile=$1.jar -Durl=http://oss.sonatype.org/service/local/staging/deploy/maven2/ -DrepositoryId=sonatype_oss
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