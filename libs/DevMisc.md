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

### Repo commands

* Search repo for package : ```njrepols "PKG_NAME"```
* Set Repo URL : ```njconfsetrepo "REPO_URL"```
* List all repo : ```njconfrepo```
* Clean repo : ```njclean```
* Npm audit repo & fix : ```njauditfix ```
* Create lock file : ```njlock ```

### Configuration

* List configs : ````njconfls```
* Set configs : ```njconfset "CONF_PARAM_NAME" "CONF_PARAM_VALUE"```
* Remove config : ```njconfrm "CONF_PARAM_NAME"```
* Set HTTP proxy : ```njconfsetproxy "PROXY_URL"```
* Set HTTPS proxy : ```njconfsetproxysecured "HTTPS_PROXY_URL"```
* Remove proxies : ```njconfcleanproxies```
* Set log level : ```njconfsetlog "LOG_LEVEL:warn"```


## Library 'js-rush'

* Usage ```import lib-js-rush```
* Prefix ```rh```
* Install ```inst_rush```

### Base commands

* Get **rush** version : ```rh```
* [Install all pck dep](https://rushjs.io/pages/commands/rush_install/) - READ ONLY : ```rhinst```
* [Run update](https://rushjs.io/pages/commands/rush_update/) whenever you start working in a Rush repo, after you pull from Git, and after you modify a package.json file : ```rhupd```
* [Build](https://rushjs.io/pages/commands/rush_build/) : ```rhbuild```
* Build current project & dependencies : ```rhbuildfull```
* [Invokes a shell script](https://rushjs.io/pages/commands/rushx/) that is defined in the "scripts" : ```rhx [SCRIPT_NAME]```

## Library 'dev-py-conda'

* Usage ```import lib-dev-py-conda```
* Prefix ```pc```
* For M1, run ```pcarchm1```

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
* Upgrade based on conda-forge : ```pcugdbase```
* Configure for M1 : ```pcconfm1```
* Adding configuration : ```pcconf "CONF_NAME" "CONF_VALUE"```

### Create isolated env

* List all isolated environments : ```pcenv```
* Use isolated environment : ```pcenv "ENV_NAME"```
* Create isolated environment : ```pcenvcreate "ENV_NAME"```
* Create environment based on file `environment.yaml` : ```pcenvcreatefile "[FILE_NAME]" "[ENV_NAME]"```
* Remove isolated environment : ```pcenvrm "ENV_NAME"```
* Deactivate isolated environment : ```pcenvdeactivate```

### Base commands

* Update metadata : ```pcupd```
* Install package : ```pcinst "PACKAGE"```
* Add repo : ```pcrepo "CHANNEL_NAME"```
* Add repo (*huggingface*) : ```pcrepohuggingface```
* Add repo (*conda-forge*) : ```pcrepoforge```
* Install package from (*conda-forge*) : ```pcinstforge "PACKAGE"```
* Clean up repo : ```pcrepoclean```

## Library 'dev-py-pip'

* Usage ```import lib-dev-pip```
* Prefix ```pp```
* For M1, run ```pparchm1```

### Base commands

* Install package with pip (if requirements.txt exist, use it if no arg passed)  : ```ppinst "[PACKAGE]" "[VERSION]"```
* Install package without using cache  : ```ppuninstnocache "[PACKAGE]" "[VERSION]"```
* Uninstall : ```ppuninst "[PACKAGE]"```
* Clean up repo : ```pprepoclean```

### Installs

* Install mtcnn : ```ppinst_mtcnn```
* Install tensorflow : ```ppinst_tensorflow```

## Library 'dev-rust'

* Usage ```import lib-dev-rust```
* Prefix ```rt```

### Install

* Install rust : ```inst_rust```
* Uninstall rust : ```uninst_rust```
* Update rust : ```rtupd```

### Base commands

* Get **rust** version : ```rt```
* Install rust specific version : ```rtinst "VERSION"```
* Add a package : ```rtadd "PACKAGE"```
* List rust toolchain : ```rttool```
* Set rust toolchain : ```rttoolset "TOOLCHAIN"```
