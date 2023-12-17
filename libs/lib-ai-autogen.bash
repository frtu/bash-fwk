import lib-ai-ollama

AUTOGEN_LIB="autogen"

agcreate() {
 pcenvcreate ${AUTOGEN_LIB} python=3.11
 aginst
}
agactivate() {
  pcenv ${AUTOGEN_LIB}
}

aginst() {
  echo "pip install pyautogen"
  pip install pyautogen

  echo "pip install openai-wrapper"
  pip install openai-wrapper

  echo "pip install litellm"
  pip install litellm
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
