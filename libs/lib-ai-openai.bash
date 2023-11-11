#!/bin/sh
ENV_OPENAI_SCRIPT=$LOCAL_SCRIPTS_FOLDER/env-OPENAI.bash
if [[ -f "$ENV_OPENAI_SCRIPT" ]] ; then echo "source ${ENV_OPENAI_SCRIPT}" ; fi

oakey() {
  usage $# "OPENAI_API_KEY"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  oainit
  local OPENAI_API_KEY=$1
  scriptappend "${ENV_OPENAI_SCRIPT}" "export OPENAI_API_KEY=${OPENAI_API_KEY}"
}

oaurl() {
  usage $# "[OPENAI_API_BASE:http://127.0.0.1:5000]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local OPENAI_API_BASE=${1:-http://127.0.0.1:5000}
  scriptappend "${ENV_OPENAI_SCRIPT}" "export OPENAI_API_BASE=${OPENAI_API_BASE}"
  scriptappend "${ENV_OPENAI_SCRIPT}" "export BACKEND_TYPE=webui"
}

oainit() {
  echo "Create new SCRIPT file : ${ENV_OPENAI_SCRIPT}"
  echo "" > ${ENV_OPENAI_SCRIPT}
}
