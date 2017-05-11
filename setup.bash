#!/bin/bash
echo "------- BACKUP & CLEAN --------"
mv -f ~/.bash_profile ~/.bash_profile.bak
mv -f ~/.bashrc ~/.bashrc.bak


echo "------- LOAD VARS --------"
source root/_bash_profile
source core/admin.bash

deploy

echo "------- DEPLOY bash --------"
cp -f root/_bash_profile $BASH_PROFILE_FILENAME
cp -f root/_bashrc $BASH_RC_FILENAME
