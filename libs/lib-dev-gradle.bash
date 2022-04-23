#!/bin/sh

gd() {
  gradle --version
}
gdinit() {
  gdtpl "init" $@
}
gdbuild() {
  gdtpl "build" $@
}
gdtest() {
  gdtpl "test" $@
}
gdtpl() {
  usage $# "CMD" "[ADDITIONAL_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "gradle $@"
  gradle $@
}
