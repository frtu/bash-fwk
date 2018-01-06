SERVICE_LOCAL_BASH_PREFIX=$LOCAL_SCRIPTS_FOLDER/service-

# MORE LIGHTWEIGHT SERVICE CAPABILITIES (ONE LINE)
lslibs() {
  ll $LIBS_FOLDER/
}

enablelib() {
  if [ $# -eq 0 ]; then
    echo "Please supply the argument WITHOUT the prefix 'lib-' : LIB_NAME_WITHOUT_PREFIX to enable " >&2
    lslibs
    return -1
  fi
  if [ ! -f "$LIBS_FOLDER/lib-$1.bash" ]; then
    echo "Service doesn't exist : $1. Please check lib folder!" >&2
    lslibs
    return -1
  fi

  local LIB_NAME_WITHOUT_PREFIX=$1
  local TARGET_SERVICE_FILENAME=$SERVICE_LOCAL_BASH_PREFIX$LIB_NAME_WITHOUT_PREFIX.bash

  echo "Enabling service at $TARGET_SERVICE_FILENAME"
  echo "import lib-$LIB_NAME_WITHOUT_PREFIX" > $TARGET_SERVICE_FILENAME
}

enablehadoop() {
  enablelib hadoop
}
enabledockertoolbox() {
  enablelib dockertoolbox
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
