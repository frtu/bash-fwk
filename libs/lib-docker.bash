import lib-vm

export DOCKER_CONFIG_FILE=~/.docker/config.json
export DOCKER_DAEMON_FILE=/etc/docker/daemon.json

dck() {
  docker version
  docker info
}
dckconf() {
  cat ${DOCKER_CONFIG_FILE}
}
dckconfvi() {
  vi ${DOCKER_CONFIG_FILE}
}

dckls() {
  usage $# "[CONTAINING_TEXT]"

  local CONTAINING_TEXT=$1
  if [ -z "$CONTAINING_TEXT" ]; then
      echo "List all existing docker images"
      docker images
    else
      echo "List all existing docker images containing ${CONTAINING_TEXT}"
      docker images | grep ${CONTAINING_TEXT}
  fi
}
dckimgdigest() {
  usage $# "[CONTAINING_TEXT]"

  local CONTAINING_TEXT=$1
  if [ -z "$CONTAINING_TEXT" ]; then
      echo "List all existing docker image digests"
      docker images --digests
    else
      echo "List all existing docker image digest containing ${CONTAINING_TEXT}"
      docker images --digests | grep ${CONTAINING_TEXT}
  fi
}
dckpullsk() {
  usage $# "IMAGE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local IMAGE_NAME=$1
  dckpull ${IMAGE_NAME} "–disable-content-trust"
}
dckpull() {
  usage $# "IMAGE_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "docker pull $@"
  docker pull $@
}
dcksearch() {
  usage $# "IMAGE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  dcktpl "search" $@
}

# See running
dckps() {
  usage $# "[CONTAINING_TEXT]"

  local CONTAINING_TEXT=$1
  if [ -z "$CONTAINING_TEXT" ]; then
      echo "List all docker instances"
      docker ps -a
    else
      echo "List all docker instances containing ${CONTAINING_TEXT}"
      docker ps -a | grep ${CONTAINING_TEXT}
  fi
}
dckstart() {
  dcktpl "start" $@
}
dckstartall() {
  dckstart $(docker ps -aq)
}
dcklogstail() {
  dcklogs $@ "--follow"
}
dcklogs() {
  dcktpl "logs" $@
}
dckstop() {
  dcktpl "stop" $@
}
dckstopall() {
  dckstop $(docker ps -aq)
}
dckdescstatus() {
  usage $# "INSTANCE_NAME" "[EXTRA_PARAMS]"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  dckdesc  -f '{{.State.Running}}' $@
}
dckdescip() {
  usage $# "INSTANCE_NAME" "[EXTRA_PARAMS]"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  dckdesc  -f '{{.NetworkSettings.IPAddress}}' $@
}
dckdescport() {
  usage $# "INSTANCE_NAME" "[EXTRA_PARAMS]"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "docker inspect -f '{{range \$key, \$value := .NetworkSettings.Ports}}{{\$key}} -> {{\$value}} {{end}}' $@"
  docker inspect -f '{{range $key, $value := .NetworkSettings.Ports}}{{$key}} -> {{$value}} {{end}}' $@
}
# List all networks a container belongs to
dckdescnet() {
  usage $# "INSTANCE_NAME" "[EXTRA_PARAMS]"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "docker inspect -f '{{range \$key, \$value := .NetworkSettings.Networks}}{{\$key}} {{end}}' $@"
  docker inspect -f '{{range $key, $value := .NetworkSettings.Networks}}{{$key}} -> IPAddress:{{$value.IPAddress}} Gateway:{{$value.Gateway}} {{end}}' $@
}
alias dckinfo=dckdesc
alias dckinspect=dckdesc
dckdesc() {
  dcktpl "inspect" $@
}
dcktop() {
  dcktpl "top" $@
}
dcktpl() {
  if [ -z "$2" ]; then
    echo "Please supply argument(s) \"INSTANCE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    dckps
    return 1
  fi
  echo "docker $@"
  docker $@
}
dckrm() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Please supply argument(s) \"INSTANCE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    return 1
  fi
  docker stop $@
  docker rm -f $@
  dckps
}

