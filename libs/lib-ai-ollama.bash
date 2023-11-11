DEFAULT_CONFIG_PATH="Modelfile"

olpull() {
  usage $# "MODEL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local MODEL=$1
  
  echo "ollama pull ${MODEL}"
  ollama pull ${MODEL}
}
olconf() {
  usage $# "MODEL" "PERSONA_PROFILE" "[TEMPERATURE:1]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MODEL=$1
  local TEMPERATURE=${2:-1}
  
  local CONFIG_PATH=$DEFAULT_CONFIG_PATH
  echo "== Write file $CONFIG_PATH =="

  echo "From ${MODEL}"     > $CONFIG_PATH
  echo ""                  >> $CONFIG_PATH
  echo "PARAMETER temperature ${TEMPERATURE}"     >> $CONFIG_PATH
  echo ""                  >> $CONFIG_PATH
  echo "SYSTEM \"\"\""     >> $CONFIG_PATH
  echo "${PERSONA_PROFILE}" >> $CONFIG_PATH
  echo "\"\"\""            >> $CONFIG_PATH
}
olcreate() {
  usage $# "MODEL" "CONFIG_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MODEL=$1
  local CONFIG_PATH=$2
  
  echo "ollama create ${MODEL} -f ${CONFIG_PATH}"
  ollama create ${MODEL} -f ${CONFIG_PATH}
}

olrun() {
  usage $# "MODEL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local MODEL=$1
  local CONFIG_PATH=$2
  
  echo "ollama run ${MODEL}"
  ollama run ${MODEL}
}
olrunmistral() {
  olrun mistral
}
olrunllama2() {
  olrun llama2
}
