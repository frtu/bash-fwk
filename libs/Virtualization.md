# Virtualization lib

## Library 'docker'

* Usage ```import lib-docker```
* Prefix ```dck``` 

### Local Image repository

* **List** all local images : ```dckls "[CONTAINING_TEXT]"```
* **Import** image from file : ```dckimport "DCK_IMAGE_FILENAME"```
* **Import** image files containing text filter from folder : ```dckimportfolder "DOCKER_IMAGE_FILE_FILTER" "[FOLDER_PATH]"```
* **Export** image to file : ```dckexport "IMAGE_NAME:TAG_NAME" "[FILENAME_TAR]"```
* **Remove Image** from local repository : ```dckrmimage "IMAGE_NAME"```
* **Force Remove** Image : ```dckrmimage "IMAGE_NAME"```
* **Clean up** local image from dependencies : ```dckimgclean```
* **Clean up** all (from dep & if not used) : ```dckimgcleanall```
* Clean up all till yesterday : ```dckimgcleanyesterday```

### Remote repository

* **Search** remote ```dcksearch "IMAGE_NAME"```
* **Pull** locally remote image ```dckpull "IMAGE_NAME"```

### Administrate docker instances

Base commands :

* Get Docker version : ```dck```
* List all existing instances : ```dckps "[CONTAINING_TEXT]"```
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

### ONLY for linux configuration

Base commands for service **docker** :

* Service status : ```dcksrvstatus```
* Service start : ```dcksrvstart```
* Service stop : ```dcksrvstop```
* Service re start : ```dcksrvrestart```

Administration :

* Activate docker as a service : ```activatedck```
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

## Library 'k8s-gke'

* Usage ```import lib-k8s-gke```
* Prefix ```gke```

### Base commands

* Get gcloud info : ```gke```
* Login to google cloud : ```gkelogin```
* Initialize configuration for GKE : ```gkeinit```

### Manage project

* Create gke alias to a project : ```gkeaddprj "PROJECT_ID" "PROJECT_NAME" "REGION"```
* Switch project using previously created alias : ```gkeprj<PROJECT_NAME>```
* Check the current project : ```kcctx```


## Library 'k8s-kind'

* Usage ```import lib-k8s-kind```
* Prefix ```kd```
* Install ```enablekind``` & ```inst_kind```

### Admin commands

* List all kind clusters : ```kdls```
* Get more info for a particular cluster : ```kdinfo "CLUSTER_NAME"```
* Create a new cluster : ```kdc "[CLUSTER_NAME:kind]" "[CONFIG_FILE]" "[OVERRIDE_IMAGE:kindest/node:v1.17.2]"```
* List all nodes : ```kdgetnodes```
* Print K8s config : ```kdgetconfig```
* Generate a cluster config : ```kdgenconfig "[CONFIG_FILE]"```
* Delete a cluster : ```kdrm "[CLUSTER_NAME]"```

### Manage instances

* Load docker image into cluster : ```kdimport "IMAGE_NAME" "[CLUSTER_NAME]"``` or ```kdload```
* Install dashboard : ```kdinstdashboard```

### ArgoCD

* Install ArgoCD : ```kdinstargocd```
* List all components from ArgoCD : ```kdargocdls```
* Open port to ArgoCD : ```kdargocd "[PORT_MAPPING-8080]"```
* Get Admin pwd for ArgoCD : ```kdargocdpassword```

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

### ONLY for linux configuration

Base commands for **kubelet** :

* Service status : ```kcsrvstatus```
* Service start : ```kcsrvstart```
* Service stop : ```kcsrvstop```
* Service re start : ```kcsrvrestart```

## Library 'k8s'

* Usage ```import lib-k8s```
* Prefix ```kc``` 