# Interaction
dckcp() {
  usage $# "SOURCE" "DESTINATION"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "(Prefix the image location with \"IMAGE_NAME:/tmp\"). If you don't know any names run 'dckps' and look at the last column NAMES" >&2
     dckps
     return 1
   fi
  local SOURCE=$1
  local DESTINATION=$2

  echo "Copy from/to docker images : ${SOURCE} => ${DESTINATION}"
  docker cp ${SOURCE} ${DESTINATION}
}

# Shell into an existing INSTANCE_NAME
dcksh() {
  usage $# "INSTANCE_NAME" "[COMMANDS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    dckps
    return 1
  fi

  dckbashtpl "sh" $@
}
dckbash() {
  usage $# "INSTANCE_NAME" "[COMMANDS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    dckps
    return 1
  fi

  dckbashtpl "bash" $@
}
dckbashtpl() {
  usage $# "BASH_CMD" "INSTANCE_NAME" "[COMMANDS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    if [[ "$#" > "0" ]]
      then 
        echo "If you don't know any names run 'dckps' and look at the last column NAMES" >&2
        dckps
    fi
    return 1
  fi

  local BASH_CMD=$1
  local INSTANCE_NAME=$2

  # run in LOGIN MODE : https://github.com/rbenv/rbenv/wiki/Unix-shell-initialization#bash
  if [ -z "$3" ]
    then
      echo "docker container exec -it ${INSTANCE_NAME} ${BASH_CMD} -l"
      docker container exec -it ${INSTANCE_NAME} ${BASH_CMD} -l
    else
      local COMMANDS=${@:3}
      echo "echo \"${COMMANDS}\" | docker container exec -i ${INSTANCE_NAME} ${BASH_CMD} -l"
      echo "${COMMANDS}" | docker container exec -i ${INSTANCE_NAME} ${BASH_CMD} -l
  fi
}
# Shell into an existing IMAGE_NAME
dckimagesh() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckls' and look at the last column NAMES" >&2
    dckls
    return 1
  fi

  dckimagebashtpl "sh" $@
}
dckimagebash() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckls' and look at the last column NAMES" >&2
    dckls
    return 1
  fi

  dckimagebashtpl "bash" $@
}
dckimagebashtpl() {
  usage $# "BASH_CMD" "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    if [[ "$#" > "0" ]]
      then 
        echo "If you don't know any names run 'dckls' and look at the last column NAMES" >&2
        dckls
    fi
    return 1
  fi

  local BASH_CMD=$1
  local IMAGE_NAME=$2

  echo "Login into a Bash docker images : ${IMAGE_NAME}"
  docker container run --rm -ti --entrypoint ${BASH_CMD} ${IMAGE_NAME}
}

# https://docs.docker.com/network/proxy/

