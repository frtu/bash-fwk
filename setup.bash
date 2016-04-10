source core/_bash_profile

## If $1 is not passed, set to the current working dir using $PWD
_dir="${1:-${PWD}}"

LIB_SOURCE_FOLDER="$_dir/libs/"
SCRIPT_SOURCE_FOLDER="$_dir/scripts/`uname -s`/"

relink() {
	rm -f "$2"
	echo "Linking local folder $2 to source folder $1"
	ln -s  "$1" "$2"
}

echo "------- SETUP local folders --------"
relink "$LIB_SOURCE_FOLDER" "$LIBS_FOLDER"
relink "$SCRIPT_SOURCE_FOLDER" "$SCRIPTS_FOLDER"

echo "------- BACKUP --------"
mv -f $BASH_PROFILE_FILENAME $BASH_PROFILE_FILENAME.bak
mv -f $BASH_RC_FILENAME $BASH_RC_FILENAME.bak

echo "------- COPY BASH --------"
cp -f core/_bash_profile $BASH_PROFILE_FILENAME
cp -f core/_bashrc $BASH_RC_FILENAME
