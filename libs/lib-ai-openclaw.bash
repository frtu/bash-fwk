export OPENCLAW_CONFIG_PATH=~/.openclaw
export OPENCLAW_CONFIG_FILE=${OPENCLAW_CONFIG_PATH}/openclaw.json

####################################################################################################################
# OpenClaw
##################################################################################################################
lmo() {
  lmotpl dashboard
}
lmostop() {
  lmotpl node stop
}

# Gateway commands
lmog() {
  usage $# "[CMD:status]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CMD=${1:-status}
  lmotpl gateway ${CMD} ${@:2}
}
lmogstart() {
  lmog start $@
}
lmogstop() {
  lmog stop $@
}

# Admin commands
# https://docs.openclaw.ai/start/getting-started#
lmoconf() {
  lmotpl onboard --install-daemon
}
lmofix() {
  lmotpl doctor --fix
}
lmoconfweb() {
  lmotpl configure --section web
}
lmoconfvi() {
  ${SUDO_CONDITIONAL} vi ${OPENCLAW_CONFIG_FILE}
}
lmocd() {
  cd ${OPENCLAW_CONFIG_PATH}
}
lmocdw() {
  cd ${OPENCLAW_CONFIG_PATH}/workspace
}
lmocds() {
  cd ${OPENCLAW_CONFIG_PATH}/agents/main/sessions
}

lmotpl() {
  echo "openclaw $@"
  openclaw $@
}

# https://docs.openclaw.ai/install
inst_openclaw() {
  curl -fsSL https://openclaw.ai/install.sh | bash
}
upd_openclaw() {
  echo "npm update -g openclaw"
  npm i -g openclaw@latest
}
uninst_openclaw() {
  lmotpl uninstall
}
cleanup_openclaw() {
  rm -rf ~/.openclaw
  npm rm -g openclaw
}