SERVICE_LOCAL_BASH_PREFIX=$LOCAL_SCRIPTS_FOLDER/service-
export CONDA_ROOT_FOLDER_DEFAULT=/opt/anaconda3

# MORE LIGHTWEIGHT SERVICE CAPABILITIES (ONE LINE)
lslibs() {
  ll $LIBS_FOLDER/
}

enablelib() {
  usage $# "LIB_NAME_WITHOUT_PREFIX" "[ADDITIONAL_SETTINGS:export RESOLUTION=720p]"
  ##################################
  # CHECK NO PARAMS
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Please supply the argument WITHOUT the prefix 'lib-' : LIB_NAME_WITHOUT_PREFIX to enable " >&2
    lslibs
    return -1
  fi    
  ##################################
  local LIB_NAME_WITHOUT_PREFIX=$1
  local OUTPUT_SERVICE_FILENAME=$SERVICE_LOCAL_BASH_PREFIX$LIB_NAME_WITHOUT_PREFIX.bash
  ##################################
  # CHECK PARAMS WRONG
  if [ ! -f "$LIBS_FOLDER/lib-$LIB_NAME_WITHOUT_PREFIX.bash" ]; then
    echo "Service doesn't exist : ${LIB_NAME_WITHOUT_PREFIX}. Please check lib folder!" >&2
    lslibs
    return -1
  fi
  ##################################

  local ADDITIONAL_SETTINGS_2=$2
  local ADDITIONAL_SETTINGS_3=$3
  local ADDITIONAL_SETTINGS_4=${@:4}

  echo "Enabling service at ${OUTPUT_SERVICE_FILENAME}"
  echo "echo \"- Loading '${OUTPUT_SERVICE_FILENAME}'. Env name SERVICE_SCR_${LIB_NAME_WITHOUT_PREFIX//-} capture this service filename\"" > $OUTPUT_SERVICE_FILENAME
  if [[ -n $ADDITIONAL_SETTINGS_2 ]]; then 
    echo "${ADDITIONAL_SETTINGS_2}" >> $OUTPUT_SERVICE_FILENAME
  fi
  if [[ -n $ADDITIONAL_SETTINGS_3 ]]; then 
    echo "${ADDITIONAL_SETTINGS_3}" >> $OUTPUT_SERVICE_FILENAME
  fi
  if [[ -n $ADDITIONAL_SETTINGS_4 ]]; then 
    echo "${ADDITIONAL_SETTINGS_4}" >> $OUTPUT_SERVICE_FILENAME
  fi
  echo "import lib-${LIB_NAME_WITHOUT_PREFIX}" >> $OUTPUT_SERVICE_FILENAME
  echo "" >> $OUTPUT_SERVICE_FILENAME
  # https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
  echo "export SERVICE_SCR_${LIB_NAME_WITHOUT_PREFIX//-}=${OUTPUT_SERVICE_FILENAME}" >> $OUTPUT_SERVICE_FILENAME

  source $OUTPUT_SERVICE_FILENAME
}
disablelib() {
  usage $# "LIB_NAME_WITHOUT_PREFIX"
  ##################################
  # CHECK NO PARAMS
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Please supply the argument WITHOUT the prefix 'lib-' : LIB_NAME_WITHOUT_PREFIX to enable " >&2
    lslibs
    return -1
  fi    
  ##################################
  local LIB_NAME_WITHOUT_PREFIX=$1
  local OUTPUT_SERVICE_FILENAME=$SERVICE_LOCAL_BASH_PREFIX$LIB_NAME_WITHOUT_PREFIX.bash
  ##################################
  # CHECK PARAMS WRONG
  if [ ! -f "$LIBS_FOLDER/lib-$LIB_NAME_WITHOUT_PREFIX.bash" ]; then
    echo "Service doesn't exist : ${LIB_NAME_WITHOUT_PREFIX}. Please check lib folder!" >&2
    lslibs
    return -1
  fi
  ##################################

  echo "Removing lib '$LIB_NAME_WITHOUT_PREFIX'"
  rm -v $OUTPUT_SERVICE_FILENAME
}

