#!/bin/sh

gd() {
  gradle --version
}
gdi() {
  gdtpl "init" $@
}
gdb() {
  gdtpl "build" $@
}
gdt() {
  gdtpl "test" $@
}
gdtpl() {
  usage $# "CMD" "[ADDITIONAL_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "gradle $@"
  gradle $@
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
