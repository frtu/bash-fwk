#!/bin/bash
echo "------- LOAD VARS --------"
source root/_bash_profile
source core/admin.bash

bashdeploy

echo "------- DEPLOY bash --------"
bashprofile

echo "------- LOCAL bash dir --------"
mkdir -p $LOCAL_COMPLETION_FOLDER
mkdir -p $LOCAL_SCRIPTS_FOLDER
#echo "create $LOCAL_SCRIPTS_FOLDER/dummy.bash"
#touch $LOCAL_SCRIPTS_FOLDER/dummy.bash

echo "------- DL completion --------"
gcompletion
