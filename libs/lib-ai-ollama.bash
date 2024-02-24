DEFAULT_CONFIG_PATH="Modelfile"

# For $MODEL
# https://github.com/jmorganca/ollama#model-library
# https://ollama.ai/library 
ol() {
  echo "ollama -v"
  ollama -v
}
olls() {
  echo "ollama list"
  ollama list
}
olcd() {
  cd ~/.ollama/models/
  pwd
}

# Setting env for MAC
olenvhostmac() {
  usage $# "[HOST:0.0.0.0]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local HOST=${1:-0.0.0.0}
  serviceenv OLLAMA_HOST "${HOST}"
  echo "-- CHECK VALUE --"
  serviceenv OLLAMA_HOST

  echo "-> Reach server using http://localhost:11434"
}
olenvhostmacrm() {
  serviceenvrm OLLAMA_HOST
  echo "-- CHECK VALUE --"
  serviceenv OLLAMA_HOST
}
olenvoriginsmac() {
  usage $# "ORIGINS"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ORIGINS=$1
  serviceenv OLLAMA_ORIGINS "${ORIGINS}"
  echo "-- CHECK VALUE --"
  serviceenv OLLAMA_ORIGINS
}
olenvoriginsrm() {
  serviceenvrm OLLAMA_ORIGINS
  echo "-- CHECK VALUE --"
  serviceenv OLLAMA_ORIGINS
}

olpull() {
  usage $# "MODEL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local MODEL=$1
  
  echo "ollama pull ${MODEL}"
  ollama pull ${MODEL}
}
olgenconf() {
  usage $# "MODEL" "PERSONA_PROFILE" "[TEMPERATURE:1]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MODEL=$1
  local PERSONA_PROFILE=$2
  local TEMPERATURE=${3:-1}
  
  local CONFIG_PATH=$DEFAULT_CONFIG_PATH
  echo "== Write file $CONFIG_PATH =="

  echo "From ${MODEL}"     > $CONFIG_PATH
  echo ""                  >> $CONFIG_PATH
  echo "PARAMETER temperature ${TEMPERATURE}"     >> $CONFIG_PATH
  echo ""                  >> $CONFIG_PATH
  echo "SYSTEM \"\"\""     >> $CONFIG_PATH
  echo "${PERSONA_PROFILE}" >> $CONFIG_PATH
  echo "\"\"\""            >> $CONFIG_PATH
  
  cat Modelfile
}
olcreate() {
  usage $# "MODEL" "[CONFIG_PATH]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MODEL=$1
  local CONFIG_PATH=${2:-$DEFAULT_CONFIG_PATH}
  
  echo "ollama create ${MODEL} -f ${CONFIG_PATH}"
  ollama create ${MODEL} -f ${CONFIG_PATH}
}
olrm() {
  usage $# "MODEL" "[CONFIG_PATH]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MODEL=$1
  echo "ollama rm  ${MODEL}"
  ollama rm  ${MODEL}
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
