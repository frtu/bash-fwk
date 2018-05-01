# bash-fwk
Framework for BASH startup, loading and utils


## One line download and install
### Locally Ubunty
	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl-ubuntu.bash)" | bash

### Locally (require 'git')
	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | bash


### On Vagrant

	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | vagrant ssh


## Your new env

### Core

The script will install :

- .bash_profile : standard bash loader (Don't put anything inside, it's generic)
- .bashrc : load all the scripts in the following folders
- core\ : this folder contains all the linux generic script that is **ALWAYS** imported

### Services

Service commands "srv" are command that is heavy (loading SSH keys, ...), or have dependencies that comes deactivated.

    For ex : dockertoolbox is a service that will try to start docker-machine using VirtualBox.

You can list them and activate them on needs.

- srv_list : list all existing srv names
- srv_activate : activate any srv name
- srv_deactivate : deactivate any srv name 


### Framework

The main functionality file is "core\base.bash". It provides these commands : 

- import
- reload (if you constantly edit your bash on an editor, reload them in the command line with it)

Create your own commands grouped by file (docker.bash) :

- scripts\\[your distro] : contains all linux distro specific scripts (fixed by uname -s) => see below section

To accelerate adoption, bash-fwk coms with pre-packaged library script that you can use if you need it in "libs\", here the most interesting ones :

- libs\lib-dev-maven.bash : maven & all kinds of nexus repo commands & clean up
- libs\lib-docker.bash : standards docker commands starting with "dck"
- libs\lib-ssh.bash : start ssh-agent and register all keys in ".ssh/" folder


### Mac OSX

OSX specific scripts are on folder "scripts\Darwin\" that contains :

- cmd-osx.bash : dos2unix, ...
- dev-maven.bash : set MAVEN_HOME & import previous maven lib
- docker-mac.bash : switch between Docker machine & native OSX Docker
- vagrant.bash : vagrant packaged scripts

### MingG scripts on Windows

Windows specific scripts are on folder "scripts\MINGW64_NT-6.3\"

- dev-maven.bash : set MAVEN_HOME & import previous maven lib
- service-dockertoolbox.bash : start docker-machine default at startup


## Tech details
- setup.bash : is the shell installer script
- autoinstaller4curl.bash : remote installer that git clone this repo and launch setup.bash
