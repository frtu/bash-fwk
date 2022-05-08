#!/bin/sh
ENV_GRADLE_SCRIPT=$LOCAL_SCRIPTS_FOLDER/env-GRADLE_CMD.bash
if [[ -f "$ENV_GRADLE_SCRIPT" ]] ; then echo "source ${ENV_GRADLE_SCRIPT}" ; fi
if [[ -z "$GRADLE_CMD" ]] ; then GRADLE_CMD="gradle" ; fi

gd() {
  gradle --version
}
gdi() {
  gdtpl "init" $@
}
gdb() {
  gdtpl "build" $@
}
gdbverbose() {
 gdb "--warning-mode all" $@
}
gdt() {
  gdtpl "test" $@
}
gdmain() {
  usage $# "CLASS_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  gdtpl "-q execute -PmainClass="$@
}
gdtpl() {
  usage $# "CMD" "[ADDITIONAL_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "$GRADLE_CMD $@"
  $GRADLE_CMD $@
}

gdwrapper() {
  envcreate GRADLE_CMD ./gradlew
}
gdwrapperset() {
  usage $# "[VERSION:7.4.2]"
  local VERSION=${1:-7.4.2}

  gdtpl "wrapper" "--gradle-version" ${VERSION}
}

gddep() {
  usage $# "[MODULE_NAME]"
  local MODULE_NAME=$1
  gdtpl "-q" ${MODULE_NAME}":dependencies" ${@:2}
}
gddepconf() {
  gdtpl "-q dependencies --configuration" $@
}
gddepimpl() {
  gddepconf "implementation" $@
}
gddepcompile() {
  gddepconf "compileClasspath" $@
}
gddepruntime() {
  gddepconf "runtimeClasspath" $@
}
gddeptest() {
  gddepconf "testRuntimeClasspath" $@
}
gdreport() {
  gdtpl "dependencyReport" $@
}
gdreporthtml() {
  gdtpl "htmlDependencyReport" $@
}

gddepchk() {
  gdtpl "checkUpdates" $@
}
