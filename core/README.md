# bash-fwk core framework

### Framework

The main functionality file is "core\base.bash". It provides these commands : 

- import
- refresh (if you constantly edit your bash on an editor, reload them in the command line with it)

Create your own commands grouped by file (docker.bash) :

- scripts\\[your distro] : contains all linux distro specific scripts (fixed by uname -s) => see below section

To accelerate adoption, bash-fwk coms with pre-packaged library script that you can use if you need it in "libs\", here the most interesting ones :

- libs\lib-dev-maven.bash : maven & all kinds of nexus repo commands & clean up
- libs\lib-docker.bash : standards docker commands starting with "dck"
- libs\lib-ssh.bash : start ssh-agent and register all keys in ".ssh/" folder

## Tech details
- setup.bash : is the shell installer script
- autoinstaller4curl.bash : remote installer that git clone this repo and launch setup.bash
