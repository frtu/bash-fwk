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

refresh() {
  source ~/.bash_profile
}
relink() {
  rm -fR "$2"
  echo "Linking local folder $2 to source folder $1"
  ln -s  "$1" "$2"
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
