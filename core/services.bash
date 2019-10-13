SERVICE_LOCAL_BASH_PREFIX=$LOCAL_SCRIPTS_FOLDER/service-

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

  local ADDITIONAL_SETTINGS=${@:2}

  echo "Enabling service at ${OUTPUT_SERVICE_FILENAME}"
  echo "echo \"- Loading '${OUTPUT_SERVICE_FILENAME}'. Env name SERVICE_SCR_${LIB_NAME_WITHOUT_PREFIX//-} capture this service filename\"" > $OUTPUT_SERVICE_FILENAME
  echo "${ADDITIONAL_SETTINGS}" >> $OUTPUT_SERVICE_FILENAME
  echo "import lib-${LIB_NAME_WITHOUT_PREFIX}" >> $OUTPUT_SERVICE_FILENAME
  echo "" >> $OUTPUT_SERVICE_FILENAME
  # https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
  echo "export SERVICE_SCR_${LIB_NAME_WITHOUT_PREFIX//-}=${OUTPUT_SERVICE_FILENAME}" >> $OUTPUT_SERVICE_FILENAME

  source $OUTPUT_SERVICE_FILENAME
}

# Local env
enablehadoop() {
  enablelib hadoop-admin
  binappend ${HADOOP_HOME}/bin
}
enablespark() {
  enablehadoop
  enablelib spark
}

# For Docker host
enabledockertoolbox() {
  enablelib dockertoolbox
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
enablessh() {
  srv_activate ssh
  refresh
}
enabledockerubuntu() {
  srv_activate docker
  refresh
  inst_docker_ubuntu
  refresh
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

# Dev tools
enablesbt() {
  enablelib sbt
}
enablemvngen() {
  usage $# "ARCHETYPE_VERSION"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local ARCHETYPE_VERSION=$1
  enablelib dev-maven-archetype "export ARCHETYPE_VERSION=${ARCHETYPE_VERSION}"
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
