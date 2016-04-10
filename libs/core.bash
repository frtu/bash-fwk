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
  load_file "$LIBS_FOLDER/lib-$1.bash"
}

reload() {
  source ~/.bash_profile
}