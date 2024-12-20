# Virtualization lib

## Library 'docker'

* Usage ```import lib-docker```
* Prefix ```dck``` 

### Local Image repository

* **Print** config file : ```dckconf```
* **Edit** config file : ```dckconfvi```

### Local Image repository

* **List** all local images : ```dckls "[CONTAINING_TEXT]"```
* **Import** image from file : ```dckimport "DCK_IMAGE_FILENAME"```
* **Import** image files containing text filter from folder : ```dckimportfolder "DOCKER_IMAGE_FILE_FILTER" "[FOLDER_PATH]"```
* **Export** image to file : ```dckexport "IMAGE_NAME:TAG_NAME" "[FILENAME_TAR]"```
* **Remove Image** from local repository : ```dckrmimage "IMAGE_NAME"```
* **Force Remove** Image : ```dckrmimage "IMAGE_NAME"```
* **List** all local images digest : ```dckimgdigest [CONTAINING_TEXT]```
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

* Check instance status : ```dckdescstatus "INSTANCE_NAME"```
* Check instance IP : ```dckdescip "INSTANCE_NAME"```
* Check instance ports : ```dckdescport "INSTANCE_NAME"```
* Check instance networks : ```dckdescnet "INSTANCE_NAME"```
* Check full instance definition : ```dckdesc "INSTANCE_NAME"```
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
* Inspect or describe a specific network : ```dcknetdesc "NETWORK_NAME_OR_IDs"```
* Create a new docker network : ```dcknetcreate "NETWORK_NAME"```
* Remove existing network : ```dcknetrm "NETWORK_NAME_OR_IDs"```
* Allow a container to connect to a specific network : ```dcknetconnect "CONTAINER_NAME" "[NETWORK_NAME:bridge]"```
* List all the containers connecting to a specific network : ```dcknetconnectedls "NETWORK_NAME:bridge"```

Troubleshooting

