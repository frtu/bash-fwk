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

instjava() {
  sdkinsttpl "java" $@
  enablelib dev-java
}
instvisualvm() {
  sdkinsttpl "visualvm" $@
}
instscala() {
  sdkinsttpl "scala" $@
}
instkotlin() {
  sdkinsttpl "kotlin" $@
  enablelib dev-kotlin
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
