# bash-fwk core framework

## Commands

All the bash commands you can activate with :

* List all the lib available : ```lslibs```
* Import (temporary) : ```import lib-*``` (*like ```import lib-git```*)
* Persist import : ```enablelib *``` (*like ```enablelib git```*)
* Remove persisted import : ```disablelib *``` (*like ```disablelib git```*)
* Persist export env : ```envcreate "ENV_NAME" "ENV_VALUE"``` (*like ```enablelib JH12 /Library/Java/JavaVirtualMachines/xx```*)
* Persist script file : ```scriptpersist "SCRIPT_NAME" "CMD"```
* Append cmd to script file : ```scriptappend "OUTPUT_FILENAME" "CMD"```


## Framework

The main functionality file is "core\base.bash". It provides these commands : 

- import
- refresh (if you constantly edit your bash on an editor, reload them in the command line with it)

Create your own commands grouped by file (docker.bash) :

- scripts\\[your distro] : contains all linux distro specific scripts (fixed by uname -s) => see below section

To accelerate adoption, bash-fwk coms with pre-packaged library script that you can use if you need it in "libs\", here the most interesting ones :

- libs\lib-dev-maven.bash : maven & all kinds of nexus repo commands & clean up
- libs\lib-docker.bash : standards docker commands starting with "dck"
- libs\lib-ssh.bash : start ssh-agent and register all keys in ".ssh/" folder

### Tech details
- setup.bash : is the shell installer script
- autoinstaller4curl.bash : remote installer that git clone this repo and launch setup.bash