* Debug container using [netshoot](https://github.com/nicolaka/netshoot/blob/master/README.md) : ```dcknetdebug "CONTAINER_NAME" "[DEBUG_IMAGE_NAME:nicolaka/netshoot]"```

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

* Configure registry mirror : ```dckregmirror "DOCKER_REGISTRY_DOMAIN_NAME"```
* Dislpay daemon config : ```dckregconf```
* Persist into daemon config insecure registry : ```dckregconfpersist "[DOCKER_REGISTRY_DOMAIN_NAME:docker-registry:5000]"```
* Remove file : ```dckregconfrm```
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

## Library 'k8s-resources'

* Usage ```import lib-k8s-resources```
* Prefix ```kr```

### Base commands

* Create Pod : ```krpod "APP_NAME" "IMAGE_NAME" "PORT" "[ARGS]"```
* Create Deployment : ```krdp "APP_NAME" "IMAGE_NAME" "PORT" "[ARGS]"```
* Create Service : ```krsvc "TARGET_PORT" "[PORT:80]" "[SVC_NAME:sample]" "[APP_NAME:sample]"```
* Create Ingress : ```kringress "TARGET_PORT" "[INGRESS_NAME:sample]" "[APP_NAME:sample-service]" "[PATH:sample]"```

### Common images

* Create NGINX deployment : ```krnginx "[APP_NAME:nginx]" "[IMAGE_NAME:nginx:1.14.2]" "[PORT:80]"```

## Library 'k8s-gke'

* Usage ```import lib-k8s-gke```
* Prefix ```gke```

Enable using ```enablegke```

Make sure to install : using ```gkeinst``` or [gcloud install page](https://cloud.google.com/sdk/docs/install)

### Base commands

* Get gcloud info : ```gke```
* Login to google cloud : ```gkelogin```
* List all accounts : ```gkeloginls```
* Initialize configuration for GKE : ```gkeinit```
* Component updates (to a specific version) : ```gkeupd "[VERSION:412.0.0]"```
* Run diagnostics (may help to detect proxy) : ```gkediagnostics```

### Manage cluster

* Get gcloud config help : ```gkeconf```
* Config set region : ```gkeconfregion "REGION_NAME:asia-east2"```
* Config set zone : ```gkeconfzone "ZONE_NAME:asia-east2-c"```

### Manage project

* list all projects : ```gkeprj```
* Create gke alias to a project : ```gkeprjadd "PROJECT_ID:zeta-surf-123456" "CLUSTER_NAME:cluster-asia-east" "REGION"```
* Switch project using previously created alias : ```gkeprj<PROJECT_NAME>```
* Set current project to : ```gkeprjset "PROJECT_ID:zeta-surf-123456"```
* Get project credential : ```gkeprjgetcredential "PROJECT_ID:zeta-surf-123456" "CLUSTER_NAME:cluster-asia-east" "REGION"```
* Check the current project : ```kcctx```

### Manage registry (bin repo)

* Configure Binary image repo : ```gkereg```
* Enable a specific [service](https://cloud.google.com/container-registry/docs/enable-service) : ```gkesvcenable "SERVICE_NAME:containerregistry"```
* List all service-acounts : ```gkeacctls```
* Configure auth using service-account : ```gkeacctauth "ACCOUNT:USERNAME@PROJECT_ID.iam.gserviceaccount.com" "KEY_FILE"```

## Library 'k8s-argocd'

* Usage ```import lib-k8s-argocd```
* Prefix ```ka```

### Base commands

* Login to ArgoCD : ```kalogin "[SERVER_URL:localhost:8080]"```
* Update ArgoCD pwd : ```kapwdupd```
* Adding ArgoCD service-account to that target cluster : ```katarget "TARGET_CLUSTER_NAME:target-k8s"```

## Library 'k8s-kind'

* Usage ```import lib-k8s-kind```
* Prefix ```kd```
* Install ```enablekind``` & ```inst_kind```

### Admin commands

* List all kind clusters : ```kdls```
* Get more info for a particular cluster : ```kdinfo "CLUSTER_NAME"```
* Create a new cluster : ```kdc "[CONFIG_FILE]" "[CLUSTER_NAME:kind]"  "[OVERRIDE_IMAGE:kindest/node:v1.17.2]"```
* List all nodes : ```kdgetnodes```
* Print K8s config : ```kdgetconfig```
* Generate a cluster config and add Docker registry : ```kdgenconfig "[CONFIG_FILE]" "[REG_HOST]" "[REG_PORT:5000]"```
* Delete a cluster : ```kdrm "[CLUSTER_NAME]"```

### Manage instances

* Add configmap for a specific docker registry : ```kdconfreg "[REG_PORT:5000]"```
* Load docker image into cluster : ```kdimport "IMAGE_NAME" "[CLUSTER_NAME]"``` or ```kdload```
* Install dashboard : ```kdinstdashboard```

### ArgoCD

* Install ArgoCD : ```kdinstargocd```
* List all components from ArgoCD : ```kdargocdls```
* Open port to ArgoCD using [http://localhost:PORT_MAPPING/](http://localhost:8080/) : ```kdargocd "[PORT_MAPPING-8080]"```
* Get ```admin``` pwd for ArgoCD : ```kdargocdpassword```

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
* Prefix ```k``` 

TIPS : can also check [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

### Base commands

* Get kubectl version, list all clusters & nodes : ```kc```
* Go to K8S config & cache folder : ```cdk```
* Check k8s by running echo : ```khello```

All kubectl listing commands in the current cluster and namespace :

* List all **k8s resources/objects** : ```kls [NAMESPACE]```
* List all **namespaces** : ```klsnamespaces```
* List all **pods** : ```klspods [NAMESPACE]```
* List all **deployments** : ```klsdeployments [NAMESPACE]```
* List all **services**  : ```klsservices [NAMESPACE]```
* List all **persistent volume claim** (pvc) : ```klspvc [NAMESPACE]```
* List all **ingress**  : ```klsingress [NAMESPACE]```
* List all **configmap**  : ```klsconfigmap [NAMESPACE]```
* List all events : ```klsevents [NAMESPACE]```
* List all api services : ```klsapi [NAMESPACE]```
* List all resources types : ```klsresources```
* List all resources YAML from this namespace : ```kyamlns "[NAMESPACE:default]" "[RESOURCE_TYPE:all]"```

ATTENTION - Wildcard delete :

* **Delete** any resources (pod, service or deployment) of that name : ```krm "RESOURCE" "[NAMESPACE]"```
* **Clean up ALL** resources in that namespace : ```krmall "NAMESPACE"```

### Working with apps

* Run a **bash command** to a particular pod : ```kbash "POD_NAME"  "[COMMANDS]"```
* Run a **bash command** to a particular pod with container name & namespace : ```kbashns "POD_NAME" "[CONTAINER]" "[NAMESPACE]" "[COMMANDS]"```
* Run a **list env vars** to a particular pod : ```kpodenv "POD_NAME" "[CONTAINING_TEXT]"```
* Open a **http proxy** at specified port into a particular pod : ```kproxy "POD_NAME" "[PORT:8001]" "[NAMESPACE]"```
* **Top** from an existing pod : ```kpodtop "POD_NAME"```
* Get **Logs** from an existing pod : ```kpodlogs "POD_NAME"```
* **Tail logs** from an existing pod : ```kpodtail "POD_NAME"```
* **Attach to a process** that is already running inside an existing container : ```kattach "POD_NAME" "[NAMESPACE]" "[CONTAINER_NAME]"```
* Open a **tunnel** from a particular pod into localhost or additionally with [EXPOSED_IP] : ```kportfwd "POD_NAME" "PORT_MAPPING-8080:80" "[EXPOSED_IP]" "[NAMESPACE]"```

Interaction with files

* **Copy** file from/to depending on the if source or destination is prefixed by pod : ```kpodcp "SOURCE" "DESTINATION"```
* Copy file **from pod** using file path : ```kpodcpfrom "POD_FULL_NAME:<namespace>/<pod>" "SOURCE_PATH" "DESTINATION_PATH"```
* Copy file **to pod** using file path : ```kpodcpto "POD_FULL_NAME:<namespace>/<pod>" "SOURCE_PATH" "DESTINATION_PATH"```

### Deployment 'kns' commands

* List all **namespaces** : ```knsls```
* List all **namespaces** showing labels : ```knslsfull```
* Set **current** namespace : ```knsset```
* **Create** a new deployment : ```knscreate ".."```
* Get **info** from an existing namespace : ```knsinfo ".."```
* Get **YAML** from an existing namespace : ```knsyaml ".."```
* Get **JSON** from an existing namespace : ```knsjson ".."```
* **Edit** from an existing namespace : ```knsvi ".."```
* **Remove** from an existing namespace : ```knsrm ".."```

### Deployment 'kpod' commands

When discovering pods, use :

* List all **pods** and IPs : ```klspods "[CONTAINING_TEXT]"```
* List all **pods** and IPs : ```klspodsfull "[NAMESPACE]" "[OPTION:wide|yaml]"```

These commands are easier with 'knsset NAMESPACE' :

* List all **pods** or the ones containing text : ```kpodls "[CONTAINING_TEXT]" "[NAMESPACE]"```
* List all **pods** showing labels : ```kpodlabel```
* Get **YAML** from an existing pod : ```kpodyaml "POD_NAME" "NAMESPACE"```
* Get **describe** or info from an existing pod : ```kpoddesc "POD_NAME" "NAMESPACE"``` or ```kpodinfo```
* Get **container ID** from a pod : ```kpodid "POD_NAME" "NAMESPACE"```
* **Create** a new pod : ```kpodrun "INSTANCE_NAME" "IMAGE_NAME" "[NAMESPACE]" "[PORT]"```
* **Remove** from an existing pod : ```kpodrm "POD_NAME" "NAMESPACE"```

### Deployment 'kdp' commands

* **List** all existing deployment : ```kdpls "[CONTAINING_TEXT]"```
* **Create** a new deployment : ```kdprun "IMAGE_NAME" "DEPLOYMENT_NAME" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"```
* Get **YAML** from an existing deployment : ```kdpyaml "DEPLOYMENT_NAME" "NAMESPACE"```
* Get **describe** or info from an existing deployment : ```kdpdesc "DEPLOYMENT_NAME" "NAMESPACE"``` or ```kdpinfo```
* **Expose** a port through a service : ```kdpexpose "DEPLOYMENT_NAME" "SERVICE_NAME" "PORT" "[NAMESPACE]" "[EXTRA_PARAMS:--dry-run|--env=\"DOMAIN=cluster\"]"```
* **Remove** from an existing deployment : ```kdprm "DEPLOYMENT_NAME" "[NAMESPACE]"```

### Deployment 'ksvc' commands

* List all **services** : ```ksvcls "[CONTAINING_TEXT]"```
* Get **YAML** from an existing service : ```ksvcyaml "SERVICE_NAME" "NAMESPACE"```
* Get **describe** or info from an existing service : ```ksvcdesc "SERVICE_NAME" "NAMESPACE"``` or ```ksvcinfo```
* Check status for an existing **service** : ```ksvschk "SERVICE_NAME" "[NAMESPACE]"```
* **Remove** from an existing service : ```ksvcrm "SERVICE_NAME" "[NAMESPACE]"```

### Deployment 'king' commands

* List all **ingress** : ```kingls "[CONTAINING_TEXT]"```
* Get **YAML** from an existing ingress : ```kingyaml "INGRESS_NAME" "NAMESPACE"```
* Get **describe** or info from an existing ingress : ```kingdesc "INGRESS_NAME" "NAMESPACE"```

### Deployment 'kvs' commands

* List all **virtual services** : ```kvsls "[CONTAINING_TEXT]"```
* Get **YAML** from an existing virtual service : ```kvsyaml "VIRTUALSERVICE_NAME" "NAMESPACE"```
* Get **describe** or info from an existing virtual service : ```kvsdesc "VIRTUALSERVICE_NAME" "NAMESPACE"```
* **Remove** from an existing virtual service : ```kvsrm "VIRTUALSERVICE_NAME" "[NAMESPACE]"```

### Deployment 'kconfigmap' commands

* List all **configmap** : ```kconfigmapls "[CONTAINING_TEXT]"```
* Get **YAML** from an existing configmap : ```kconfigmapyaml "CONFIG_MAP_NAME" "NAMESPACE"```
* Get **describe** or info from an existing configmap : ```kconfigmapdesc "CONFIG_MAP_NAME" "NAMESPACE"```

### K8s context 'kctx' commands

* List all **K8s context** : ```kctx```
* Switch to one specific **K8s context** : ```kctx "[CONTEXT]"```
* Set the default namespace for this context : ```kctxnamespace "NAMESPACE" "[CONTEXT]"```
* Print k8s context in YAML format : ```kconf```
* Print k8s context file : ```kconfcat```

### Manage YAML commands

Sample images :

* Run an instance of existing image : ```krunimage "INSTANCE_NAME" "[IMAGE_NAME:busybox]" "[NAMESPACE:default]" "[CMD]"```
* Create an instance and sleep 1d : ```krunimagepause "INSTANCE_NAME" "[NAMESPACE:default]" "[IMAGE_NAME:busybox]"```
* Bash into busybox : ```kbashbusybox "INSTANCE_NAME" "[NAMESPACE:default]" "[IMAGE_NAME:busybox]"```


Create your own image :

* Deploy to k8s cluster **YAML files** : ```kcreate "FILE_NAME" "[NAMESPACE]"```
* Apply YAML files : ```kapply "FILE_NAME"```

...


### Troubleshooting crashed pods

* Get **describe** or info from an existing pod : ```kpoddesc "POD_NAME" "NAMESPACE"``` or ```kpodinfo```
* Check logs of a **crashed pod** : ```kcrashedlogs "INSTANCE_NAME" "[NAMESPACE]" "[EXTRA_PARAMS]"```
* Open a bash on a copied **crashed pod** : ```kcrasheddebug "INSTANCE_NAME" "[IMAGE:ubuntu]" "[NAMESPACE]" "[EXTRA_PARAMS]"```
* Open a bash **modifying base image** to SET_IMAGE : ```kcrasheddebugsetimage "INSTANCE_NAME" "[SET_IMAGE:ubuntu]" "[NAMESPACE]" "[EXTRA_PARAMS]"```

## Library 'k8s-helmfile'

* Usage ```import lib-k8s-helmfile```
* Prefix ```hf```
* Install ```inst_hf```

### Base commands

* Get Helmfile version : ```hf```
* Apply all your chart releases : ```hfapply```
* Sync all your chart releases : ```hfsync```
* Sync all your chart releases (offline) : ```hfcharts```

## Library 'k8s-[helm](https://helm.sh/docs/intro/quickstart/)'

* Usage ```import lib-k8s-helm```
* Prefix ```hm``` 
* Install ```inst_hm``` & ```inst_hmdiff```

### Base commands

* Get Helm version : ```hm```

### Repo commands

* Open browser to helm hub : ```hmhub```
* Add a new Chart repo URL & prefix : ```hmrepo "[REPO_URL:https://kubernetes-charts.storage.googleapis.com/]" "[REPO_NAME:stable]"```
* Add a new Chart repo URL & prefix for CN : ```hmrepo "[REPO_URL:https://apphub.aliyuncs.com/]" "[REPO_NAME:apphub]"```
* Remove current Chart repo : ```hmrm```
* Upgrade Chart repo index : ```hmrepoupd```
* Search Chart repo : ```hmsearch "[REPO_NAME:stable]"```

Chartmuseum :

* Install chartmuseum : ```hminstchartmuseum ```

To manage locally charts repo at *~/git/helm-charts* (ONLY for fallback) :

* Manually checkout stable git locally : ```hmrepogit```
* Go to local folder : ```hmrepogitcd```

### Install to local commands

* List all locally installed chart : ```hmls```
* Describe Chart from repo : ```hmdesc "CHART_FULLNAME"```
* Fully describe Chart from repo : ```hmdescall "CHART_FULLNAME"```
* Install and allow to override config using YAML file : ```hminst "CHART" "[NAME]" "[NAMESPACE]" "[CUSTOM_CONFIG_FILE]"```
* Upgrade existing chart instance : ```hmupg ""CHART"" "NAME"```
* Rollback existing chart instance : ```hmrollback "NAME"```
* Remove existing chart instance (v2 ONLY) : ```hmrm "NAME"```
* Remove existing chart instance (v3 ONLY) : ```hmuninst "NAME"```
* List all helm dependencies : ```hmdep```
* Refresh all helm dependencies : ```hmdepupd```

### Manage helm plugin

* cd to **helm plugin folder** : ```hmplugin```
* List all helm plugins : ```hmpluginls```
* Install helm plugin : ```hmplugininst "PACKAGE_LOCATION_OR_URL"```

### K8S service commands

* Init Helm (Initialize tiller-deploy) : ```hminit```
* Helm initialize service-account tiller : ```hmsrvinit "[SERVICE_ACCOUNT:tiller]"```
* Upgrade service-account tiller : ```hmsrvupg "[SERVICE_ACCOUNT:tiller]"```
* Get Helm K8s deployment info (tiller-deploy) : ```hmsrvinfo "[NAMESPACE:kube-system]"```
* Delete Helm K8s deployment (tiller-deploy) : ```hmsrvrm```

### Create your own chart

* Create chart template folder : ```hmcreate "CHART_FOLDER"```
* Generate chart : ```hmgen "CHART_FOLDER"```
* Package chart : ```hmpkg "CHART_FOLDER"```
* Get history : ```hmhistory "CHART_FOLDER"```

### Common installation

bitnami :

* Add repo bitnami : ```hmrepobitnami```
* Search repo bitnami : ```hmsearchbitnami```

Chart Museum :

* Install Chart Museum : ```hminstchartmuseum```


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
