echo "------- BACKUP & CLEAN --------"
mv -f ~/.bash_profile ~/.bash_profile.bak
mv -f ~/.bashrc ~/.bashrc.bak


echo "------- LOAD VARS --------"
source root/_bash_profile

## If $1 is not passed, set to the current working dir using $PWD
_dir="${1:-${PWD}}"

relink() {
	rm -fR "$2"
	echo "Linking local folder $2 to source folder $1"
	ln -s  "$1" "$2"
}


DISTRO_SCRIPT_FOLDER="$_dir/scripts/`uname -s`/"
if [[ ! -d $DISTRO_SCRIPT_FOLDER ]]; then
  echo "Creating new folder $DISTRO_SCRIPT_FOLDER"
  mkdir -p $DISTRO_SCRIPT_FOLDER
  touch $DISTRO_SCRIPT_FOLDER\CREATE_YOUR_OWN_DISTRO_SCRIPT_HERE.bash
fi

echo "------- LINK bash folders --------"
relink "$_dir/core/" "$CORE_FOLDER"
relink "$_dir/libs/" "$LIBS_FOLDER"
relink "$DISTRO_SCRIPT_FOLDER" "$SCRIPTS_FOLDER"

echo "------- DEPLOY bash --------"
cp -f root/_bash_profile $BASH_PROFILE_FILENAME
cp -f root/_bashrc $BASH_RC_FILENAME
