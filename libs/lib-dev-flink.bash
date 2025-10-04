import lib-dev-gradle

flgen() {
  usage $# "[FLINK_VERSION:2.1.0]" "[SCALA_VERSION:2.12]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FLINK_VERSION=${1:-2.1.0}
  local SCALA_VERSION=${2:-2.12}

  bash -c "$(curl https://flink.apache.org/q/gradle-quickstart.sh)" -- ${FLINK_VERSION} _${SCALA_VERSION}
}

import lib-dev-maven-archetype
import lib-dev-maven

# https://nightlies.apache.org/flink/flink-docs-release-2.1/docs/dev/configuration/overview/
mvngenflink() {
  usage $# "FLINK_VERSION" "AID" "GID" "[VERSION:0.0.1-SNAPSHOT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "= Check version at https://search.maven.org/artifact/org.apache.flink/flink-quickstart-java =" >&2 
    return 1
  fi

  local FLINK_VERSION=${1:-2.1.0}
  mvngentpl "org.apache.flink" "flink-quickstart-java" "${FLINK_VERSION}" ${@:2}

  echo "= See follow up tutorial at https://nightlies.apache.org/flink/flink-docs-release-2.1/docs/dev/configuration/overview/"
}