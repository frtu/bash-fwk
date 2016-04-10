source root/_bash_profile

## If $1 is not passed, set to the current working dir using $PWD
_dir="${1:-${PWD}}"

relink() {
	rm -f "$2"
	echo "Linking local folder $2 to source folder $1"
	ln -s  "$1" "$2"
}

echo "------- SETUP local folders --------"
relink "$_dir/libs/" "$LIBS_FOLDER"
relink "$_dir/services/" "$SERVICES_FOLDER"
relink "$_dir/scripts/`uname -s`/" "$SCRIPTS_FOLDER"

echo "------- BACKUP --------"
mv -f $BASH_PROFILE_FILENAME $BASH_PROFILE_FILENAME.bak
mv -f $BASH_RC_FILENAME $BASH_RC_FILENAME.bak

echo "------- COPY BASH --------"
cp -f root/_bash_profile $BASH_PROFILE_FILENAME
cp -f root/_bashrc $BASH_RC_FILENAME
