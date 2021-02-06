# Dev Backend lib

## Library 'dev-kotlin'

* Usage ```import lib-dev-kotlin```
* Prefix ```kt```

### Base commands

* Get **kotlin** version : ```kt```
* Compile a kotlin file .kt : ```ktc "KOTLIN_FILE_NAME"```
* Create a JAR from kotlin file .kt : ```ktjar "KOTLIN_FILE_NAME"```
* Create a JAR standalone with kotlin runtime : ```ktjarstandalone "KOTLIN_FILE_NAME"```
* Run kotlin in REPL (read, evaluate, print, loop) with optional classpath : ```ktrepl "[KOTLIN_JAR_FILE]"```

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

* Enable Maven Archetype generator library with the [dedicated version](https://search.maven.org/search?q=g:com.github.frtu.archetype) : ```enablemvngen "ARCHETYPE_VERSION" "[DEFAULT_GID]"```

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
* When Actuator enable for spring-boot & logger enable **GET** logger configuration : ```splog "LOGGER_NAME" "[BASE_URL]"```
* When Actuator enable for spring-boot & logger enable **SET** logger configuration : ```splogset "LOGGER_NAME" "LEVEL:TRACE|DEBUG|INFO|WARN|ERROR" "[BASE_URL]"```
