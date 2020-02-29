import lib-dev-node

export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist

nvmv() {
  nvm --version
}
nvmls() {
  echo "nvm ls"
  nvm ls
}
nvmcurrent() {
  echo "nvm current"
  nvm current
}
nvmuse() {
  nvmtpl "use" $@
}
nvmwhich() {
  nvmtpl "which" $@
}

nvmlsremote() {
  echo "nvm ls-remote"
  nvm ls-remote
}
nvminst() {
  usage $# "[VERSION:v10.13.0]"
  local VERSION=${1:-v10.13.0}

  echo "nvm install ${VERSION}"
  nvm install ${VERSION}
}
nvmuninst() {
  nvmtpl "uninstall" $@
}
nvmtpl() {
  local CMD=$1
  local VERSION=$2
  
  if [ -z "$CMD" ]; then
    usage $# "CMD" "VERSION"
    return 1
  fi
  if [ -z "$VERSION" ]; then
    echo "Please pass the desired VERSION as parameter!" >&2
    nvmls
    return 1
  fi

  echo "nvm ${CMD} ${VERSION}"
  nvm ${CMD} ${VERSION}
}