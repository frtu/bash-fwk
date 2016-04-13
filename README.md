# bash-fwk
Framework for BASH startup, loading and utils


## One line download and install
###Locally
```
echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | bash
```

###On Vagrant
```
echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | vagrant ssh
```

## Your new env

The script will install :
> * .bash_profile : standard bash loader (Don't put anything inside, it's generic)
> * .bashrc : load all the scripts in the following folders

> > * libs\ : contains all library script to import
> > * core\ : this folder contains all the linux generic script
> > * scripts\ : contains all linux distro specific scripts (fixed by uname -s)

> > > * Darwin\ : Mac OS X scripts


## Content
* setup.bash : is the shell installer script
* autoinstaller4curl.bash : remote installer that git clone this repo and launch setup.bash
