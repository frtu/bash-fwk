load_file() {
  if [ -f "$1" ]; then
  	echo "source $1"
    source "$1"
  else
  	echo "File '$1' does not exists!"
  fi
}
load_folder() {
	if [ -d $1 ]; then
	  echo "------- Loading $1 --------";
    for i in $1/*.bash; 
    do 
      echo "source $i"
      source "$i"
    done
	else
	  echo "Director '$1' does not exists!"
	fi
}
import() {
  load_file "$LIBS_FOLDER/$1.bash"
}

usage() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
      echo "Usage : usage NUMBER_ARG [ARGUMENT_LIST]" >&2
      return -1
  fi

  local NUMBER_ARG=$1

  # COUNT NUMBER OF MANDATORY ARGS
  NUM_MANDATORY_ARGS=0
  for args in "${@:2}" ; do
    if [[ ! $args == [* ]]
      then
        ((NUM_MANDATORY_ARGS++));
      else
        break
    fi
  done

  # CHECK
  if [[ "$NUM_MANDATORY_ARGS" -eq "0" ]]; then
    # Display usage
    echo "Usage : ${FUNCNAME[1]} ${@:2} => DISPLAY OPTIONAL ARGS"
  fi

  if [[ "$NUMBER_ARG" < "$NUM_MANDATORY_ARGS" ]]; then
    # Display usage in stderr and EXIT
    echo "Usage : ${FUNCNAME[1]} ${@:2} => $NUM_MANDATORY_ARGS mandatory argument(s)" >&2
    return -1
  fi
}

refresh() {
  source ~/.bash_profile
}
relink() {
  usage $# "SOURCE_FOLDER" "LOCAL_LINK_NAME" "[FORCE:false]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local SOURCE_FOLDER=$1
  local LOCAL_LINK_NAME=$2
  local FORCE=$3

  if [[ -d "${LOCAL_LINK_NAME}" ]]; then
    if [[ -z "${FORCE}" ]]; then
      echo "'${LOCAL_LINK_NAME}' is an EXISTING directory! Are you sure of the parameters order?" >&2
      return -1
    fi
  fi

  rm -fR "${LOCAL_LINK_NAME}"
  echo "Linking local folder $2 to source folder ${SOURCE_FOLDER}"
  ln -s  "${SOURCE_FOLDER}" "${LOCAL_LINK_NAME}"
}
