#!/bin/bash
echo "------- LOAD VARS --------"
source root/_bash_profile
source core/admin.bash

bashdeploy

echo "------- DEPLOY bash --------"
bashprofile

echo "------- LOCAL bash dir --------"
echo "create $LOCAL_SCRIPTS_FOLDER/dummy.bash"
mkdir -p $LOCAL_SCRIPTS_FOLDER
touch $LOCAL_SCRIPTS_FOLDER/dummy.bash
