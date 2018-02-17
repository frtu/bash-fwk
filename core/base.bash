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
  echo "Usage : ${FUNCNAME[1]} $@" >&2
}
