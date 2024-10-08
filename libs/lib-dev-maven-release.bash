import lib-dev-maven

MVN_RELEASE_REPO=target/checkout

mvnreleasevalidate() {
  mvn clean test
  if [ "$?" -eq 0 ]; then
      echo "Success!"
    else
      echo "Failure!"
      return -1
  fi

  mvn javadoc:javadoc
  if [ "$?" -eq 0 ]; then
      echo "Success!"
    else
      echo "Failure!"
      return -1
  fi
}

# Release
mvnreleasetagversion() {
  usage $# "[RELEASE_VERSION]" "[FOLLOWING_VERSION_WITHOUT_SNAPSHOT]"

  local RELEASE_VERSION=$1
  local FOLLOWING_VERSION_WITHOUT_SNAPSHOT=$2

  # Setting the next release version : 0.1.0
  if [ -n "$RELEASE_VERSION" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -DreleaseVersion=${RELEASE_VERSION} -Dtag=v${RELEASE_VERSION}"
  fi
  # Setting the following release version : 1.0.0
  if [ -n "$FOLLOWING_VERSION_WITHOUT_SNAPSHOT" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -DdevelopmentVersion=${FOLLOWING_VERSION_WITHOUT_SNAPSHOT}-SNAPSHOT"
  fi
  mvnreleasetag ${OPTIONAL_ARGS}
}
mvnreleasetagsk() {
  mvnreleasetag -DignoreSnapshots=true -Darguments=\"-Dmaven.javadoc.skip=true -DskipTests -Dfindbugs.skip=true -Dpmd.skip=true\"
}
mvnreleasetag() {
  local OPTIONAL_ARGS="-DautoVersionSubmodules=true $@"
  
  echo "mvn clean release:prepare $OPTIONAL_ARGS"
  mvnsk clean release:prepare $OPTIONAL_ARGS
}
mvnreleasedeploy() {
  cp release.properties release.properties_BAK

  echo "mvn release:prepare"
  mvn release:prepare

  echo "mvn clean release:perform"
  mvn clean release:perform

  STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
      echo "Success! Don't forget to validate your build at :"
      echo "- https://oss.sonatype.org/index.html#view-repositories;github-releases~browsestorage"
      echo "- Login, go to Stage Repositories & search for your project"
      echo "- Review Activity tab, if all is fine, push button Close & Release"
      echo ""
      echo "SIGNATURE : If some signatures fail to be uploaded, run :"
      echo "> mvnreleasecd"
      echo "> mvnreleasesign deploy"
    else
      echo "== An error has happen and leave your build at an intermediate state. ==" >&2
      echo "- You've pushed all your change in your repo" >&2
      echo "- In folder target/checkout/*, you have a non SNAPSHOT version that compiles correctly" >&2
  fi
}

mvnreleasecd() {
  echo "cd $MVN_RELEASE_REPO"
  cd $MVN_RELEASE_REPO
}
mvnreleasesign() {
  echo "mvnsk clean package gpg:sign $@"
  mvnsk clean package gpg:sign $@
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

  echo "Call 'mvn release:clean' & remove all release.properties and pom.xml.releaseBackup files."
  mvn release:clean
  find . -type f -name "release.properties*" -exec echo "rm -f {}" \; -exec rm -f {} \;
  find . -type f -name "pom.xml.releaseBackup" -exec echo "rm -f {}" \; -exec rm -f {} \;
}
mvnreleaserollback() {
  mvn release:rollback
}