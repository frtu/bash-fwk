export OPENCLAW_CONFIG_FILE=~/.openclaw/openclaw.json

####################################################################################################################
# OpenClaw
##################################################################################################################
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
