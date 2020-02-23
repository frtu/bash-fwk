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

Print key / certificate :

* Print & check private key : ```printkey```
* Print certificate request : ```printreqcert```
* Print final certificate : ```printcert```


## Library 'git'

Usage ```import lib-git```

### Base commands

* Git status : ```gstatus```
* Git rollback a change to repo : ```grb "FILE_TO_ROLLBACK"```
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

* Usage ```import lib-docker```
* Prefix ```dck``` 

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


## Library 'virtualbox'

* Usage ```import lib-virtualbox```
* Prefix ```vbox``` 

### Base commands

* Get VirtualBox version : ```vbox "[-a]"```
* List VirtualBox images : ```vboxls```
* Inspect an existing image : ```vboxinspect "INSTANCE_NAME"```

### Administrate virtualbox image

Install fwk :

* Mount local [bash-fwk](https://github.com/frtu/bash-fwk) into virtualbox image : ```vboxmountfwk "INSTANCE_NAME" "GUEST_HOME"```

Base commands :

* Create a new instance : ```vboxcreate "INSTANCE_NAME" "BASE_FOLDER" "[CPU_NB]" "[MEMORY_MB]" "[NETWORK:82540EM|virtio]"```
* Start existing instance : ```vboxstart "INSTANCE_NAME"```
* Stop existing instance : ```vboxstop "INSTANCE_NAME"```
* Pause existing instance : ```vboxpause "INSTANCE_NAME"```
* Resume existing instance : ```vboxresume "INSTANCE_NAME"```
* Delete existing instance : ```vboxrm "INSTANCE_NAME"```

Modify an existing instance :

* Mount a new storage : ```vboxstorage "INSTANCE_NAME" "IMAGE_FILEPATH" "[PORT_NUMBER]"```
* Mount a host folder : ```vboxmount "INSTANCE_NAME" "HOST_FOLDER_PATH" "TARGET_FOLDER_NAME"```
* Modify memory : ```vboxmemory "INSTANCE_NAME" "MEMORY_MB"```
* Expose instance port into host : ```vboxport "INSTANCE_NAME" "PORT"```

Network :

* List all DHCP : ```vboxnetdhcp```
* ...

## Library 'k8s-minikube'

* Usage ```import lib-k8s-minikube```
* Prefix ```km```

### Base commands

* Get Minikube version : ```km```
* Go to Minikube **cache** folder : ```cdkm```
* Go to Minikube **var** folder (/var/lib/minikube) : ```cdkmvar```

All start commands (if not exists, create automatically) :

* **Start Minikube** using INSTANCE_NAME : ```kmstart "[INSTANCE_NAME]" "[EXTRA_PARAMS]"```
* Start Minikube with the **specific version** using INSTANCE_NAME : ```kmstartversion "VERSION:v1.16.2" "[INSTANCE_NAME:minikube]" "[EXTRA_PARAMS]"```
* Start Minikube with the **specific driver** (virtualbox | none | ..) using INSTANCE_NAME : ```kmstartdriver "DRIVER_NAME" "[INSTANCE_NAME:minikube]" "[EXTRA_PARAMS]"```
* Start Minikube using **specific Docker Registry url** (**registry-mirror** if https | **insecure-registry** if http): ```kmstartreg "[INSTANCE_NAME]" "[REGISTRY_URL]" "[EXTRA_PARAMS]"```
* Start Minikube using **specific proxy** : ```kmstartproxy "[INSTANCE_NAME]" "[PROXY_URL]" "[EXTRA_PARAMS]"```

Start Minikube in local mode with apiserver=local & local driver (if 'none' only one instance allowed) :

* Start in local mode. (OPTIONAL) Allow to change k8s version or Driver : ```kmstartlocal "[K8S_VERSION]" "[DRIVER_NAME:none]" "[INSTANCE_NAME:minikube]" "[EXTRA_PARAMS]"```

Config commands :

* Set Minikube to use this specific driver for the next start : ```kmconfdriverset "DRIVER_NAME:none|virtualbox|hyperkit"```
* Mute Minikube new version alert : ```kmconfmute```
* Edit Minikube config : ```kmconfvi```


Other base commands :

* Get Minikube version and others info : ```km```
* Open a **SSH** command into minikube instance : ```kmssh "[INSTANCE_NAME]" "[COMMANDS]"```
* Check **Status** of this INSTANCE_NAME : ```kmstatus "[INSTANCE_NAME]"```
* See **Logs** of this INSTANCE_NAME : ```kmlogs "[INSTANCE_NAME]"```
* **Stop** this INSTANCE_NAME : ```kmstop "[INSTANCE_NAME]"```
* **Delete** this INSTANCE_NAME : ```kmrm "INSTANCE_NAME"```

### Network

* Minikube IP : ```kmip "[INSTANCE_NAME]"```
* Print a specific service URL : ```kmsvc "SERVICE_NAME" "[INSTANCE_NAME:minikube]"```

## Library 'k8s'

* Usage ```import lib-k8s```
* Prefix ```kc``` 

### Base commands

* Get kubectl version, list all clusters & nodes : ```kc```
* Go to K8S config & cache folder : ```cdkc```
* Check k8s by running echo : ```kchello```

All kubectl listing commands in the current cluster and namespace :

* List all **k8s resources/objects** : ```kcls [NAMESPACE]```
* List all **namespaces** : ```kclsnamespaces```
* List all **pods** : ```kclspods [NAMESPACE]```
* List all **services**  : ```kclsservices [NAMESPACE]```
* List all **deployments** : ```kclsdeployments [NAMESPACE]```
* List all events : ```kclsevents [NAMESPACE]```
* List all api services : ```kclsapi [NAMESPACE]```
* List all resources types : ```kclsresources```

ATTENTION - Wildcard delete :

* **Delete** any resources (pod, service or deployment) of that name : ```kcrm "RESOURCE" "[NAMESPACE]"```
* **Clean up ALL** resources in that namespace : ```kcrmall "NAMESPACE"```

### Deployment 'kcdp' commands

* **List** all existing deployment : ```kcdpls [NAMESPACE]```
* **Create** a new deployment : ```kcdprun "IMAGE_NAME" "DEPLOYMENT_NAME" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"```
* Get **info** from an existing deployment : ```kcdpinfo "DEPLOYMENT_NAME" "[NAMESPACE]"```
* **Expose** a port through a service : ```kcdpexpose "DEPLOYMENT_NAME" "SERVICE_NAME" "PORT" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"```

...

## Library 'helm'

* Usage ```import lib-helm```
* Prefix ```hm``` 

### Base commands

* Get Helm version : ```hm```
* Create chart template folder : ```hmcreate "CHART_FOLDER"```
* Generate chart : ```hmgen "CHART_FOLDER"```
* Package chart : ```hmpkg "CHART_FOLDER"```
* Get history : ```hmhistory "CHART_FOLDER"```

### With K8s commands

* List all installed chart instances : ```hmls```
* Install and allow to override config using YAML file : ```hminst "CHART_FOLDER" "[INSTANCE_NAME]" "[CUSTOM_CONFIG_FILE]"```
* Upgrade existing chart instance : ```hmupg "CHART_FOLDER" "INSTANCE_NAME"```
* Rollback existing chart instance : ```hmrollback "INSTANCE_NAME"```
* Remove existing chart instance (v2 ONLY) : ```hmrm "INSTANCE_NAME"```
* Remove existing chart instance (v3 ONLY) : ```hmuninst "INSTANCE_NAME"```

### K8S service commands

* Helm initialize service-account tiller : ```hmsrvinit "[SERVICE_ACCOUNT:tiller]"```
* Upgrade service-account tiller : ```hmsrvupg "[SERVICE_ACCOUNT:tiller]"```
* Get Helm K8s deployment info (tiller-deploy) : ```hmsrvinfo "[NAMESPACE:kube-system]"```
* Delete Helm K8s deployment (tiller-deploy) : ```hmsrvrm```

### Remote repo commands

* Add a new Chart repo URL & prefix : ```hmrepo "[REPO_URL:https://kubernetes-charts.storage.googleapis.com/]" "[REPO_NAME:stable]"```
* Add a new Chart repo URL & prefix for CN : ```hmrepo "[REPO_URL:https://apphub.aliyuncs.com/]" "[REPO_NAME:apphub]"```
* Upgrade Chart repo index : ```hmrepoupd```
* Search Chart repo : ```hmsearch "[REPO_NAME:stable?]"```

To manage locally charts repo at *~/git/helm-charts* (ONLY for fallback) :

* Manually checkout stable git locally : ```hmrepogit```
* Go to local folder : ```hmrepogitcd```

### Common installation

* Install Chart Museum : ```hminstchartmuseum```
