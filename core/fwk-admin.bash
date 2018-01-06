BASH_FWK_ROOT=~/git/bash-fwk

cdfwk() {
  cd $BASH_FWK_ROOT
}

# LOCAL INSTALLATION CAPABILITIES BASED ON BASH_FWK_ROOT
redeploy() {
  source $BASH_FWK_ROOT/setup.bash
  reload
}

bashdeploy() {
	## If $1 is not passed, set to the current working dir using $PWD
	_dir="${1:-${PWD}}"

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
}
bashprofile() {
	mv -f $BASH_PROFILE_FILENAME $BASH_PROFILE_FILENAME.bak
	mv -f $BASH_RC_FILENAME $BASH_RC_FILENAME.bak

	cp -f root/_bash_profile $BASH_PROFILE_FILENAME
	cp -f root/_bashrc $BASH_RC_FILENAME
}

# REPLICATE EXISTING INSTALL TO CURRENT FOLDER (useful for Vagrant)
replicate2currentfolder() {
  mkdir -p libs/
  mkdir -p core/
  mkdir -p scripts/
  cp -R $LIBS_FOLDER libs/
  cp -R $CORE_FOLDER core/
  cp -R $SCRIPTS_FOLDER scripts/
  cp ~/.bash_profile .
  cp ~/.bashrc .
}

# REPLICATE EXISTING INSTALL TO REMOTE HOST (if remote cannot use git)
replicate2remote() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
      echo "Please supply the REMOTE_HOST to replicate the local scripts to"
      return -1
  fi
  # ARGS
  local REMOTE_HOST=$1

  scp -r $LIBS_FOLDER $REMOTE_HOST:~/
  scp -r $CORE_FOLDER $REMOTE_HOST:~/
  scp -r $SCRIPTS_FOLDER $REMOTE_HOST:~/
  scp -r ~/.bash_profile $REMOTE_HOST:~/
  scp -r ~/.bashrc $REMOTE_HOST:~/
}
