import lib-dev-py-pip

# Setting up environment for Claude
export CLAUDE_CONFIG_FILE=~/.claude/settings.json
export CLAUDE_ROUTER_PATH=~/.claude-code-router
export CLAUDE_ROUTER_CONFIG_FILE=${CLAUDE_ROUTER_PATH}/config.json

export ANTHROPIC_SCRIPT_NAME="env-anthropic"
export ANTHROPIC_SCRIPT_PATH=$LOCAL_SCRIPTS_FOLDER/${ANTHROPIC_SCRIPT_NAME}.bash

export LITELLM_CONFIG_FILE=~/libs/litellm/config.yaml

####################################################################################################################
# Claude
####################################################################################################################
lmc() {
  usage $# "[MODEL_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local MODEL_NAME=${1:-$MODEL_NAME}
  if [ -n "${MODEL_NAME}" ]; then
    OPTIONAL_ARGS="--model ${MODEL_NAME}"
  fi

  echo "claude ${OPTIONAL_ARGS}"
  claude ${OPTIONAL_ARGS}
}

lmconfclaude() {
  echo "claude config"
  claude config
}
inst_claudenative() {
  claude install
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
  echo "MODEL_NAME=${MODEL_NAME}"
}
lmconfanthropiccreate() {
  usage $# "ANTHROPIC_AUTH_TOKEN" "[ANTHROPIC_BASE_URL]" "[MODEL_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ANTHROPIC_AUTH_TOKEN=$1
  local ANTHROPIC_BASE_URL=${2:-https://api.anthropic.com/v1}
  local MODEL_NAME=${3:-$MODEL_NAME}

  echo "Create new SCRIPT file : ${ANTHROPIC_SCRIPT_PATH}"
  echo "" > ${ANTHROPIC_SCRIPT_PATH}

  scriptappend "${ANTHROPIC_SCRIPT_PATH}" "export ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN}"
  scriptappendverbose "${ANTHROPIC_SCRIPT_PATH}" "export ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL}"

  if [ -n "${MODEL_NAME}" ]; then
    scriptappendverbose "${ANTHROPIC_SCRIPT_PATH}" "export MODEL_NAME=${MODEL_NAME}"
  fi  
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

####################################################################################################################
# Google AI Studio - Vertex AI
####################################################################################################################
# Setting up environment for Gemini
# https://ai.google.dev/gemini-api/docs/api-key?hl=fr#set-api-env-var
lmconfgooglecreate() {
  usage $# "GOOGLE_API_KEY"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local GOOGLE_API_KEY=$1

  local SCRIPT_NAME="env-google"
  local OUTPUT_FILENAME=$LOCAL_SCRIPTS_FOLDER/${SCRIPT_NAME}.bash
  echo "== Create new SCRIPT file : ${OUTPUT_FILENAME} =="
  echo "" > ${OUTPUT_FILENAME}

  scriptappend "${OUTPUT_FILENAME}" "export GOOGLE_API_KEY=${GOOGLE_API_KEY}"
  scriptappend "${OUTPUT_FILENAME}" "export GEMINI_API_KEY=${GOOGLE_API_KEY}"
}
# List all available models
lmgls() {
  usage $# "[GOOGLE_API_KEY]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local GOOGLE_API_KEY=${1:-$GOOGLE_API_KEY}
  echo "== Curl https://generativelanguage.googleapis.com/v1beta/models?key=XXX =="
  curl "https://generativelanguage.googleapis.com/v1beta/models?key=${GOOGLE_API_KEY}"
}

# libs
ppinst_ggenai() {
  # https://pypi.org/project/google-genai/
  ppinst google-genai
  ppinst_image
}

####################################################################################################################
# LiteLLM
####################################################################################################################
inst_litellm() {
  usage $# "LITELLM_MASTER_KEY"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local LITELLM_MASTER_KEY=$1
  lmconflitellmcreate $LITELLM_MASTER_KEY

  pip install 'litellm[proxy]'
}
lmlitellmstart() {
  echo "Starting litellm with config : ${LITELLM_CONFIG_FILE} and param : $@"
  litellm --config ${LITELLM_CONFIG_FILE} $@
}
lmlitellmstartdebug() {
 lmlitellmstart --detailed_debug
}
lmlitellmping() {
  curl -X GET http://0.0.0.0:4000/v1/models \
     -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
     -H "Content-Type: application/json"
}

# Setting up environment for LiteLLM
lmconflitellmcreate() {
  usage $# "LITELLM_MASTER_KEY"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local LITELLM_MASTER_KEY=$1

  local SCRIPT_NAME="env-litellm"
  local OUTPUT_FILENAME=$LOCAL_SCRIPTS_FOLDER/${SCRIPT_NAME}.bash
  echo "== Create new SCRIPT file : ${OUTPUT_FILENAME} =="
  echo "" > ${OUTPUT_FILENAME}

  scriptappend "${OUTPUT_FILENAME}" "export LITELLM_MASTER_KEY=${LITELLM_MASTER_KEY}"
}

# Configure Claude to use LiteLLM
lmconflitellmclaude() {
  usage $# "[MODEL_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MODEL_NAME=${1:-gemini-flash-latest}
  lmconfanthropiccreate "$LITELLM_MASTER_KEY" "http://0.0.0.0:4000" "${MODEL_NAME}"
  echo "== Configure Claude to use LiteLLM at ${ANTHROPIC_BASE_URL} =="
}

####################################################################################################################
# Mistral
####################################################################################################################
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
