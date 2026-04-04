export OPENCLAW_CONFIG_DIR=~/.openclaw
# OPENCLAW_CONFIG_PATH also used by OpenClaw directly
export OPENCLAW_CONFIG_PATH=${OPENCLAW_CONFIG_DIR}/openclaw.json
export OPENCLAW_CRON=${OPENCLAW_CONFIG_DIR}/cron
export OPENCLAW_WORKSPACE_DEFAULT=${OPENCLAW_CONFIG_DIR}/workspace

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
# Chat with OpenClaw using OpenClaw Code Agent (OCC) : https://docs.openclaw.ai/cli/agent#openclaw-code-agent
lmochat() {
  usage $# "MESSAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local MESSAGE=$1
  openclaw agent --message "${MESSAGE}"
}

lmojcd() {
  cd ${OPENCLAW_CRON}
}

# Memory
lmomstatus() {
  lmotpl memory status --deep
}

lmo() {
  lmotpl status $@
}
lmoall() {
  lmo --all
}
lmoui() {
  lmotpl dashboard
}
lmov() {
  lmotpl --version
}
# https://docs.openclaw.ai/install/updating
lmoupd() {
  lmotpl update
  lmov
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

# Model management
lmomodel() {
  usage $# "[CMD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local CMD=${1:-list}
  lmotpl models ${CMD} ${@:2}
}
lmomodells() {
  lmomodel list $@
}
lmomodelset() {
  usage $# "MODEL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    lmomodel
    return 1
  fi
  
  local MODEL=$1
  lmomodel set ${MODEL}
}
lmomodelsetfallback() {
  usage $# "MODEL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    lmomodel
    return 1
  fi
  
  local MODEL=$1
  lmomodel fallback add ${MODEL}
}
lmomodelstatus() {
  lmomodel status
}

# Skill management
# https://docs.openclaw.ai/cli/skills
lmoskill() {
  lmotpl skills $@
}
lmoskillls() {
  usage $# "[CONTAINING_TEXT]"

  local CONTAINING_TEXT=$1
  if [ -z "$CONTAINING_TEXT" ]; then
      echo "List all skills"
      lmoskill list
    else
      echo "List all existing skills containing ${CONTAINING_TEXT}"
      lmoskill list | grep ${CONTAINING_TEXT}
  fi
}
lmoskillsearch() {
  usage $# "[SKILL_SLUG]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  lmoskill search $@
}
lmoskillinstall() {
  usage $# "SKILL_SLUG"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  lmoskill install $@
}
lmoskillupdate() {
  usage $# "[SKILL_SLUG:all]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local SKILL_SLUG=${1:-all}
  lmoskill update ${SKILL_SLUG} ${@:2}
}
lmoskillcreate() {
  usage $# "skill-name"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SKILL_NAME=$1
  local SKILL_PATH=${OPENCLAW_WORKSPACE}/skills/${SKILL_NAME}
  mkdir -p ${SKILL_PATH}

  local OUTPUT_FILENAME=${SKILL_PATH}/SKILL.md
  echo "== Create new SCRIPT file : ${OUTPUT_FILENAME} =="
  echo "---"                                  > $OUTPUT_FILENAME
  echo "name: ${SKILL_NAME}"                  >> $OUTPUT_FILENAME
  echo "description: Skill for ${SKILL_NAME}" >> $OUTPUT_FILENAME
  echo "---"                                  >> $OUTPUT_FILENAME
  echo ""                                     >> $OUTPUT_FILENAME
  echo "# ${SKILL_NAME} Skill"                >> $OUTPUT_FILENAME

  cat ${OUTPUT_FILENAME}
}

# Describe himself
lmodesc() {
  echo "=== OpenClaw Identity ==="
  local OPENCLAW_WORKSPACE=${OPENCLAW_WORKSPACE:-${OPENCLAW_WORKSPACE_DEFAULT}}
  cat ${OPENCLAW_WORKSPACE}/IDENTITY.md

  echo "=== OpenClaw User (you) ==="
  cat ${OPENCLAW_WORKSPACE}/USER.md
}
lmodescfull() {
  echo "=== OpenClaw Identity ==="
  local OPENCLAW_WORKSPACE=${OPENCLAW_WORKSPACE:-${OPENCLAW_WORKSPACE_DEFAULT}}
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

# Channel : https://docs.openclaw.ai/cli/channels
lmochannel() {
  lmotpl channels list
}
lmochanneladd() {
  usage $# "CHANNEL_TYPE:telegram|discord|slack|custom" "CHANNEL_BOT_TOKEN"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local CHANNEL_TYPE=$1
  local CHANNEL_BOT_TOKEN=$2

  lmotpl channels add --channel ${CHANNEL_TYPE} --token ${CHANNEL_BOT_TOKEN}
}
lmochannelrm() {
  lmotpl channels remove
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

lmoconfset() {
  usage $# "KEY" "VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KEY=$1
  local VALUE=$2

  lmotpl config set ${KEY} ${VALUE}
}
lmoconfsetworkspace() {
  usage $# "WORKSPACE_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local WORKSPACE_PATH=$1
  # Check if WORKSPACE_PATH is a valid directory
  if [ ! -d "${WORKSPACE_PATH}" ]; then
    echo "Error: ${WORKSPACE_PATH} is not a valid directory."
    return -1
  fi
  lmoconfset "agents.defaults.workspace" ${WORKSPACE_PATH}
  lmconfworkspaceenv ${WORKSPACE_PATH}
}
lmconfworkspaceenv() {
  usage $# "WORKSPACE_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local WORKSPACE_PATH=$1
  # Check if WORKSPACE_PATH is a valid directory
  if [ ! -d "${WORKSPACE_PATH}" ]; then
    echo "Error: ${WORKSPACE_PATH} is not a valid directory."
    return -1
  fi
  
  local SCRIPT_NAME="env-openclaw-workspace"
  local OUTPUT_FILENAME=$LOCAL_SCRIPTS_FOLDER/${SCRIPT_NAME}.bash
  echo "== Create new SCRIPT file : ${OUTPUT_FILENAME} =="
  echo "" > ${OUTPUT_FILENAME}

  scriptappend "${OUTPUT_FILENAME}" "export OPENCLAW_WORKSPACE=${WORKSPACE_PATH}"
}
lmoconfsettimeout() {
  usage $# "TIMEOUT_SECONDS:600"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local TIMEOUT_SECONDS=$1
  lmoconfset "agents.defaults.timeoutSeconds" ${TIMEOUT_SECONDS}
}
lmoconfsetollama() {
  usage $# "OLLAMA_BASE_URL:http://localhost:11434"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local OLLAMA_BASE_URL=${1:-http://localhost:11434}
  lmoconfset "models.providers.ollama.baseUrl" ${OLLAMA_BASE_URL}
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
  local OPENCLAW_WORKSPACE=${OPENCLAW_WORKSPACE:-${OPENCLAW_WORKSPACE_DEFAULT}}
  cd ${OPENCLAW_WORKSPACE}
}
lmocds() {
  local OPENCLAW_WORKSPACE=${OPENCLAW_WORKSPACE:-${OPENCLAW_WORKSPACE_DEFAULT}}
  cd ${OPENCLAW_WORKSPACE}/skills/
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