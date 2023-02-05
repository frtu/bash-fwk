#!/bin/sh
nj() {
  echo "> node -v"
  node -v
  echo "> npm -v"
  npm -v
  echo "> node -p process.versions"
  node -p process.versions
}

njinststart() {
  echo "> npm install"
  npm install
  echo "> npm start"
  npm start
}
njbuild() {
  echo "> npm run build"
  npm run build
}
njbuildNdeploy() {
  njbuild

  echo "> npm install -g serve"
  sudo npm install -g serve
  echo "> serve -s build&"
  serve -s build&
}

njrepols() {
  usage $# "PKG_NAME"

  echo "npm ls $@"
  npm ls $@
}
njconfsetproxy() {
  usage $# "PROXY_URL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  njconfset proxy "$1"
}
njconfsetproxysecured() {
  usage $# "HTTPS_PROXY_URL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  njconfset https_proxy "$1"
}
njconfsetrepo() {
  usage $# "REPO_URL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  njconfset registry "$1"
}
njconfsetlog() {
  usage $# "LOG_LEVEL:warn"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  gconfset loglevel "$1"
}
njconfset() {
  usage $# "CONF_PARAM_NAME" "CONF_PARAM_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CONF_PARAM_NAME=$1
  local CONF_PARAM_VALUE=$2

  echo "npm config set $CONF_PARAM_NAME \"$CONF_PARAM_VALUE\""
  npm config set $CONF_PARAM_NAME "$CONF_PARAM_VALUE"
}

njconfcleanproxies() {
  njconfrm proxy
  njconfrm https_proxy
}
njconfrm() {
  usage $# "CONF_PARAM_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CONF_PARAM_NAME=$1

  echo "npm config delete $CONF_PARAM_NAME"
  npm config delete $CONF_PARAM_NAME
}

njconfls() {
  echo "npm config get $@"
  npm config get $@
}
njconfrepo() {
  njconfls "registry" $@
}

njclean() {
  echo "npm cache clean --force"
  npm cache clean --force
  echo "npm run clean"
  npm run clean
}

njaudit() {
  echo "npm audit $@"
  npm audit $@
}
njauditfix() {
  njaudit fix --force
}
njlock() {
  echo "npm i --package-lock-only"
  npm i --package-lock-only
}