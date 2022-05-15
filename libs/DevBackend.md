# Dev Backend lib


## Library 'git'

* Usage ```import lib-git```
* Install ```enablelib git```

### Base commands

* List all branches : ```gbrls```
* Checkout a branch : ```gbr "BRANCH_OR_TAG_NAME"```
* Checkout a branch (stash and pop) : ```gbrsp "BRANCH_OR_TAG_NAME"```
* Remove a branch and checkout to another one : ```gbrrm "BRANCH_NAME" "[FALLBACK_BRANCH_AFTER_DELETE:master]"```

### Remote

* Rebase local branch with remote : ```grebaseremote "BRANCH_NAME" "[REMOTE_REPO_NAME:origin]"```


## Library 'inst-sdk'

* Usage ```import lib-inst-sdk```
* Install ```enablelib inst-sdk```

### Base commands

* Install SDKMAN : ```inst_sdk```
* Load sdk cmd line : ```sdkload```
* Print sdk version : ```sdkv```
* Update sdk : ```sdkupd```

### Installation

* List all packages : ```sdkls "[PACKAGE]"```
* Use maven to exec a class : ```sdkinst "PACKAGE" "[VERSION]" "[PATH_TO_INSTALLATION]"```

Install packages :

* Install Java : ```instjava```
* Install Scala : ```instscala```
* Install Kotlin : ```instkotlin```
* Install Kotlin script : ```instkscript```
* Install VisualVM : ```instvisualvm```
* Install Gradle : ```instgradle```
* Install sbt : ```instsbt```

## Library 'dev-rust'

* Usage ```import lib-dev-rust ```
* Prefix ```rt```

### Install commands

* Install rust : ```inst_rust```
* Uninstall rust : ```uninst_rust```
* Install specific rust version : ```rtinst "VERSION"```
* Update rust : ```rtupd```
* Get **rust** version : ```rt```
* Add install component : ```rtadd "PACKAGE"```

### Base commands

* Build **version** : ```rtc```
* **Build** project : ```rtcbuild```
* **Install** project : ```rtcinstall "PACKAGE"```
* **Run** project : ```rtcrun```
* **Test** project : ```rtctest```
* **Benchmark** project : ```rtcbench```
* **Lint** project code : ```rtclint ```
* **Format** project code : ```rtcformat ```
* Build project **doc** : ```rtcdoc```


## Library 'dev-java'

* Usage ```import lib-dev-java ```
* Prefix ```j```

### Base commands

* Get **jdk** version : ```jv```
* List all available jdks : ```jls```
* Set jdk : ```jset "JDK_PATH"``` or ```jset8```
* Add current jdk into PATH : ```jdkbin```

### Keystore commands

* List all the keys in the current JDK path : ```jkeyls "[JKS_FILENAME]" "[PASSWORD]"```
* List import one cert to the keystore of current jdk : ```jkeyimport "JKS_FILENAME" "[JKS_NAME]" "[PASSWORD]"```

### Admin commands

* Going to all JDK folders : ```jcd```
* To make a JDK (un)available to be picked up : ```jdeactivate "JDK_PATH"``` or ```jactivate "JDK_PATH"```

## Library 'dev-kotlin'

* Usage ```import lib-dev-kotlin```
* Prefix ```kt```

### Base commands

* Get **kotlin** version : ```kt```
* Compile a kotlin file .kt : ```ktc "KOTLIN_FILE_NAME"```
* Create a JAR from kotlin file .kt : ```ktjar "KOTLIN_FILE_NAME"```
* Create a JAR standalone with kotlin runtime : ```ktjarstandalone "KOTLIN_FILE_NAME"```
* Run kotlin in REPL (read, evaluate, print, loop) with optional classpath : ```ktrepl "[KOTLIN_JAR_FILE]"```

## Library 'dev-gradle'

* Usage ```import lib-dev-gradle```
* Prefix ```gd```
* Install Gradle : ```instgradle```

### Base commands