enableprj() {
  enablelib dev-project
}
enablesp() {
  enablelib dev-spring
}

# Local env
alias enablegcp=enablegke
enablegke() {
  enablelib k8s-gke
  echo "------- Help --------";
  echo "gke : gke info"
  echo "gkelogin : login into gke"
  echo "gkeupd : update gke"
}
enablehadoop() {
  enablelib hadoop-admin
  binappend ${HADOOP_HOME}/bin
}
enablespark() {
  enablehadoop
  enablelib spark
}
enabledckkafka() {
  enablelib dck-kafka
}
enabledckhadoop() {
  enablelib dck-hadoop
}
enabledckspark() {
  enablelib dck-spark
}
enablegit() {
  usage $# "GITHUB_ROOT_URL:github.com" "USER_NAME" "EMAIL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local GITHUB_ROOT_URL=$1
  local USER_NAME=$2
  local EMAIL=$3

  enablelib git
  gpersist ${GITHUB_ROOT_URL}
  gconfsetname ${USER_NAME}
  gconfsetemail ${EMAIL}
}
enableds() {
  enablelib dev-py-datascience
}
enableai() {
  enablelib ai-openai
  enablelib ai-ollama
}
enableautogen() {
  enablelib ai-autogen
  echo "=> Autogen enabled with prefix 'ag'"
}

enablessh() {
  srv_activate ssh
  refresh
}
enablekind() {
  enablelib k8s-kind
  inst_kind
}
enableminikube_linux() {
  enablelib docker-linux
  inst_docker
  enablelib k8s-linux
  inst_kubectl_linux
  enablelib k8s-minikube
  inst_minikube
  inst_docker_registry
}
enableml() {
  usage $# "MAGIC_LEAP_SDK_VERSION"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MAGIC_LEAP_SDK_VERSION=$1
  local ML_HOME=${HOME}/MagicLeap/mlsdk/${MAGIC_LEAP_SDK_VERSION}
  if [ -d "$ML_HOME" ]
    then
      enablelib dev-magicleap "export ML_VERSION=${MAGIC_LEAP_SDK_VERSION}"
      if [ -n "$MLCERT" ]; then
        mbcertpersist ${MLCERT}
      fi
    else
      echo "First parameter doesn't allow to point to a valid ML_HOME=$ML_HOME!!"
      return -1
  fi  
}
enablepyconda() {
  usage $# "[CONDA_ROOT_FOLDER]"
  
  local CONDA_ROOT_FOLDER=${1:-$CONDA_ROOT_FOLDER_DEFAULT}
  ##################################
  # CHECK CONDA INSTALLATION
  if [[ ! -d "${CONDA_ROOT_FOLDER}/bin" ]]; then 
    echo "Please install Anaconda first !! Folder should exist : $CONDA_ROOT_FOLDER/bin " >&2
    return 1
  fi    

  binappend ${CONDA_ROOT_FOLDER}/bin
  enablelib dev-py-conda "export CONDA_ROOT_FOLDER=${CONDA_ROOT_FOLDER}"
}

# Dev tools
enablesbt() {
  enablelib sbt
}
enablejava() {
  usage $# "JAVA_HOME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local JAVA_HOME=$1
  if [ -d "$JAVA_HOME" ]
    then
      local SERVICE_SCR_java=${SERVICE_LOCAL_BASH_PREFIX}dev-java.bash
      echo "Creating file $SERVICE_SCR_java"
      echo "export JAVA_HOME=\"$JAVA_HOME\"" > $SERVICE_SCR_java
      echo "export PATH=\$PATH:\"\$JAVA_HOME/bin\"" >> $SERVICE_SCR_java
    else
      echo "First parameter JAVA_HOME=$JAVA_HOME isn't a directory containing bin\java cmd !!"
      return -1
  fi
}
enablemvn() {
  usage $# "MAVEN_HOME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local MAVEN_HOME=$1
  if [ -f "$MAVEN_HOME/bin/mvn" ]
    then
      enablelib dev-maven
      echo "export MAVEN_HOME=\"$MAVEN_HOME\"" >> $SERVICE_SCR_devmaven
      echo "export PATH=\$PATH:\"\$MAVEN_HOME/bin\"" >> $SERVICE_SCR_devmaven
    else
      echo "First parameter MAVEN_HOME=$MAVEN_HOME isn't a directory containing bin\mvn cmd !!"
      return -1
  fi
}
enablemvngen() {
  usage $# "ARCHETYPE_VERSION" "[DEFAULT_GID]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ARCHETYPE_VERSION_LINE="export ARCHETYPE_VERSION=$1"
  if [[ -n $2 ]]; then 
    local DEFAULT_GID_LINE="export DEFAULT_GID=$2" 
  fi

  enablelib dev-maven-archetype "${ARCHETYPE_VERSION_LINE}" "${DEFAULT_GID_LINE}"
}