dckexport() {
  usage $# "IMAGE_NAME:TAG_NAME" "[FILENAME_TAR]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckls' and look at the 2 columns REPOSITORY:TAG" >&2
    dckls
    return 1
  fi

  local DCK_IMAGE_NAME=$1

  # https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
  DCK_IMAGE_ID=${DCK_IMAGE_NAME//\//_}
  DCK_IMAGE_ID=${DCK_IMAGE_ID//\:/-}
  local FILENAME_TAR=$VM_ARCHIVE_FOLDER/docker_${2:-$DCK_IMAGE_ID}.tar.gz

  mkdir -p $VM_ARCHIVE_FOLDER/

  echo "docker save ${DCK_IMAGE_NAME} | gzip > $FILENAME_TAR"
  docker save ${DCK_IMAGE_NAME} | gzip > $FILENAME_TAR
}
dckimportfolder() {
  usage $# "DOCKER_IMAGE_FILE_FILTER" "[FOLDER_PATH]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local DOCKER_IMAGE_FILE_FILTER=$1
  local FOLDER_PATH=${2:-$VM_ARCHIVE_FOLDER}
  
  DCK_IMAGE_PATHS="$FOLDER_PATH/docker_*$DOCKER_IMAGE_FILE_FILTER*"
  echo "------- Loading ${DCK_IMAGE_PATHS} --------";
  for i in ${DCK_IMAGE_PATHS};
  do 
    echo "docker load -i $i"
    docker load -i $i
  done

  STATUS=$?
  if [ "$STATUS" -eq 0 ]
    then
      echo "Import image successfully"
      dckls
    else
      echo "== An error has happen. Please check if an existing instance has a conflict using cmd 'dckps'. Error code=$STATUS  ==" >&2
  fi
}
dckimport() {
  usage $# "DCK_IMAGE_FILENAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local DCK_IMAGE_FILENAME=$1
  # If the local file doesn't exist
  if [ ! -f ${DCK_IMAGE_FILENAME} ]; then
    # Add folder VM_ARCHIVE_FOLDER
    DCK_IMAGE_FILENAME=${VM_ARCHIVE_FOLDER}/$1
  fi
  if [ ! -f ${DCK_IMAGE_FILENAME} ]; then
    DCK_IMAGE_FILENAME="${VM_ARCHIVE_FOLDER}/docker_$1.tar.gz"
  fi

  if [ ! -f ${DCK_IMAGE_FILENAME} ]; then
    echo "Cannot find file '$1' or '${DCK_IMAGE_FILENAME}'" >&2
    return 1
  fi

  echo "docker load -i ${DCK_IMAGE_FILENAME}"
  docker load -i ${DCK_IMAGE_FILENAME}

  STATUS=$?
  if [ "$STATUS" -eq 0 ]
    then
      echo "Import image successfully"
      dckls
    else
      echo "== An error has happen. Please check if an existing instance has a conflict using cmd 'dckps'. Error code=$STATUS  =="
  fi
}
# https://appfleet.com/blog/how-to-transfer-move-a-docker-image-to-another-system/
dckexportcontainer() {
  usage $# "CONTAINER_NAME" "[FILENAME_TAR]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckps' and look at NAMES" >&2
    dckps
    return 1
  fi

  local CONTAINER_NAME=$1

  # https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
  DCK_IMAGE_ID=${CONTAINER_NAME//\//_}
  DCK_IMAGE_ID=${DCK_IMAGE_ID//\:/-}
  local FILENAME_TAR=$VM_ARCHIVE_FOLDER/docker_inst_${2:-$DCK_IMAGE_ID}.tar.gz

  mkdir -p $VM_ARCHIVE_FOLDER/

  echo "docker export -o "${FILENAME_TAR}" ${DCK_IMAGE_NAME}"
  docker export -o "${FILENAME_TAR}" ${DCK_IMAGE_NAME}
}
dckimportcontainer() {
  usage $# "CONTAINER_NAME" "[CONTAINER_NAME_PATH]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CONTAINER_NAME=$1
  local CONTAINER_NAME_PATH=${2:-docker_inst_$CONTAINER_NAME.tar.gz}

  # If the local file doesn't exist
  if [ ! -f ${CONTAINER_NAME_PATH} ]; then
    # Add folder VM_ARCHIVE_FOLDER
    CONTAINER_NAME_PATH=${VM_ARCHIVE_FOLDER}/${CONTAINER_NAME_PATH}
  fi

  if [ ! -f ${CONTAINER_NAME_PATH} ]; then
    echo "Cannot find file '${CONTAINER_NAME_PATH}'" >&2
    return 1
  fi

  echo "tar -c ${CONTAINER_NAME_PATH} | docker import - ${CONTAINER_NAME}"
  tar -c ${CONTAINER_NAME_PATH} | docker import - ${CONTAINER_NAME}

  STATUS=$?
  if [ "$STATUS" -eq 0 ]
    then
      echo "Import image successfully"
      dckps
    else
      echo "== An error has happen. Please check if an existing instance has a conflict using cmd 'dckps'. Error code=$STATUS  =="
  fi
}

# Starting & administration
dckregmirror() {
  usage $# "DOCKER_REGISTRY_DOMAIN_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local DOCKER_REGISTRY_DOMAIN_NAME=$1

  echo "Setting locally the Docker proxy $1 in ~/scripts/service_docker_proxy.bash"
  echo "ATTENTION : Doesn't work for boot2docker !! Use dckmregistryinsecure() or dckmregistry() INSTEAD !"
  
  echo 'export DOCKER_OPTS=" --registry-mirror 'https://${DOCKER_REGISTRY_DOMAIN_NAME}' --insecure-registry 'http://${DOCKER_REGISTRY_DOMAIN_NAME}'"' > $LOCAL_SCRIPTS_FOLDER/env-docker-proxy.bash
}
dckregconf() {
  cat ${DOCKER_DAEMON_FILE}
}
dckregconfrm() {
  rm ${DOCKER_DAEMON_FILE}
}
dckregconfpersist() {
  usage $# "[DOCKER_REGISTRY_DOMAIN_NAME:docker-registry:5000]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local DOCKER_REGISTRY_DOMAIN_NAME=${1:-docker-registry:5000}

  echo "{ \"insecure-registries\": [\"$DOCKER_REGISTRY_DOMAIN_NAME\"] }"
  echo "{ \"insecure-registries\": [\"$DOCKER_REGISTRY_DOMAIN_NAME\"] }" >> $DOCKER_DAEMON_FILE
}
dckregtagpush() {
  usage $# "IMAGE_NAME:TAG_NAME" "[DOCKER_REGISTRY_URL:myregistry-127-0-0-1.nip.io:5000]"
  dckregtag $@
  dckregpush $@
}
dckregtag() {
  usage $# "IMAGE_NAME:TAG_NAME" "[DOCKER_REGISTRY_URL:myregistry-127-0-0-1.nip.io:5000]"
  
  local DCK_IMAGE_NAME=$1
  dckregtpl "tag $DCK_IMAGE_NAME" $@
}
dckregpush() {
  usage $# "IMAGE_NAME:TAG_NAME" "[DOCKER_REGISTRY_URL:myregistry-127-0-0-1.nip.io:5000]"
  dckregtpl "push" $@
}

dckregtpl() {
  usage $# "CMD" "IMAGE_NAME:TAG_NAME" "[DOCKER_REGISTRY_URL:myregistry-127-0-0-1.nip.io:5000]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckls' and look at the 2 columns REPOSITORY:TAG" >&2
    dckls
    return 1
  fi

  local CMD=$1
  local FULL_IMAGE_NAME=$2
  
  if [[ ! $FULL_IMAGE_NAME == *\/* ]]; then
    local DCK_IMAGE_NAME=$2
    local DOCKER_REGISTRY_URL=${3:-myregistry-127-0-0-1.nip.io:5000}
    local FULL_IMAGE_NAME=$DOCKER_REGISTRY_URL/$DCK_IMAGE_NAME
  fi  

  echo "docker ${CMD} ${FULL_IMAGE_NAME}"
  docker ${CMD} ${FULL_IMAGE_NAME}
}

# https://docs.docker.com/engine/userguide/networking/
dcknetls() {
  echo "docker network ls"
  docker network ls
}
dcknetlsfull() {
  dcknetls
  echo "== Inspect bridge ==" 
  dcknetdesc bridge
  echo "== Inspect host ==" 
  dcknetdesc host
}
# https://docs.docker.com/network/network-tutorial-standalone/#use-user-defined-bridge-networks
dcknetcreate() {
  usage $# "NETWORK_NAME"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  dcknettpl "create --driver bridge " $@
  dcknetls
}
# https://docs.docker.com/engine/reference/commandline/network_rm/
dcknetrm() {
  dcknettpl "rm" $@
  dcknetls
}

dcknetconnect() {
  usage $# "CONTAINER_NAME" "[NETWORK_NAME:bridge]"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CONTAINER_NAME=$1
  local NETWORK_NAME=${2:-bridge}

  dcknettpl "connect" ${NETWORK_NAME} ${CONTAINER_NAME}
}
# https://maximorlov.com/4-reasons-why-your-docker-containers-cant-talk-to-each-other/
dcknetconnectedls() {
  usage $# "NETWORK_NAME:bridge"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local NETWORK_NAME=$1

  echo "docker network \"inspect\" ${NETWORK_NAME} -f \"{{range .Containers}}{{.Name}} {{end}}\""
  docker network "inspect" ${NETWORK_NAME} -f "{{range .Containers}}{{.Name}} {{end}}"
}
alias dcknetinfo=dcknetdesc
alias dcknetinspect=dcknetdesc
dcknetdesc() {
  dcknettpl "inspect" $@
}
dcknettpl() {
  usage $# "CMD" "NETWORK_NAME_OR_IDs" "[EXTRA_PARAMS]"
  # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then 
    echo "Please supply argument(s) \"NETWORK_NAME_OR_IDs\". If you don't know any names run 'dcknetls' and look at the last column NAMES" >&2
    dcknetls
    return 1
  fi

  echo "docker network $@"
  docker network $@
}
## https://docker-tutorial.schoolofdevops.com/troubleshooting-toolkit/
# Debug network issue using another docker image
dcknetdebug() {
  usage $# "CONTAINER_NAME" "[DEBUG_IMAGE_NAME:nicolaka/netshoot]" "[ADDITIONAL_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local CONTAINER_NAME=$1
  local DEBUG_IMAGE_NAME=${2:-nicolaka/netshoot}
  local ADDITIONAL_PARAMS=${@:3}

  echo "* nsenter —net=<net-namespace>"
  echo "* tcpdump -nnvvXXS -i <interface> port <port>"
  echo "* iptables -nvL -t <table>"
  echo "* ipvsadm -L"
  echo "* ip <commands>"
  echo "* bridge <commands>"
  echo "* drill"
  echo "* netstat -tulpn"
  echo "* iperf <commands>"

  echo "docker container run -it --rm --net container:${CONTAINER_NAME} --privileged ${DEBUG_IMAGE_NAME} ${ADDITIONAL_PARAMS}"
  docker container run -it --rm --net container:${CONTAINER_NAME} --privileged ${DEBUG_IMAGE_NAME} ${ADDITIONAL_PARAMS}
}

dcknethosts() {
  cat /etc/hosts
}

dckhello() {
  echo "Testing if docker works?"
  docker container run --rm hello-world
}

dckcreate() {
  usage $# "IMAGE_NAME" "INSTANCE_NAME" "[MORE_ARG]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any image run 'dckls' and look at the column REPOSITORY" >&2 
    dckls 
    return 1
  fi

  local IMAGE_NAME=$1
  local INSTANCE_NAME=$2
  local MORE_ARG=${@:3}

  echo "docker run --name ${INSTANCE_NAME} ${MORE_ARG} -ti ${IMAGE_NAME}"

  echo "=> NEXT TIME USE > dckstart ${INSTANCE_NAME}"
  docker run --name ${INSTANCE_NAME} ${MORE_ARG} -ti ${IMAGE_NAME}
}
dckrundaemon() {
  usage $# "IMAGE_NAME" "[INSTANCE_NAME]" "[MORE_ARG]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local IMAGE_NAME=$1
  local INSTANCE_NAME=${2:-$1}
  local MORE_ARG=${@:3}

  echo "Start docker daemon > docker container run -d --name ${INSTANCE_NAME} ${MORE_ARG} -P ${IMAGE_NAME}"
  docker container run -d --name ${INSTANCE_NAME} ${MORE_ARG} -P ${IMAGE_NAME}

  STATUS=$?
  if [ "${STATUS}" -eq 0 ]
    then
      docker port ${INSTANCE_NAME}

      echo "dckbash ${INSTANCE_NAME} : to bash into this image"
      echo "dcklogs ${INSTANCE_NAME} : to print log of this image"
      echo "dcklogstail ${INSTANCE_NAME} : to tail log of this image"
      echo "dckdesc ${INSTANCE_NAME} : to inspect characteristics of this image"
      echo "dcktop ${INSTANCE_NAME} : to top from this image"
      echo "dckrm ${INSTANCE_NAME} : to stop and remove image"
    else
      echo "== An error has happen. Please check if an existing instance has a conflict using cmd 'dckps'. Error code=$STATUS  ==" >&2
  fi

  return $?
}
# https://opentelemetry.io/docs/reference/specification/protocol/exporter/
dckrunjavaotel() {
  usage $# "IMAGE_NAME:service-a:0.0.1-SNAPSHOT" "INSTANCE_NAME" "OTEL_EXPORTER_OTLP_ENDPOINT=http://HOST_IP:4318"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local IMAGE_NAME=$1
  local INSTANCE_NAME=$2
  local OTEL_EXPORTER_OTLP_ENDPOINT=$3

  dckrunjavaenv "${IMAGE_NAME}" "${INSTANCE_NAME}" "OTEL_EXPORTER_OTLP_ENDPOINT=${OTEL_EXPORTER_OTLP_ENDPOINT}" ${@:4}
}
dckrunjavaenv() {
  usage $# "IMAGE_NAME:service-a:0.0.1-SNAPSHOT" "[INSTANCE_NAME]" "[SYS_ENV_ARRAY]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local IMAGE_NAME=$1
  local INSTANCE_NAME=$2
  local PORT=8080

  if [ -z "${INSTANCE_NAME}" ]; then
    INSTANCE_NAME="${IMAGE_NAME%\:*}"
  fi

  local OPTIONAL_ARGS=""
  for SYS_ENV in "${@:3}"; do
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -e ${SYS_ENV}"
  done

  dckrunjava "${IMAGE_NAME}" "${PORT}" "${INSTANCE_NAME}" "--rm ${OPTIONAL_ARGS}"
}
dckrunjava() {
  usage $# "IMAGE_NAME:service-a:0.0.1-SNAPSHOT" "[PORT:8080]" "[INSTANCE_NAME]" "[SYS_ENV_PREFIXED_BY_-e]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
  
  local IMAGE_NAME=$1
  local PORT=${2:-8080}
  local INSTANCE_NAME=$3
  local SYS_ENV=${@:4}

  # If no INSTANCE_NAME use IMAGE_NAME PREFIX
  if [ -z "${INSTANCE_NAME}" ]; then
    INSTANCE_NAME="${IMAGE_NAME%\:*}"
  fi
  local OPTIONAL_ARGS="${SYS_ENV} -p ${PORT}:8080"

  echo "== Connect to ${INSTANCE_NAME} using http://localhost:${PORT} =="
  echo "If port not exposed (only needed once per VM) > dckmport ${PORT}"
  dckrundaemon "${IMAGE_NAME}" "${INSTANCE_NAME}" "${OPTIONAL_ARGS}"

  dcklogstail "${INSTANCE_NAME}"
}
dckrunjenkinsnode() {
  usage $# "INSTANCE_NAME:jenkins-nodejs" "[FOLDER_PATH]" "[PORT_JENKINS:8080]" "[PORT_SONARQUBE:9000]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local INSTANCE_NAME=${1:-jenkins-nodejs}
  local FOLDER_PATH=$2
  local PORT_JENKINS=${3:-8080}
  local PORT_SONARQUBE=${4:-9000}

  # https://hub.docker.com/r/schlechtweg/jenkins-nodejs/
  # local NEW_ARGS='--privileged --restart=always -e DOCKER_DAEMON_ARGS="-H tcp://127.0.0.1:4243 -H unix:///var/run/docker.sock"'

  # If a path is passed, create the basic folder structure
  if [ -n "${FOLDER_PATH}" ]; then
    echo "== Create base folder at ${FOLDER_PATH} =="
    mkdir -p "${FOLDER_PATH}/jenkins_home"
    mkdir -p "${FOLDER_PATH}/sonarqube_home/conf"
    mkdir -p "${FOLDER_PATH}/sonarqube_home/data"
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -v ${FOLDER_PATH}/jenkins_home:/var/lib/jenkins"
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -v ${FOLDER_PATH}/sonarqube_home/conf:/var/lib/sonarqube-6.4/conf"
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -v ${FOLDER_PATH}/sonarqube_home/data:/var/lib/sonarqube-6.4/data"
  fi

  # If no port pass, use dynamic attr port
  if [ -n "${PORT_JENKINS}" ]; then
    echo "== Connect to JENKINS using http://localhost:${PORT_JENKINS} =="
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${PORT_JENKINS}:8080"

    echo "> dckmport ${PORT_JENKINS} : to expose the port (only needed once per VM)"
  fi
  if [ -n "${PORT_SONARQUBE}" ]; then
    echo "== Connect to SONARQUBE using http://localhost:${PORT_SONARQUBE} =="
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${PORT_SONARQUBE}:9000"

    echo "> dckmport ${PORT_SONARQUBE} : to expose the port (only needed once per VM)"
  fi
  dckrundaemon "schlechtweg/jenkins-nodejs" "${INSTANCE_NAME}" "${OPTIONAL_ARGS}" "${NEW_ARGS}"

  echo "GET THE PASSWORD BY TYPING"
  echo "dckbash ${INSTANCE_NAME} cat /var/lib/jenkins/secrets/initialAdminPassword"
}
dckrunjenkins() {
  usage $# "INSTANCE_NAME:jenkins" "[FOLDER_PATH]" "[PORT_JENKINS:8080]" "[PORT_INBOUND_AGENT:50000]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi
 
  local INSTANCE_NAME=${1:-jenkins}
  local FOLDER_PATH=$2
  local PORT_JENKINS=${3:-8080}
  local PORT_INBOUND_AGENT=${4:-50000}

  # https://github.com/jenkinsci/docker

  # If a path is passed, create the basic folder structure
  if [ -n "${FOLDER_PATH}" ]; then
    echo "== Create base folder at ${FOLDER_PATH} =="
    mkdir -p "${FOLDER_PATH}/jenkins_home"
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -v ${FOLDER_PATH}/jenkins_home:/var/lib/jenkins"
  fi

  # If no port pass, use dynamic attr port
  if [ -n "${PORT_JENKINS}" ]; then
    echo "== Connect to JENKINS using http://localhost:${PORT_JENKINS} =="
    
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${PORT_JENKINS}:8080"    
    echo "> dckmport ${PORT_JENKINS} : to expose the port (only needed once per VM)"
  fi

  # If no port pass, use dynamic attr port
  if [ -n "${PORT_INBOUND_AGENT}" ]; then
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${PORT_INBOUND_AGENT}:50000"
    echo "> dckmport ${PORT_INBOUND_AGENT} : to expose the port (only needed once per VM)"
  fi

  dckrundaemon "jenkins/jenkins:lts" "${INSTANCE_NAME}" "${OPTIONAL_ARGS}"

  echo "GET THE PASSWORD BY TYPING"
  echo "dckbash ${INSTANCE_NAME} cat /var/jenkins_home/secrets/initialAdminPassword"
}

dckrunnginx() {
  usage $# "INSTANCE_NAME" "[PORT]" "[FOLDER_PATH:PWD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local FOLDER_PATH=${3:-$PWD}
  dckweb "nginx" "$FOLDER_PATH:/usr/share/nginx/html" $@
}
dckrunphp() {
  usage $# "INSTANCE_NAME" "[PORT]" "[FOLDER_PATH:PWD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  FOLDER_PATH=${3:-$PWD}
  dckweb "php:7.0-apache" "$FOLDER_PATH:/var/www/html" $@
  #dckweb "php:7.0-fpm" "$FOLDER_PATH:/var/www/html" $@
}
dckweb() {
  usage $# "[IMAGE_NAME:nginx]" "[OPTIONAL_ARGS]" "[INSTANCE_NAME:web]" "[PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  # By default image name is "nginx"
  local IMAGE_NAME=${1:-nginx}

  # Setting the folder name
  if [ -n "$2" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -v $2"
  fi

  # If no name passed, use "web"
  local INSTANCE_NAME=${3:-web}

  local PORT=$4

  # If no port pass, use dynamic attr port
  if [ -n "${PORT}" ]; then
    echo "== Connect to this host using http://localhost:${PORT} =="
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} -p ${PORT}:80"

    echo "dckmport ${PORT} : to expose the port (only needed once per VM)"
  fi

  dckrundaemon ${IMAGE_NAME} ${INSTANCE_NAME} "${OPTIONAL_ARGS}"
}

dckrunmysql() {
  usage $# "[IMAGE_NAME:mysql\:5.7.17]" "[INSTANCE_NAME:mysql]" "[PASSWORD:password]" "[PORT:3306]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  # By default image name is "mysql:5.7.17"
  local IMAGE_NAME=${1:-mysql\:5.7.17}
  # If no name passed, use "mysql"
  local INSTANCE_NAME=${2:-mysql}
  local PASSWORD=${3:-password}
  local PORT=${4:-3306}

  # https://hub.docker.com/_/mysql/
  dckrundaemon ${IMAGE_NAME} ${INSTANCE_NAME} "-e MYSQL_ROOT_PASSWORD=${PASSWORD} -p ${PORT}:3306"

  STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
    echo "dckmport ${INSTANCE_NAME} ${PORT} : to expose the port (only needed once per VM)"
  fi
}

dckrmimageforce() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any image run 'dckls' and look at the column REPOSITORY" >&2 
    return 1
  fi

  dckrmimage "-f" "$@"
}
dckrmimage() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any image run 'dckls' and look at the column REPOSITORY" >&2 
    return 1
  fi

  echo "docker rmi $@"
  docker rmi $@
  dckls
}

dckimgcleanyesterday() {
  dckimgcleanall --filter "until=24h" $@
}
dckimgcleanall() {
  dckimgclean -a $@
}
dckimgclean() {
  echo "docker image prune $@"
  docker image prune $@
  echo "docker container prune $@"
  docker container prune $@
}

dckbuild() {
  usage $# "IMAGE_NAME[:TAG_NAME]" "[DOCKERFILE_NAME]" "[ROOT_PATH]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "It is HIGHLY recommended to name the image that you will create. You can optionally append a :TAG_NAME" >&2 
    return 1
  fi

  local IMAGE_NAME=$1
  local DOCKERFILE_NAME=$2
  local ROOT_PATH=${3:-.}

  local OPTIONAL_ARGS="-t ${IMAGE_NAME}"

  if [ -n "${DOCKERFILE_NAME}" ]; then
    local OPTIONAL_ARGS="${OPTIONAL_ARGS} --file ${DOCKERFILE_NAME}"
  fi

  echo "docker build ${OPTIONAL_ARGS} ${ROOT_PATH}"
  docker build ${OPTIONAL_ARGS} ${ROOT_PATH}
}

dcmp() {
  dcmptpl version
}
dcmpbuild() {
  dcmptpl build $@
}
dcmpstart() {
  dcmptpl up $@
}
dcmpstartrm() {
  dcmpstart --remove-orphans $@
}
dcmpstartd() {
  dcmptpl up -d $@
  dckps
}
dcmpstop() {
  dcmptpl down $@
}
dcmpps() {
  dcmptpl ps $@
}
dcmplogs() {
  usage $# "INSTANCE_NAME"
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any image run 'dcmpps'" >&2
    dcmpps
    return 1
  fi
  dcmptpl logs $@
}
dcmptpl() {
  echo "docker compose $@"
  docker compose $@
}
