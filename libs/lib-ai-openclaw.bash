export OPENCLAW_CONFIG_DIR=~/.openclaw
# OPENCLAW_CONFIG_PATH also used by OpenClaw directly
export OPENCLAW_CONFIG_PATH=${OPENCLAW_CONFIG_DIR}/openclaw.json
export OPENCLAW_WORKSPACE=${OPENCLAW_CONFIG_DIR}/workspace
export OPENCLAW_CRON=${OPENCLAW_CONFIG_DIR}/cron

####################################################################################################################
# OpenClaw
##################################################################################################################
# Time triggered Job using cron https://docs.openclaw.ai/automation/cron-jobs
lmoj() {
  usage $# "[JOB_ID]"

  local JOB_ID=$1

  # If LOCAL_PORT is set, add extra parameters to open on a local port for distant forward
  if [ -n "${JOB_ID}" ]; then
    # Job definition is stored in ~/.openclaw/cron/JOB_ID.jsonl
    local EXTRA_PARAMS="runs --id ${JOB_ID}"
  fi

  lmotpl cron ${EXTRA_PARAMS}
}
lmojcd() {
  cd ${OPENCLAW_CRON}
}

lmo() {
  lmotpl dashboard
}
lmov() {
  lmotpl --version
}
lmolog() {
  lmotpl logs --follow $@
}
lmostop() {
  lmotpl node stop
}
lmorestart() {
  lmotpl node restart
}
# Usage status
lmomodel() {
  lmotpl models list
}
lmomodelset() {
  usage $# "MODEL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MODEL=$1
  lmotpl models set ${MODEL}
}
lmomodelstatus() {
  lmotpl models status
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
lmogrestart() {
  lmog restart $@
}

# Admin commands
# https://docs.openclaw.ai/start/getting-started#
lmoconf() {
  lmotpl onboard --install-daemon
}
lmofix() {
  lmotpl doctor --fix
}

# Security
# https://docs.openclaw.ai/gateway/security
lmosec() {
  usage $# "[MODE:--deep]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local MODE=${1:---deep}
  lmotpl security audit ${MODE} ${@:2}  
}
lmosecjson() {
  lmosec "--json"
}
lmosecfix() {
  lmosec "--fix"
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