envcreate() {
  usage $# "ENV_NAME" "ENV_VALUE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ENV_NAME=$1
  local ENV_VALUE=$2

  scriptpersist "env-${ENV_NAME}" "export ${ENV_NAME}=${ENV_VALUE}"
}
scriptpersist() {
  usage $# "SCRIPT_NAME" "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SCRIPT_NAME=$1
  local CMD=${@:2}

  local OUTPUT_FILENAME=$LOCAL_SCRIPTS_FOLDER/${SCRIPT_NAME}.bash

  echo "Create new SCRIPT file : ${OUTPUT_FILENAME}"
  echo "" > ${OUTPUT_FILENAME}
  scriptappend "${OUTPUT_FILENAME}" "${CMD}"
}
scriptappend() {
  usage $# "OUTPUT_FILENAME" "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local OUTPUT_FILENAME=$1
  local ADDITIONAL_SETTINGS=${@:2}

  echo "Enabling service at ${OUTPUT_FILENAME}"
  echo "echo \"${ADDITIONAL_SETTINGS}\"" >> $OUTPUT_FILENAME
  echo "${ADDITIONAL_SETTINGS}" >> $OUTPUT_FILENAME

  source $OUTPUT_FILENAME
}

# FILE BASED SERVICE
SERVICE_TEMPLATE_BASH_PREFIX=$SCRIPTS_FOLDER/service-
srv_list() {
  # http://www.cyberciti.biz/faq/unix-linux-extract-filename-and-extension-in-bash/
  echo "== List ALL services =="
  for i in $SERVICE_TEMPLATE_BASH_PREFIX*.bas; do 
    [ ! -f "$i" ] && break # SKIP the file pattern when no file matches
    FILENAME=${i##*/}
    echo ${FILENAME%.*} | cut -d'-' -f2 # Echo BASENAME and keep only the second part after -
  done

  echo "== Activated services =="
  for i in $SERVICE_LOCAL_BASH_PREFIX*.bash; do 
  	[ ! -f "$i" ] && break # SKIP the file pattern when no file matches
  	FILENAME=${i##*/}
  	echo ${FILENAME%.*} | cut -d'-' -f2 # Echo BASENAME and keep only the second part after -
  done
}

srv_activate() {
  local SERVICE_BASENAME=$SERVICE_TEMPLATE_BASH_PREFIX$1
  local SERVICE_TARGET_BASENAME=$SERVICE_LOCAL_BASH_PREFIX$1
  if [ -f "$SERVICE_BASENAME.bas" ]
  then
  	echo "Activate service $1"
	  cp $SERVICE_BASENAME.bas $SERVICE_TARGET_BASENAME.bash
  else
  	echo "'$1' does not exists! Please profile a valide service name using 'srv_list'"
  fi
}
srv_deactivate() {
  local SERVICE_TARGET_BASENAME=$SERVICE_LOCAL_BASH_PREFIX$1
  if [ -f "$SERVICE_TARGET_BASENAME.bash" ]
  then
  	echo "Deactivate service $1"
	  rm $SERVICE_TARGET_BASENAME.bash
  else
  	echo "'$1' does not exists! Please profile a valide service name using 'srv_list'"
  fi
}
