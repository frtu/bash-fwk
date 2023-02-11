import lib-dev-node

inst_rush() {
  npm install -g @microsoft/rush
}

# https://rushjs.io/pages/commands/rush_version/
rh() {
  rush version
}

# Install all pck dep - READ ONLY - https://rushjs.io/pages/commands/rush_install/
rhinst() {
  rhtpl "install" $@
}
# Run whenever you start working in a Rush repo, after you pull from Git, and after you modify a package.json file https://rushjs.io/pages/commands/rush_update/
rhupd() {
  rhtpl "update" $@
}

# https://rushjs.io/pages/commands/rush_build/
rhbuild() {
  rhtpl build $@
}
# Build project & subprojects
rhbuildfull() {
  rhbuild --to-except . $@
}

# https://rushjs.io/pages/commands/rushx/
rhrun() {
  echo "rushx $@"
  rushx $@
}

rhtpl() {
  usage $# "CMD" "[ARGS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CMD=$1
  local ARGS=${@:2}

  echo "rush ${CMD} ${ARGS}"
  rush ${CMD} ${ARGS}
}