* Get **gradle** version : ```gd```
* list all **tasks** : ```gdls```
* **init** project : ```gdi```
* **build** project : ```gdb```
* **clean & build** project : ```gdbclean```
* **build verbose** project : ```gdbverbose```
* **test** project : ```gdt```
* Run **java class** project : ```gdmain "CLASS_NAME"```

### Package management

* Use gradle wrapper : ```gdwrapper```
* Set gradle wrapper **version** : ```gdwrapperset "[VERSION:7.4.2]"```

### Package management

* Get gradle **dependencies** : ```gddep```
* Get dependencies for **compile**, **test**, : ```gddep*```
* Generate **text report** (```./build/reports/project/dependencies.txt```) : ```gdreport```
* Generate **html report** : ```gdreporthtml```
* Check updates : ```gddepchk```

## Library 'dev-maven'

* Usage ```import lib-dev-maven```

### Base commands

* Run maven with skiping test: ```mvnsk "CMD"```
* Generate javadoc : ```mvndoc```
* Display the whole dependency tree : ```mvndep```
* Download the source from Jar : ```mvnsrc```
* Use maven to exec a class : ```mvnexec "CLASSNAME"```

### Repository commands

* Clean up **local repository** from metadata reference : ```mvnrepoclean```
* Import JAR file into **local repository** (```FILE_PATH``` default value is ```ARTIFACT_ID-ARTIFACT_VERSION.jar```) : ```mvnjarimport "GROUP_ID" "ARTIFACT_ID" "ARTIFACT_VERSION" "[FILE_PATH]"```
* Deploy JAR file into **remote repository** (from ```ARTIFACT_ID-ARTIFACT_VERSION.jar``` or local repository ```~/.m2```) : ```mvnjardeploy "GROUP_ID" "ARTIFACT_ID" "ARTIFACT_VERSION" "REPO_SETTINGS_ID" "[FILE_PATH]" "[REPO_URL]"```

## Library 'dev-maven-archetype'

### Install

* Enable Maven Archetype generator library with the [dedicated version](https://search.maven.org/search?q=g:com.github.frtu.archetype) : ```enablemvngen "ARCHETYPE_VERSION" "DEFAULT_GID"```

### Usage

Allow to generate all kinds of projects :

* Base project with parent pom : ```mvngen base "AID" "GID" "[VERSION:0.0.1-SNAPSHOT]"```
* Kotlin project with parent pom : ```mvngen kotlin "AID" "GID" "[VERSION:0.0.1-SNAPSHOT]"```

For Stream Processing : 

* Kafka Publisher with parent pom : ```mvngen plt-kafka "AID" "GID" "[VERSION:0.0.1-SNAPSHOT]"```
* Spark Consumer with parent pom : ```mvngen plt-spark "AID" "GID" "[VERSION:0.0.1-SNAPSHOT]"```
* Simple Avro Data model project : ```mvngen avro "AID" "GID" "[VERSION:0.0.1-SNAPSHOT]"```

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

## Library 'dev-spring'

* Install ```enablesp```
* Usage ```import lib-dev-spring ```
* Prefix ```sp```

### Base commands

* Run Spring-boot application : ```sprun```

### Log level commands

* When Actuator enable for spring-boot & logger enable **GET** logger configuration : ```splog "LOGGER_NAME" "[BASE_URL]"```
* When Actuator enable for spring-boot & logger enable **SET** logger configuration : ```splogset "LOGGER_NAME" "LEVEL:TRACE|DEBUG|INFO|WARN|ERROR" "[BASE_URL]"```

## Library 'jmeter'

* Usage ```import lib-jmeter```
* Prefix ```jm```

### Install

* Enable jmeter : ```enablelib jmeter```
* Install : ```inst_jmeter```

### Usage

* Launch JMeter GUI mode (for creation, debugging & reading logs) : ``jm``
* Launch JMeter CLI mode / headless : ``jmcli "JMX_FILE" "[LOG_FILE:result.jtl]"``
* Launch JMeter CLI mode / headless with extended memory : ``jmcliext "JMX_FILE" "[LOG_FILE:result.jtl]" "[MEM:512m]"``
