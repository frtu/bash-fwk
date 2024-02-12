import lib-dev-py-pip
import lib-ai-ollama

AUTOGEN_LIB="autogen"
AUTOGEN_PACKAGE="autogenstudio"

agcreate() {
 pcenvcreate ${AUTOGEN_LIB} python=3.11
 aginst
}
alias agenable=agactivate
agactivate() {
  pcenv ${AUTOGEN_LIB}
}

aginst() {
  ppinst ${AUTOGEN_PACKAGE}
}
agupg() {
  ppupg ${AUTOGEN_PACKAGE}
}
agstart() {
  usage $# "[SERVER_PORT:9999]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local SERVER_PORT=${1:-9999}

  echo "autogenstudio ui --port ${SERVER_PORT}"
  autogenstudio ui --port ${SERVER_PORT}
}
agmodel() {
  usage $# "MODEL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    olls
    return 1;
  fi

  local MODEL=$1
  olpull ${MODEL}
  litellm --model ollama/${MODEL}
}

################################################
# Archive
################################################
aginst_old() {
  echo "pip install pyautogen"
  pip install pyautogen

  echo "pip install openai-wrapper"
  pip install openai-wrapper

  echo "pip install litellm"
  pip install litellm
}
