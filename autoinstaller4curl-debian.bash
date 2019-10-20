apt-get update && apt-get -y upgrade
apt-get -y install curl git

BASH_FWK_ROOT=~/git/bash-fwk
git clone https://github.com/frtu/bash-fwk.git $BASH_FWK_ROOT

cd $BASH_FWK_ROOT
echo "------- LOAD VARS --------"
. root/_bash_profile
. core/base.bash
. core/fwk-admin.bash

echo "------- DEPLOY bash --------"
bashdeploy
bashprofile
