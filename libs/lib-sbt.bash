DEFAULT_BUILD_FILE=build.sbt

sbtscala() {
  sbttpl "console" $@
}

sbttpl() {
  if [ ! -f "${DEFAULT_BUILD_FILE}" ]; then
  	echo "ATTENTION : Are you sure to run in folder '${PWD}' that doesn't have the file '${DEFAULT_BUILD_FILE}'?"
  fi
  echo "${PWD}> sbt $@"
  sbt $@
}
