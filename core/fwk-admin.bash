BASH_FWK_ROOT=~/git/bash-fwk

cdfwk() {
  cd $BASH_FWK_ROOT
}
fwkinst() {
  pbcopy < $BASH_FWK_ROOT/core/fwkinst-git
}
fwkubuntu() {
  pbcopy < $BASH_FWK_ROOT/core/fwkinst-ubuntu
}
fwkdeb() {
  pbcopy < $BASH_FWK_ROOT/core/fwkinst-deb
}
fwkcentos() {
  pbcopy < $BASH_FWK_ROOT/core/fwkinst-centos
}
fwkvag() {
  source $BASH_FWK_ROOT/core/fwkinst-vag
}
fwknet() {
  pbcopy < $BASH_FWK_ROOT/core/fwknet
}


# LOCAL INSTALLATION CAPABILITIES BASED ON BASH_FWK_ROOT
redeploy() {
  source $BASH_FWK_ROOT/setup.bash
  refresh
}

bashdeploy() {
	## If $1 is not passed, set to the current working dir using $PWD
	_dir="${1:-${PWD}}"
  system=`uname -s`
  system="${system%-*}"

	DISTRO_SCRIPT_FOLDER="$_dir/scripts/$system/"
  echo "Mapping folder > ${DISTRO_SCRIPT_FOLDER}"
  
  mkscriptfolder "$DISTRO_SCRIPT_FOLDER"
  mkscriptfolder "$LOCAL_SCRIPTS_FOLDER"

	echo "------- LINK bash folders --------"
	relink "$_dir/core/" "$CORE_FOLDER"
	relink "$_dir/libs/" "$LIBS_FOLDER"
	relink "$DISTRO_SCRIPT_FOLDER" "$SCRIPTS_FOLDER"
}
mkscriptfolder() {
  usage $# "FOLDER"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FOLDER=$1

  if [ ! -d ${FOLDER} ]; then
    echo "Creating new folder ${FOLDER}"
    mkdir -p ${FOLDER}
    touch ${FOLDER}/CREATE_YOUR_OWN_DISTRO_SCRIPT_HERE.bash
  fi
}

bashprofile() {
	mv -f $BASH_PROFILE_FILENAME $BASH_PROFILE_FILENAME.bak
	mv -f $BASH_RC_FILENAME $BASH_RC_FILENAME.bak

	cp -f root/_bash_profile $BASH_PROFILE_FILENAME
	cp -f root/_bashrc $BASH_RC_FILENAME
  
  source $BASH_PROFILE_FILENAME 
}

# REPLICATE EXISTING INSTALL TO CURRENT FOLDER (useful for Vagrant)
replicate2currentfolder() {
  mkdir -p libs/
  cp -R $LIBS_FOLDER/* libs/

  mkdir -p core/
  cp -R $CORE_FOLDER/* core/

  mkdir -p scr-local/
  touch scr-local/CREATE_YOUR_OWN_DISTRO_SCRIPT_HERE.bash

  mkdir -p scripts/
  #cp -R $SCRIPTS_FOLDER/* scripts/
  touch scripts/CREATE_YOUR_OWN_DISTRO_SCRIPT_HERE.bash
  
  cp ~/.bash_profile .
  cp ~/.bashrc .
}

# REPLICATE EXISTING INSTALL TO REMOTE HOST (if remote cannot use git)
replicate2remote() {
  usage $# "REMOTE_HOST"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local REMOTE_HOST=$1

  scp -r $LIBS_FOLDER $REMOTE_HOST:~/
  scp -r $CORE_FOLDER $REMOTE_HOST:~/
  scp -r $LOCAL_SCRIPTS_FOLDER $REMOTE_HOST:~/
  scp -r $SCRIPTS_FOLDER $REMOTE_HOST:~/
  scp -r ~/.bash_profile $REMOTE_HOST:~/
  scp -r ~/.bashrc $REMOTE_HOST:~/
}
