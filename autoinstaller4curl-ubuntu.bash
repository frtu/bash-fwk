sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install git


BASH_FWK_ROOT=~/git/bash-fwk
git clone https://github.com/frtu/bash-fwk.git $BASH_FWK_ROOT
cd $BASH_FWK_ROOT
source setup.bash
