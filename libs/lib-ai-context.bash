import lib-dev-py-uv

spinst() {
  putinst specify-cli $@ --from git+https://github.com/github/spec-kit.git
}
spupd() {
  spinst --force
}

spi() {
  usage $# "[PROJECT_NAME]"
  
  local PROJECT_NAME=${1:-.}
  sp init ${PROJECT_NAME} ${@:2}
}
spisk() {
  usage $# "[PROJECT_NAME]"
  
  local PROJECT_NAME=${1:-.}
  sp init ${PROJECT_NAME} --ignore-agent-tools ${@:2}
}

spcheck() {
  sp check $@
}
sp() {
  usage $# "[CMD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ -z "$1" ]]; then 
    echo "specify --help"
    specify --help
  else
    echo "specify $@"
    specify $@
  fi
}