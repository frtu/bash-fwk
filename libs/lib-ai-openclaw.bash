export OPENCLAW_CONFIG_PATH=~/.openclaw
export OPENCLAW_CONFIG_FILE=${OPENCLAW_CONFIG_PATH}/openclaw.json

####################################################################################################################
# OpenClaw
##################################################################################################################
lmostop() {
  lmotpl node stop
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
lmoconf() {
  lmotpl onboard --install-daemon
}
lmoconfvi() {
  ${SUDO_CONDITIONAL} vi ${OPENCLAW_CONFIG_FILE}
}
lmoconfweb() {
  lmotpl configure --section web
}
lmofix() {
  lmotpl doctor --fix
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
