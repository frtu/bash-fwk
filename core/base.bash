BASH_FWK_ROOT=~/git/bash-fwk
SERVICE_BASH_PREFIX=$SCRIPTS_FOLDER/service-

cdfwk() {
  cd $BASH_FWK_ROOT
}

load_file() {
  if [ -f "$1" ]
  then
	echo "source $1"; source "$1";
  else
  	echo "File '$1' does not exists!"
  fi
}
load_folder() {
	if [[ -d $1 ]]
	then
	  echo "------- Loading $1 --------";	for i in $1/*.bash; do echo "source $i"; source "$i"; done
	else
	  echo "Director '$1' does not exists!"
	fi
}

import() {
  load_file "$LIBS_FOLDER/$1.bash"
}
reload() {
  source ~/.bash_profile
}

srv_list() {
  # http://www.cyberciti.biz/faq/unix-linux-extract-filename-and-extension-in-bash/
  echo "== Activated services =="
  for i in $SERVICE_BASH_PREFIX*.bash; do 
  	[ ! -f "$i" ] && break # SKIP the file pattern when no file matches
  	FILENAME=${i##*/}
  	echo ${FILENAME%.*} | cut -d'-' -f2 # Echo BASENAME and keep only the second part after -
  done

  echo "== Deactivated services =="
  for i in $SERVICE_BASH_PREFIX*.bas; do 
  	[ ! -f "$i" ] && break # SKIP the file pattern when no file matches
  	FILENAME=${i##*/}
  	echo ${FILENAME%.*} | cut -d'-' -f2 # Echo BASENAME and keep only the second part after -
  done
}

srv_activate() {
  local SERVICE_BASENAME=$SERVICE_BASH_PREFIX$1
  if [ -f "$SERVICE_BASENAME.bas" ]
  then
  	echo "Activate service $1"
	mv $SERVICE_BASENAME.bas $SERVICE_BASENAME.bash
  else
  	echo "'$1' does not exists! Please profile a valide service name using 'srv_list'"
  fi
}
srv_deactivate() {
  local SERVICE_BASENAME=$SERVICE_BASH_PREFIX$1
  if [ -f "$SERVICE_BASENAME.bash" ]
  then
  	echo "Deactivate service $1"
	mv $SERVICE_BASENAME.bash $SERVICE_BASENAME.bas
  else
  	echo "'$1' does not exists! Please profile a valide service name using 'srv_list'"
  fi
}
