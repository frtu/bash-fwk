export OPENCLAW_CONFIG_DIR=~/.openclaw
export OPENCLAW_CONFIG_PATH=${OPENCLAW_CONFIG_DIR}/openclaw.json
export OPENCLAW_WORKSPACE=${OPENCLAW_CONFIG_DIR}/workspace

####################################################################################################################
# OpenClaw
##################################################################################################################
lmo() {
  lmotpl dashboard
}
lmostop() {
  lmotpl node stop
}

# Describe himself
lmodesc() {
  echo "=== OpenClaw Identity ==="
  cat ${OPENCLAW_WORKSPACE}/IDENTITY.md

  echo "=== OpenClaw User (you) ==="
  cat ${OPENCLAW_WORKSPACE}/USER.md
}
lmodescfull() {
  echo "=== OpenClaw Identity ==="
  cat ${OPENCLAW_WORKSPACE}/SOUL.md
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
  ${SUDO_CONDITIONAL} vi ${OPENCLAW_CONFIG_PATH}
}
lmocd() {
  cd ${OPENCLAW_CONFIG_DIR}
}
lmocdw() {
  cd ${OPENCLAW_WORKSPACE}
}
lmocds() {
  cd ${OPENCLAW_CONFIG_DIR}/agents/main/sessions
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