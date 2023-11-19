export SDK_CANDIDATE_PATH=~/.sdkman/candidates

#!/bin/sh
inst_sdk() {
  # http://sdkman.io/
  echo "curl -s \"https://get.sdkman.io\" | bash"
  curl -s "https://get.sdkman.io" | bash
  enablelib inst-sdk
  sdkload
}

# https://itnext.io/install-several-versions-of-jdk-gradle-kotlin-scala-spark-and-on-your-os-in-parallel-a7de30f691ad
sdkload() {
  echo "== Loading sdkman =="
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
}

sdkv() {
  sdktpl "version" $@
}
sdkupd() {
  sdktpl "selfupdate" $@
}
sdkinstls() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Please specify one of the PACKAGE here :" >&2
    ll ${SDK_CANDIDATE_PATH}
    return 1; 
  fi

  echo "Listing package at : ${SDK_CANDIDATE_PATH}/$@"
  ll ${SDK_CANDIDATE_PATH}/$@
}

sdkls() {
  usage $# "[PACKAGE]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  sdktpl "list" $@
}
sdkinst() {
  usage $# "PACKAGE" "[VERSION]" "[PATH_TO_INSTALLATION]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  sdktpl "install" $@
}
sdktpl() {
  local CMD=$1
  local MORE_ARG=${@:2}
  
  if [ -z "$CMD" ]; then
    usage $# "CMD"
    return 1
  fi
  if [ -z "$SDKMAN_DIR" ]; then
    inst_sdk
  fi

  echo "sdk ${CMD} ${MORE_ARG}"
  sdk ${CMD} ${MORE_ARG}
}

instkotlin() {
  usage "[VERSION:1.7.21]"
  local VERSION=${1:-1.7.21}

  sdkinsttpl "kotlin" ${VERSION} ${@:2}
  enablelib dev-kotlin
}
instkotlin190() {
  local VERSION=${1:-1.9.20}
  instkotlin ${VERSION} ${@:2}
}

instjava() {
  sdkinsttpl "java" $@
  enablelib dev-java
}
instjava11() {
  usage "[PATCH_VERSION:20]"
  local PATCH_VERSION=${1:-20}
  sdkinsttpl "java" "11.0.${PATCH_VERSION}-zulu" ${@:2}
  enablelib dev-java
}
instjava17() {
  usage "[PATCH_VERSION:8]"
  local PATCH_VERSION=${1:-8}
  sdkinsttpl "java" "17.0.${PATCH_VERSION}-zulu" ${@:2}
  enablelib dev-java
}
instjava21() {
  sdkinsttpl "java" "21-zulu" $@
  enablelib dev-java
}
instvisualvm() {
  sdkinsttpl "visualvm" $@
}
instscala() {
  sdkinsttpl "scala" $@
}
instkscript() {
  sdkinsttpl "kscript" $@
}
instgradle() {
  sdkinsttpl "gradle" $@
  enablelib dev-gradle
}
instsbt() {
  sdkinsttpl "sbt" $@
}
sdkinsttpl() {
  usage $# "PACKAGE" "VERSION" "[PATH_TO_INSTALLATION]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'sdkjava' and look at the last column Identifier" >&2
    sdkls ${PACKAGE}
    return 1
  fi
  if [ -z "$SDKMAN_DIR" ]; then
    inst_sdk
  fi

  sdkinst $@
}
