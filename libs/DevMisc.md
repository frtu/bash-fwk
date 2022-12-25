# Guidelines

* [Install and use specific version of Node](InstallNode.md)


# Tech libraries

## Library 'dev-nvm'

* Usage ```import lib-dev-nvm```
* Prefix ```nvm```

### Base commands

* Get **nvm** version : ```nvmv```
* List all local installed version : ```nvmls```
* Get current version : ```nvmcurrent```
* Use a specific version : ```nvmuse "VERSION"```
* Where is cmd version : ```nvmwhich "VERSION"```

### Install commands

* List all remote version : ```nvmlsremote```
* Install a specific version : ```nvminst "[VERSION:v10.13.0]"```
* Uninstall a specific version : ```nvmuninst "VERSION"```

### Configuration commands

* Set http proxy to reach out repository : ```njconfsetproxy "PROXY_URL"```
* Set https proxy to reach out repository : ```njconfsetproxysecured "HTTPS_PROXY_URL"```
* Remove proxy settings : ```njconfcleanproxies```
* Set log level : ```njconfsetlog "LOG_LEVEL:warn"```

Generic configuration settings

* List all configurations : ```njconfls```
* Set configuration : ```njconfset "CONF_PARAM_NAME" "CONF_PARAM_VALUE"```
* Remove configuration : ```njconfrm "CONF_PARAM_NAME"```


### Repository commands

* Print the current **remote repository** URL : ```njconfrepo```
* Set **remote repository** URL : ```njconfsetrepo "REPO_URL"```
* Search for package in **remote repository** : ```njrepols "PKG_NAME"```
* Clean up cache : ```njclean```


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

### Install

* Install conda : ```inst_conda```
* Update conda : ```upd_conda```

Other optional installation :

* Install `python` (Optional should already come with `conda`) : `inst_python`
* Install `protobuf` : `inst_protobuf`
* Install `cmake` : `inst_cmake`

### Admin commands

* Get **python** & **conda** version : ```pc```
* Init conda env : ```pcinit```
* Upgrade Conda : ```pcugd```
* Create isolated environment : ```pccreate "ENV_NAME"```
* Create environment based on file `environment.yaml` : ```pcenvcreate "[FILE_NAME]" "[ENV_NAME]"```
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
