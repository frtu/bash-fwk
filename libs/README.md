# lib commands

All the bash commands you can activate with :

* List all the lib available : ```lslibs```
* Import (temporary) : ```import lib-*``` (*like ```import lib-git```*)
* Persist import : ```enablelib *``` (*like ```enablelib git```*)
* Remove persisted import : ```disablelib *``` (*like ```disablelib git```*)
* Persist export env : ```envcreate "ENV_NAME" "ENV_VALUE"``` (*like ```enablelib JH12 /Library/Java/JavaVirtualMachines/xx```*)

## Topics

* [Development on VM](DevMisc.md) : Kotlin, Maven, Spring, ..
* [Development for Node & Python](DevMisc.md)
* [Virtualization](Virtualization.md) : Docker, K8S, Helm, VirtualBox, ..

## Library 'inst'

Usage ```import lib-inst```

* Install anything : ```inst "PACKAGE"```
* Uninstall anything : ```uninst "PACKAGE"```
* Update library metadata : ```upd```
* Upgrade all libraries : ```upg```

Specific installer :

* Download and move to bin path ```inst_dl_bin "EXEC_NAME" "EXEC_URL" "[BIN_PATH:/usr/local/bin/]"```

Common installer for all distribution :

* wget : ```inst_wget```
* maven : ```inst_maven```
* Misc net tools (ONLY Linux) : ```inst_net```

## Library 'systemctl'
Usage ```import lib-systemctl```

* See system service logs : ```srvlogs```
* Enable a system service : ```srvactivate "PACKAGE"```
* Get status of a system service : ```srvstatus "PACKAGE"```
* Start of a system service : ```srvstart "PACKAGE"```
* Stop of a system service : ```srvstop "PACKAGE"```
* Restart of a system service : ```srvrestart "PACKAGE"```


## Library 'key-gen'

Usage ```import lib-key-gen```

### Base commands

Generate keys / certificate :

* Generate **key pair** at specified path : ```genkeypair "KEY_PRIVATE_FILE" "[KEY_SIZE:4096|521]" "[KEY_TYPE:rsa|ecdsa]"```
* Generate **certificate request** for CA : ```gencert "CERT_FILE:server|server.csr" "KEY_PRIVATE_FILE_PATH" "[TTL:365]"```
* Generate **self-signed** certificate without password : ```gencertself "CERT_FILE:server|server.crt" "KEY_PRIVATE_FILE_PATH" "[TTL:365]"```
* Generate **key & self-signed cert pair** for server : ```gencertkey "CERT_FILE:server|server.crt" "[KEY_PRIVATE_FILE:server.key]" "[KEY_SIZE:4096|521]" "[KEY_TYPE:rsa|ecdsa]" "[TTL:365]"```
* Generate Java KeyStore JKS : ```keystoregen```

Print key / certificate :

* Print & check private key : ```printkey "KEY_PRIVATE_FILE_PATH"```
* Print certificate request : ```printreqcert "CERT_FILE"```
* Print final certificate : ```printcert```
* Print HTTPS certificate : ```printcertsslserver```


## Library 'dev-project'

* Install ```enableprj```
* Usage ```import lib-dev-project```
* Prefix ```prj```

### Base commands

Maven :

* Run a maven cmd to all subfolders : ```prjmvn "COMMAND"```
* Run maven compile to all subfolders : ```prjmc```

Git :

* Run a git cmd to all subfolders : ```prjgit "COMMAND"```
* Run git pull to all subfolders : ```prjgl```
* Run git fetch --all to all subfolders : ```prjgf```

## Library 'git'

* Usage ```import lib-git```
* Prefix ```g```

### Base commands

* Git stash : ```gs```
* Git stash pop : ```gsp```
* Git fetch all data from origin : ```gf```
* Pull from remote repo : ```gl "[REMOTE_REPO_NAME:origin]" "[REMOTE_BRANCH:master]"```
* Push to remote repo : ```gh "[REMOTE_REPO_NAME:origin]"```
* Init & add all files : ```gbase```
* Remove git from current project : ```gbaserm```

### Remote
#### Clone repository

Clone a git repo using **REPO\_NAME/PROJECT\_NAME** you copy from browser :

```
gcl "REPO_NAME/PROJECT_NAME"
```

You can also use the long syntax to :

* checkout a particular branch (you can script) 
* pass an Enterprise Github URL (by default use 'github.com')