TIPS : can also check [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

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
* List all resource YAML : ```kcyaml "[RESOURCE:all]" "[NAMESPACE:default]"```

ATTENTION - Wildcard delete :

* **Delete** any resources (pod, service or deployment) of that name : ```kcrm "RESOURCE" "[NAMESPACE]"```
* **Clean up ALL** resources in that namespace : ```kcrmall "NAMESPACE"```

### Working with apps

* Run a **bash command** to a particular pod : ```kcbash "POD_NAME" "[NAMESPACE]" "[COMMANDS]"```
* Open a **http proxy** at specified port into a particular pod : ```kcproxy "POD_NAME" "[PORT:8001]" "[NAMESPACE]"```
* **Top** from an existing pod : ```kcpodtop "POD_NAME"```
* Get **Logs** from an existing pod : ```kcpodlogs "POD_NAME"```
* **Tail logs** from an existing pod : ```kcpodtail "POD_NAME"```
* **Attach to a process** that is already running inside an existing container : ```kcattach "POD_NAME" "[NAMESPACE]" "[CONTAINER_NAME]"```
* Open a **tunnel** from a particular pod into localhost : ```kcportfwd "POD_NAME" "PORT_MAPPING-8080:80" "[NAMESPACE]"```

Interaction with files

* **Copy** file from/to depending on the if source or destination is prefixed by pod : ```kcpodcp "SOURCE" "DESTINATION"```
* Copy file **from pod** using file path : ```kcpodcpfrom "POD_FULL_NAME:<namespace>/<pod>" "SOURCE_PATH" "DESTINATION_PATH"```
* Copy file **to pod** using file path : ```kcpodcpto "POD_FULL_NAME:<namespace>/<pod>" "SOURCE_PATH" "DESTINATION_PATH"```

### Deployment 'kcns' commands

* List all **namespaces** : ```kcnsls```
* List all **namespaces** showing labels : ```kcnslsfull```
* Set **current** namespace : ```kcnsset```
* **Create** a new deployment : ```kcnscreate ".."```
* Get **info** from an existing namespace : ```kcnsinfo ".."```
* Get **YAML** from an existing namespace : ```kcnsyaml ".."```
* Get **JSON** from an existing namespace : ```kcnsjson ".."```
* **Edit** from an existing namespace : ```kcnsvi ".."```
* **Remove** from an existing namespace : ```kcnsrm ".."```

### Deployment 'kcpod' commands

When discovering pods, use :

* List all **pods** and IPs : ```kclspods [NAMESPACE]```
* List all **pods** and IPs : ```kclspodsfull "[NAMESPACE]" "[OPTION:wide|yaml]"```

These commands are easier with 'kcnsset NAMESPACE' :

* List all **pods** or the ones containing text : ```kcpodls "[CONTAINING_TEXT]" "[NAMESPACE]"```
* List all **pods** showing labels : ```kcpodlabel```
* Get **YAML** from an existing pod : ```kcpodyaml "POD_NAME" "NAMESPACE"```
* Get **info** from an existing pod : ```kcpodinfo "POD_NAME" "NAMESPACE"```
* Get **container ID** from a pod : ```kcpodid "POD_NAME" "NAMESPACE"```
* **Create** a new pod : ```kcpodrun "IMAGE_NAME" "INSTANCE_NAME" "[NAMESPACE]" "[PORT]"```
* **Remove** from an existing pod : ```kcpodrm "POD_NAME" "NAMESPACE"```

### Deployment 'kcsvc' commands

* List all **services** : ```kcsvcls```
* Get **YAML** from an existing service : ```kcsvcyaml "SERVICE_NAME" "NAMESPACE"```
* Check status for an existing **service** : ```kcsvschk "SERVICE_NAME" "[NAMESPACE]"```
* **Remove** from an existing service : ```kcsvcrm "SERVICE_NAME" "[NAMESPACE]"```

### Deployment 'kcdp' commands

* **List** all existing deployment : ```kcdpls [NAMESPACE]```
* **Create** a new deployment : ```kcdprun "IMAGE_NAME" "DEPLOYMENT_NAME" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"```
* Get **YAML** from an existing deployment : ```kcdpyaml "DEPLOYMENT_NAME" "NAMESPACE"```
* Get **info** from an existing deployment : ```kcdpinfo "DEPLOYMENT_NAME" "[NAMESPACE]"```
* **Expose** a port through a service : ```kcdpexpose "DEPLOYMENT_NAME" "SERVICE_NAME" "PORT" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"```
* **Remove** from an existing deployment : ```kcdprm "DEPLOYMENT_NAME" "[NAMESPACE]"```

### K8s context 'kcctx' commands

* List all **K8s context** : ```kcctx```
* Switch to one specific **K8s context** : ```kcctx "[CONTEXT]"```
* Set the default namespace for this context : ```kcctxnamespace "NAMESPACE" "[CONTEXT]"```
* Print k8s context in YAML format : ```kcconf```
* Print k8s context file : ```kcconfcat```

### Manage YAML commands

* Deploy to k8s cluster **YAML files** : ```kccreate "FILE_NAME" "[NAMESPACE]"```
* Apply YAML files : ```kcapply "FILE_NAME"```

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
