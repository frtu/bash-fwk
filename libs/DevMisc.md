# Misc dev lib

## Library 'dev-nvm'

* Usage ```import lib-dev-nvm```
* Prefix ```nvm```

### Base commands

* Get **nvm** version : ```nvmv```
* List all local installed version : ```nvmls```
* Get current version : ```nvmcurrent```
* Use a specific version : ```nvmuse "VERSION"```
* Where is cmd version : ```nvmwhich "VERSION"```

### Iinstall commands

* List all remote version : ```nvmlsremote```
* Install a specific version : ```nvminst "[VERSION:v10.13.0]"```
* Uninstall a specific version : ```nvmuninst "VERSION"```

## Library 'dev-node'

* Usage ```import lib-dev-node```
* Prefix ```nj```

### Base commands

* Get **node** & **npm** version : ```nj```
* Install & start : ```njinststart```
* Build : ```njbuild```
* Build & deploy as server : ```njbuildNdeploy```

## Library 'dev-py-conda'

* Usage ```import lib-dev-py-conda```
* Prefix ```pc```

### Admin commands

* Get **python** & **conda** version : ```pc```
* Upgrade Conda : ```pcugd```
* Create isolated environment : ```pcenvcreate "ENV_NAME"```
* Use isolated environment : ```pcenv "ENV_NAME"```
* Deactivate isolated environment : ```pcenvdeactivate```

### Base commands

* Update metadata : ```pcupd```
* Install package : ```pcinst "PACKAGE"```
* Add repo : ```pcrepo "CHANNEL_NAME"```
* Add repo (*conda-forge*) : ```pcrepoforge```
* Install package from (*conda-forge*) : ```pcinstforge "PACKAGE"```

## Library 'dev-py-pip'

* Usage ```import lib-dev-pip```
* Prefix ```pp```

### Base commands

* Install package with pip (if requirements.txt exist, use it if no arg passed)  : ```ppinst "[PACKAGE]"```
* Install mtcnn : ```ppinst_mtcnn```
