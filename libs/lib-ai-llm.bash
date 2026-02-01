# Setting up environment for Claude
export CLAUDE_CONFIG_FILE=~/.claude/settings.json
export CLAUDE_ROUTER_PATH=~/.claude-code-router
export CLAUDE_ROUTER_CONFIG_FILE=${CLAUDE_ROUTER_PATH}/config.json

export ANTHROPIC_SCRIPT_NAME="env-anthropic"
export ANTHROPIC_SCRIPT_PATH=$LOCAL_SCRIPTS_FOLDER/${ANTHROPIC_SCRIPT_NAME}.bash


lmc() {
  usage $# "[MODEL_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local MODEL_NAME=$1
  if [ -n "${MODEL_NAME}" ]; then
    OPTIONAL_ARGS="--model ${MODEL_NAME}"
  fi

  echo "claude ${OPTIONAL_ARGS}"
  claude ${OPTIONAL_ARGS}
}

inst_clauderouter() {
  echo "npm install -g @anthropic-ai/claude-code @musistudio/claude-code-router"
  npm install -g @anthropic-ai/claude-code @musistudio/claude-code-router

  ccr start
}
lmccrsettings() {
  usage $# "GOOGLE_API_KEY"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local GOOGLE_API_KEY=$1

  mkdir -p "$(dirname "${CLAUDE_ROUTER_CONFIG_FILE}")"
  jq -n --arg key "$GOOGLE_API_KEY" '{
    Providers: [{
      name: "gemini",
      api_base_url: "https://generativelanguage.googleapis.com/v1beta/models/",
      api_key: $key,
      models: ["gemini-2.0-flash", "gemini-1.5-pro"],
      transformer: { use: ["gemini"] }
    }],
    Router: {
      default: "gemini,gemini-2.0-flash"
    }
  }' > "${CLAUDE_ROUTER_CONFIG_FILE}"
  
  echo "== Created Claude Code Router config at ${CLAUDE_ROUTER_CONFIG_FILE} =="
  cat "${CLAUDE_ROUTER_CONFIG_FILE}"
}

# Setting up environment for Anthropic Ollama
lmconfanthropic() {
  echo "ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL}"
  echo "ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN}"
}
lmconfanthropiccreate() {
  usage $# "ANTHROPIC_AUTH_TOKEN" "[ANTHROPIC_BASE_URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ANTHROPIC_AUTH_TOKEN=$1
  local ANTHROPIC_BASE_URL=${2:-https://api.anthropic.com/v1}

  echo "Create new SCRIPT file : ${ANTHROPIC_SCRIPT_PATH}"
  echo "" > ${ANTHROPIC_SCRIPT_PATH}

  scriptappend "${ANTHROPIC_SCRIPT_PATH}" "export ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN}"
  scriptappendverbose "${ANTHROPIC_SCRIPT_PATH}" "export ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL}"
}
lmconfanthropicollamacreate() {
  usage $# "[ANTHROPIC_BASE_URL:http://localhost:11434]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ANTHROPIC_BASE_URL=${1:-http://localhost:11434}
  lmconfanthropiccreate "ollama" "${ANTHROPIC_BASE_URL}"
}
lmconfanthropicrm() {
  echo "Delete SCRIPT file : ${ANTHROPIC_SCRIPT_PATH}"
  rm -f ${ANTHROPIC_SCRIPT_PATH}
}

# Setting up environment for Google PaLM API
lmconfgooglecreate() {
  usage $# "GOOGLE_API_KEY"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local GOOGLE_API_KEY=$1

  local SCRIPT_NAME="env-google"
  local OUTPUT_FILENAME=$LOCAL_SCRIPTS_FOLDER/${SCRIPT_NAME}.bash
  echo "Create new SCRIPT file : ${OUTPUT_FILENAME}"
  echo "" > ${OUTPUT_FILENAME}

  scriptappend "${OUTPUT_FILENAME}" "export GOOGLE_API_KEY=${GOOGLE_API_KEY}"
}

# Setting up environment for Mistral Mixtral model
export MIXTRAL_VERSION=v0.1

export MIXTRAL_MODEL=Mixtral-8x7B-${MIXTRAL_VERSION}
export MIXTRAL_MODEL_INSTRUCT=Mixtral-8x7B-Instruct-${MIXTRAL_VERSION}

lmx() {
  GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/mistralai/${MIXTRAL_MODEL_INSTRUCT}/
  cd $MIXTRAL_MODEL_INSTRUCT/ && \
    git lfs pull --include "consolidated.*.pt" && \
    git lfs pull --include "tokenizer.model"
}
