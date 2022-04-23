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

gdset() {
  usage $# "[VERSION:7.4.2]"
  local VERSION=${1:-7.4.2}

  gdtpl "wrapper" "--gradle-version" ${VERSION}
}