```
gcl "REPO_NAME" "PROJECT_NAME" "[BRANCH_NAME]" "[GITHUB_ROOT_URL:github.com]"
```

#### Link local to ONE remote repository

Simple link to a remote git repo using **REPO\_NAME/PROJECT\_NAME** you copy from browser :

```
gremoteadd "REPO_NAME/PROJECT_NAME"
```

You can also use the long syntax to :

* checkout a particular remote repo 
* pass an Enterprise Github URL (by default use 'github.com')
* pass a remote branch name (use 'master' by default)

```
gremoteadd "REPO_NAME" "PROJECT_NAME" "[REMOTE_NAME:origin]" "[GITHUB_ROOT_URL:github.com]" "[BRANCH_NAME:master]"
```

#### Link local to MANY remote repositories

You have work a lot with forks, you will have **many remote origins** you want to distinguish with origin prefix 'repo-'.

* One of the forked repository name
* project name
* checkout a particular branch (you can script) 
* pass an Enterprise Github URL (by default use 'github.com')

```
gremotemultiadd "REPO_NAME" "PROJECT_NAME" "[BRANCH_NAME]" "[GITHUB_ROOT_URL:github.com]"
```

* Merge another remote branch into local : 

```
gremotemultimerge "REPO_NAME" "PROJECT_NAME" "BRANCH_NAME" "[GITHUB_ROOT_URL:github.com]"
```

#### Remote repo

* List all remote repositories : ```gremotels```
* Remove particular remote repository : ```gremoterm "REMOTE_NAME"```


### Local commands

#### File commands

* Git status : ```gstatus``` 
* Git add a file : ```gadd "FILE_PATH"```
* Git add all change & commit : ```gaddall "MESSAGE"```
* Create a diff file using X number of previous commit : ```gdiff "NUM_OF_COMMIT" "[FILE_PATH]"```
* Git diff a file : ```gdifffile "FILE_PATH"```
* Git rollback a file : ```grb "FILE_TO_ROLLBACK"```
* Git commit with a message : ```gcomm "MESSAGE"```

#### Git tags

* List tags : ```gtagls```
* List tags & ISO date : ```gtaglsdate```
* Push a local tag to remote ```gtagpush "TAG_NAME" "[REMOTE_REPO_NAME:origin]"```
* Remove a tag ```gtagrm "TAG_NAME" "[REMOTE_REPO_NAME:origin]"```

#### Git branches

* List all branches : ```gbrls```
* Use an existing branch : ```gbr "BRANCH_OR_TAG_NAME:master"```
* Git stash-checkout-pull-pop : ```gbrsp "BRANCH_NAME"```
* Create a new branch : ```gbrc "BRANCH_NAME"```
* Create a non-existing branch : ```gbrcreate "BRANCH_NAME:develop" "[REPO_NAME:origin]"```
* Rename a branch : ```gbrmv "OLD_BRANCH_NAME" "NEW_BRANCH_NAME"```
* Remove a branch : ```gbrrm "BRANCH_NAME" "[FALLBACK_BRANCH_AFTER_DELETE:master]"```

#### Git-flow branches

* Git checkout master : ```gfm```
* Git checkout develop : ```gfd```
* Git checkout or create feature branch : ```gff "FEATURE_NAME"``` or ```gffc "FEATURE_NAME"```
* Git checkout or create release branch : ```gfr "RELEASE_NAME"``` or ```gfrc "RELEASE_NAME"```
* Git checkout or create hotfix branch : ```gfh "HOTFIX_NAME"``` or ```gfhc "HOTFIX_NAME"```

#### Git history

* List all previous version : ```glog```
* Change HEAD to previous version : ```greset "COMMIT_ID"```

#### Git patches

* Generate a diff file from local change : ```gpatch "DIFF_FILENAME"```
* Apply diff file into local repo : ```gpatchapply "DIFF_FILENAME"```

#### Configuration

* List all local configurations : ```gconfls```
* Set a new configuration : ```gconfset "CONF_PARAM_NAME" "CONF_PARAM_VALUE"```
* Configure user name : ```gconfsetname "NAME_PARAM_VALUE"```
* Configure email : ```gconfsetemail "EMAIL_PARAM_VALUE"```
* Configure proxy : ```gconfsetproxy "PROXY_PARAM_VALUE"```
