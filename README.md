# bash-fwk
Framework for BASH startup, loading and utils


## One line download and install

Check your Linux distro with these cmds :

```
cat /etc/*-release
cat /proc/version
uname -mrs
${SYS_INFO}
```

### [Locally](autoinstaller4curl.bash) (require 'git')
	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | bash

If already installed, use quick fwk install copy : ```fwkinst```

### Locally on [Ubuntu](autoinstaller4curl-ubuntu.bash)
	sudo apt-get update && sudo apt-get install git curl && echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | bash

If already installed, use quick fwk install copy : ```fwkubuntu ```

### Locally on [Debian](autoinstaller4curl-debian.bash)

```	
apt-get update && apt-get -y install curl git && echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | bash
```	

If already installed, use quick fwk install copy : ```fwkdeb ```

### Locally on CentOS

```	
sudo yum install -y git && echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | bash
```	

If already installed, use quick fwk install copy : ```fwkcentos ```

### Into Vagrant

	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | vagrant ssh

If already installed, use quick fwk install copy : ```fwkvag ```

### Net tools

```	
apt update && apt -y install net-tools nmap netcat telnet curl iputils-ping
```	
If already installed, use quick fwk install copy : ```fwknet ```

### Locally on [Busybox](https://www.busybox.net/) or [Alpine](https://alpinelinux.org/)

	apk add curl git && \
	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | ash

Command ```source file.bash``` doesn't work, need to use ```. file.bash```

### IF raw.githubusercontent.com unreachable

The DNS may not work correctly, just run :

```
sudo -- sh -c "echo 199.232.28.133 raw.githubusercontent.com >> /etc/hosts"
```

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

See [bash-fwk linux scripts](scripts/Linux/)

## Tech details

To understand or contribute, just check [bash-fwk core framework](core/)
