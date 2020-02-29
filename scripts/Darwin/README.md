# Commands

## Install

* Install node using **nvm** : ```inst_nvm "[VERSION]"```
* Install node & grunt-cli (OLD) : ```inst_node```

Also enable [lib-dev-node](../../libs#library-dev-node)

## Vagrant

### Vagrant images

* cd vagrant box images folder : ```cdvagb```
* list all vagrant box images : ```vagbls```
* Install vagrant box image using BOX\_NAME using local file or download (with cache) : ```vagbadd "BOX_NAME" "[BOX_FILENAME]" "[BOX_URL]"```
* Shortcut install common images : ```vagbadd_*```
* Delete box image : ```vagbrm```

### Administrate instances

* cd local vagrant instance folder : ```cdvag```
* list local vagrant instance folder : ```vagls```
* Install vbguest into local instance : ```vaginst_vbguest```
* Remotely install [bash-fwk](https://github.com/frtu/bash-fwk) into local instance : ```vaginst_fwk``` or ```vagfwkinst``` 
* Mount host folder into guest instance : ```vagfwkmount```

### Interacting with instance

Basic commands to run in Vagrant folder :

* Start local instance : ```vagstart```
* Stop local instance : ```vagstop```
* SSH into local instance : ```vagssh```
* Relaunch provision : ```vagprovision ```
* Remove local instance : ```vagrm```

Import/Export commands :

* Export a Vagrant image **into a box file** : ```vagexport "[BOX_NAME]" "[BOX_FILENAME]"```
* Export **private_key** from a Vagrant image  : ```vagexportkeyvbox```
* Import **private_key** into local Vagrant image  : ```vagimportkeyvbox```
