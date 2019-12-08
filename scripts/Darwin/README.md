# Commands

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
* Remotely install [bash-fwk](https://github.com/frtu/bash-fwk) into local instance : ```vaginst_fwk ```

### Interacting with instance

Basic commands :

* Start local instance : ```vagstart```
* Stop local instance : ```vagstop```
* SSH into local instance : ```vagssh```
* Remove local instance : ```vagrm```

Import/Export commands :

* Export a Vagrant image **into a box file** : ```vagexport "[BOX_NAME]" "[BOX_FILENAME]"```
* Export **private_key** from a Vagrant image  : ```vagexportkeyvbox```
* Import **private_key** into local Vagrant image  : ```vagimportkeyvbox```
