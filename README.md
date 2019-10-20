# bash-fwk
Framework for BASH startup, loading and utils


## One line download and install
### Locally Ubuntu
	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl-ubuntu.bash)" | bash

### Locally (require 'git')
	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | bash


### On Vagrant

	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | vagrant ssh

### Specificity on Debian

```	
apt-get update && apt-get upgrade && apt-get -y install curl git
```	
Then you can refer to section [Locally (require 'git')](https://github.com/frtu/bash-fwk#locally-require-git)

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

## Platform specifics

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

### Ubuntu

See [bash-fwk linux scripts](https://github.com/frtu/bash-fwk/tree/master/scripts/Linux)

## Tech details

To understand or contribute, just check [bash-fwk core framework](https://github.com/frtu/bash-fwk/tree/master/core)
