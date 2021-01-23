kt() {
  kotlin -version
}
ktjarstandalone() {
  usage $# "KOTLIN_FILE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  ktjar $@ -include-runtime
}
ktjar() {
  usage $# "KOTLIN_FILE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local KOTLIN_FILE_NAME=$1
  local KOTLIN_BASE_NAME="${KOTLIN_FILE_NAME%.*}"
  local MORE_ARG=${@:2}

  ktc ${KOTLIN_FILE_NAME} ${MORE_ARG} -d ${KOTLIN_BASE_NAME}.jar
}
ktc() {
  usage $# "KOTLIN_FILE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local KOTLIN_FILE_NAME=$1
  if [ ! -f "$KOTLIN_FILE_NAME" ]; then
    echo "Please make sure the first arg point to an existing file : KOTLIN_FILE_NAME=${KOTLIN_FILE_NAME}" >&2 
    return 1
  fi

  kttpl ${KOTLIN_FILE_NAME} ${@:2}
}
kttpl() {
  echo "kotlinc $@"
  kotlinc $@
}


ktscript() {
  usage $# "KOTLIN_SCRIPT_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local KOTLIN_SCRIPT_NAME=$1
  if [ ! -f "$KOTLIN_SCRIPT_NAME" ]; then
    echo "Please make sure the first arg point to an existing file : KOTLIN_SCRIPT_NAME=${KOTLIN_SCRIPT_NAME}" >&2 
    return 1
  fi

  kttpl -script ${KOTLIN_SCRIPT_NAME} ${@:2}
}
ktrepl() {
  usage $# "[KOTLIN_JAR_FILE]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local KOTLIN_JAR_FILE=$1
  local MORE_ARG=${@:2}
  if [ -f "$KOTLIN_JAR_FILE" ]; then
    MORE_ARG="-cp ${KOTLIN_JAR_FILE} ${MORE_ARG}"
  fi

  echo "kotlinc-jvm ${MORE_ARG}"
  kotlinc-jvm ${MORE_ARG}
}