# lib commands

All the bash commands you can activate with :

* List all the lib available : ```lslibs```
* Import (temporary) : ```import lib-*``` (*like ```import lib-git```*)
* Persist import : ```enablelib *``` (*like ```enablelib git```*)
* Remove persisted import : ```disablelib *``` (*like ```disablelib git```*)

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

* Enable a system service : ```activate "PACKAGE"```
* Get status of a system service : ```status "PACKAGE"```
* Start of a system service : ```start "PACKAGE"```
* Stop of a system service : ```stop "PACKAGE"```
* Restart of a system service : ```restart "PACKAGE"```

## Library 'git'

Usage ```import lib-git```

### Base commands

* Pull from remote repo : ```gl "[REMOTE_REPO_NAME:origin]" "[REMOTE_BRANCH:master]"```
* Push to remote repo : ```gh "[REMOTE_REPO_NAME:origin]"```


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
* Push a local tag to remote ```gtagpush "TAG_NAME" "[REMOTE_REPO_NAME:origin]"```
* Remove a tag ```gtagrm "TAG_NAME" "[REMOTE_REPO_NAME:origin]"```

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

## Library 'dev-maven-archetype'

### Install

* Enable Maven Archetype generator library with the [dedicated version](https://search.maven.org/search?q=g:com.github.frtu.archetype) : ```enablemvngen "ARCHETYPE_VERSION"```

### Usage

Allow to generate all kinds of projects :

* Base project with parent pom : ```mvngen base "GID" "AID" "[VERSION:0.0.1-SNAPSHOT]"```

For Stream Processing : 

* Kafka Publisher with parent pom : ```mvngen plt-kafka "GID" "AID" "[VERSION:0.0.1-SNAPSHOT]"```
* Spark Consumer with parent pom : ```mvngen plt-spark "GID" "AID" "[VERSION:0.0.1-SNAPSHOT]"```
* Simple Avro Data model project : ```mvngen avro "GID" "AID" "[VERSION:0.0.1-SNAPSHOT]"```

### Local dev

Replace ```mvngen``` -> ```mvngenlocal``` to use local repository for archetypes :

* Ex : ```mvngenlocal base "GID" "AID" "[VERSION:0.0.1-SNAPSHOT]"```
* Clean and install plugin : ```mvninst```


## Library 'dev-maven-release'

### Validation commands

Validate phase allow to run everything that can interrupt or break the Release phase :

* Run Unit Tests & Javadoc : ```mvnreleasevalidate```

### Release commands

* Create a git tag with the specified version : ```mvnreleasetagversion "[RELEASE_VERSION]" "[FOLLOWING_VERSION_WITHOUT_SNAPSHOT]"```

You can also use the skip everything syntax : ```mvnreleasetagsk```

* Deploy to nexus repository : ```mvnreleasedeploy```


## Library 'docker'

Usage ```import lib-docker```

### Image repository

* List all local images : ```dckls```
* Search remote ```dcksearch "IMAGE_NAME"```
* Pull locally remote image ```dckpull "IMAGE_NAME"```
* Export image to file : ```dckexport "IMAGE_NAME:TAG_NAME" "[FILENAME_TAR]"```
* Import image from file : ```dckimport "DCK_IMAGE_FILENAME"```
* Import image files containing text filter from folder : ```dckimportfolder "DOCKER_IMAGE_FILE_FILTER" "[FOLDER_PATH]"```

### Administrate docker instances

Base commands :

* Get Docker version : ```dck```
* List all existing instances : ```dckps```
* Start existing instance : ```dckstart "INSTANCE_NAME"```
* Read instance console : ```dcklogs "INSTANCE_NAME"```
* Stop existing instance : ```dckstop "INSTANCE_NAME"```
* Remove existing instance : ```dckrm "INSTANCE_NAME"```

Status :

* Check instance definition : ```dckinspect "INSTANCE_NAME"```
* Check health : ```dcktop "INSTANCE_NAME"```

(ATTENTION) Long commands :

* Start ALL existing instances : ```dckstartall```
* Stop ALL running instances : ```dckstopall```

### Interacting with instance

* Copy a file IN or OUT the docker instance : ```dckcp "SOURCE" "DESTINATION"```
* Open a BASH command line into docker instance : ```dckbash "INSTANCE_NAME" "[COMMANDS]"```
* Open an SH command line into docker instance : ```dcksh "INSTANCE_NAME" "[COMMANDS]"```

If you just want to check an image, these funtions will create and remove a temporary instance of this image : 

* Open a BASH command line into docker image : ```dckimagebash "IMAGE_NAME"```
* Open an SH command line into docker image : ```dckimagesh "IMAGE_NAME"```

### Network & Bridge

* List all existing networks : ```dcknetls```
* List all existing networks, inspect bridge & host : ```dcknetlsfull```
* Remove existing network : ```dcknetrm "NETWORK_NAME_OR_IDs"```

### Extra support

* Run Tomcat image : ```dckrunjava "IMAGE_NAME:service-a:0.0.1-SNAPSHOT" "[PORT:8080]" "[INSTANCE_NAME]"```
* Run temporary Tomcat image port 8080 with System env : ```dckrunjavaenv "IMAGE_NAME:service-a:0.0.1-SNAPSHOT" "[SYS_ENV_ARRAY]"```


### Module 'docker-compose'

Base commands :

* Get docker-compose version : ```dcmp```
* List all docker-compose instances : ```dcmpps```
* Start local docker-compose & tail : ```dcmpstart```
* Start local docker-compose as a daemon : ```dcmpstartd ```
* Read instance console : ```dcmplogs "INSTANCE_NAME"```
* Stop local docker-compose : ```dcmpstop```


### Module 'docker-registry'

Base commands :

* **Tag** existing local image with a registry URL : ```dckregtag "IMAGE_NAME:TAG_NAME" "[DOCKER_REGISTRY_URL:myregistry-127-0-0-1.nip.io:5000]"```
* **Push** local image into registry URL : ```dckregpush "IMAGE_NAME:TAG_NAME" "[DOCKER_REGISTRY_URL:myregistry-127-0-0-1.nip.io:5000]"```
* **Tag and push** existing image into registry URL : ```dckregtag "IMAGE_NAME:TAG_NAME" "[DOCKER_REGISTRY_URL:myregistry-127-0-0-1.nip.io:5000]"```

For Centos, docker registry distribution :

* **Install** : ```inst_docker_registry```
* List all images in folder : ```dckregls```
* CD into image folder : ```dckregcd```
* Get registry **status** : ```dckregstatus ```
* **Start** registry : ```dckregstart```
* **Stop** registry : ```dckregstop```
* **Restart** registry : ```dckregrestart```

### Linux configuration

Base commands :

* Edit local docker daemon config : ```dcksrvvi```


## Library 'k8s-minikube'

* Usage ```import lib-k8s-minikube```
* Prefix ```km``` 

### Base commands

All start commands (if not exists, create automatically) :

* **Start Minikube** using INSTANCE_NAME : ```kmstart "[INSTANCE_NAME]" "[EXTRA_PARAMS]"```
* Start Minikube with the **specific driver** (virtualbox | none | ..) using INSTANCE_NAME : ```kmstartdriver "DRIVER_NAME" "INSTANCE_NAME" "[EXTRA_PARAMS]"```
* Start Minikube using **specific Docker Registry url** (**registry-mirror** if https | **insecure-registry** if http): ```kmstartreg "[INSTANCE_NAME]" "[REGISTRY_URL]" "[EXTRA_PARAMS]"```
* Start Minikube using **specific proxy** : ```kmstartproxy "[INSTANCE_NAME]" "[PROXY_URL]" "[EXTRA_PARAMS]"```

Other base commands :


* Install Minikube in bin path : ```inst_minikube "[EXEC_URL]" "[BIN_PATH:/usr/local/bin/]"```
* Get Minikube version and others info : ```km```
* Open a **SSH** command into minikube instance : ```kmssh "[INSTANCE_NAME]" "[COMMANDS]"```
* See **Logs** of this INSTANCE_NAME : ```kmlogs "[INSTANCE_NAME]"```
* **Stop** this INSTANCE_NAME : ```kmstop "[INSTANCE_NAME]"```
* **Delete** this INSTANCE_NAME : ```kmrm "INSTANCE_NAME"```

### Network

* Minikube IP : ```kmip "[INSTANCE_NAME]"```


## Library 'virtualbox'

Usage ```import lib-virtualbox```

### Base commands

* Get VirtualBox version : ```vbox "[-a]"```
* List VirtualBox images : ```vboxls```
* Inspect an existing image : ```vboxinspect "INSTANCE_NAME"```

### Administrate virtualbox image

Install fwk :

* Mount local [bash-fwk](https://github.com/frtu/bash-fwk) into virtualbox image : ```vboxfwk "INSTANCE_NAME" "USER_HOME"```

Base commands :

* Create a new instance : ```vboxcreate "INSTANCE_NAME" "BASE_FOLDER" "[CPU_NB]" "[MEMORY_MB]" "[NETWORK:82540EM|virtio]"```
* Start existing instance : ```vboxstart "INSTANCE_NAME"```
* Stop existing instance : ```vboxstop "INSTANCE_NAME"```
* Pause existing instance : ```vboxpause "INSTANCE_NAME"```
* Resume existing instance : ```vboxresume "INSTANCE_NAME"```

Modify an existing instance :

* Mount a new storage : ```vboxstorage "INSTANCE_NAME" "IMAGE_FILEPATH" "[PORT_NUMBER]"```
* Mount a host folder : ```vboxmount "INSTANCE_NAME" "HOST_FOLDER_PATH" "TARGET_FOLDER_NAME"```
* Modify memory : ```vboxmemory "INSTANCE_NAME" "MEMORY_MB"```
* Expose instance port into host : ```vboxport "INSTANCE_NAME" "PORT"```

Network :

* List all DHCP : ```vboxnetdhcp```
* ...