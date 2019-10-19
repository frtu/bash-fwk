# lib commands

All the bash commands you can activate with :

* List all the lib available : ```lslibs```
* Import (temporary) : ```import lib-*``` (*like ```import lib-git```*)
* Persist import : ```enablelib *``` (*like ```enablelib git```*)
* Remove persisted import : ```disablelib *``` (*like ```disablelib git```*)

## Library 'git'

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

#### Git tags

* List tags : ```gtagls```
* List tags & ISO date : ```gtaglsdate```
* Push a local tag to remote ```gtagpush "TAG_NAME"```

#### Git branches

* List all branches : ```gbrls```
* Use an existing branch : ```gbr "BRANCH_OR_TAG_NAME:master"```
* Create a non-existing branch : ```gbrcreate "BRANCH_NAME:develop" "[REPO_NAME:origin]"```
* Rename a branch : ```gbrmv "OLD_BRANCH_NAME" "NEW_BRANCH_NAME"```
* Remove a branch : ```gbrrm "BRANCH_NAME" "[FALLBACK_BRANCH_AFTER_DELETE:master]"```

#### Git patches

* Generate a diff file from local change : ```gpatch "DIFF_FILENAME"```
* Apply diff file into local repo : ```gpatchapply "DIFF_FILENAME"```

#### Configuration

* List all local configurations : ```gconfls```
* Set a new configuration : ```gconfset "CONF_PARAM_NAME" "CONF_PARAM_VALUE"```
* Configure user name : ```gconfsetname "NAME_PARAM_VALUE"```
* Configure email : ```gconfsetemail "EMAIL_PARAM_VALUE"```
* Configure proxy : ```gconfsetproxy "PROXY_PARAM_VALUE"```

## Library 'dev-maven-release'

### Validation commands

Validate phase allow to run everything that can interrupt or break the Release phase :

* Run Unit Tests & Javadoc : ```mvnreleasevalidate```

### Release commands

* Create a git tag with the specified version : ```mvnreleasetagversion "[RELEASE_VERSION]" "[FOLLOWING_VERSION_WITHOUT_SNAPSHOT]"```

You can also use the skip everything syntax : ```mvnreleasetagsk```

* Deploy to nexus repository : ```mvnreleasedeploy```


## Library 'docker'

### Image repository

* List all local images : ```dckls```
* Pull locally remote image ```dckpull [IMAGE_NAME]```
* Search remote ```dcksearch [IMAGE_NAME]```

### Administrate docker instances

Base commands :

* List all existing instances : ```dckps```
* Start existing instance : ```dckstart [IMAGE_NAME]```
* Read instance console : ```dcklogs [IMAGE_NAME]```
* Stop existing instance : ```dckstop [IMAGE_NAME]```
* Remove existing instance : ```dckrm [IMAGE_NAME]```

Status :

* Check instance definition : ```dckinspect [IMAGE_NAME]```
* Check health : ```dcktop [IMAGE_NAME]```

(ATTENTION) Long commands :

* Start ALL existing instances : ```dckstartall```
* Stop ALL running instances : ```dckstopall```

### Interacting with instance

* Copy a file IN or OUT the docker instance : ```dckcp "SOURCE" "DESTINATION"```
* Open a command line into docker instance : ```dckbash [IMAGE_NAME]```
