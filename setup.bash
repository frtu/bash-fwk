#!/bin/bash
echo "------- LOAD VARS --------"
source root/_bash_profile
source core/base.bash
source core/fwk-admin.bash

echo "------- DEPLOY bash --------"
bashdeploy
bashprofile

#echo "------- DL completion --------"
#gcompletion

source ~/.bash_profile
