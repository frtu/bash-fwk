export PROGRAM_FILES="/c/Program Files"

enablevboxwin() {
  local VIRTUALBOX_HOME=${1:-$PROGRAM_FILES/Oracle/VirtualBox/}
  echo "VIRTUALBOX_HOME=$VIRTUALBOX_HOME"

  if [ -d "$VIRTUALBOX_HOME" ]
    then
      enablelib virtualbox
      echo "export VIRTUALBOX_HOME=\"$VIRTUALBOX_HOME\"" >> $SERVICE_SCR_virtualbox
      echo "export PATH=\$PATH:\"\$VIRTUALBOX_HOME\"" >> $SERVICE_SCR_virtualbox
    else
	  usage $# "VIRTUALBOX_HOME"
	  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
	  if [[ "$?" -ne 0 ]]; then return -1; fi
      return -1
  fi  
}
