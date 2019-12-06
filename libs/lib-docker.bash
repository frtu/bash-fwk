import lib-vm

dck() {
  docker version
}

dckls() {
  echo "List all existing docker images"
  docker images
}
dckpullsk() {
  usage $# "IMAGE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local IMAGE_NAME=$1
  dckpull ${IMAGE_NAME} "–disable-content-trust"
}
dckpull() {
  usage $# "IMAGE_NAME" "[EXTRA_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "docker pull $@"
  docker pull $@
}
dcksearch() {
  usage $# "IMAGE_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  dcktpl "search" $@
}

# See running
dckps() {
  docker ps -a
}
dckstart() {
  dcktpl "start" $@
}
dckstartall() {
  dckstart $(docker ps -aq)
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
dckinspect() {
  dcktpl "inspect" $@
}
dcktop() {
  dcktpl "top" $@
}
dcktpl() {
  if [ -z "$2" ]; then
    echo "Please supply argument(s) \"INSTANCE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    dckps
    return -1
  fi
  echo "docker $@"
  docker $@
}
dckrm() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Please supply argument(s) \"INSTANCE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    return -1
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
     return -1
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
    return -1
  fi

  dckbashtpl "sh" $@
}
dckbash() {
  usage $# "INSTANCE_NAME" "[COMMANDS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    dckps
    return -1
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
    return -1
  fi

  local BASH_CMD=$1
  local INSTANCE_NAME=$2

  # run in LOGIN MODE : https://github.com/rbenv/rbenv/wiki/Unix-shell-initialization#bash
  if [ -z "$3" ]
    then
      echo "Login into a Bash docker images : ${INSTANCE_NAME}"
      docker exec -it ${INSTANCE_NAME} ${BASH_CMD} -l
    else
      local COMMANDS=${@:3}
      echo "CALL : root@${INSTANCE_NAME}> ${COMMANDS}"
      echo "${COMMANDS}" | docker exec -i ${INSTANCE_NAME} ${BASH_CMD} -l
  fi
}
# Shell into an existing IMAGE_NAME
dckimagesh() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckls' and look at the last column NAMES" >&2
    dckls
    return -1
  fi

  dckimagebashtpl "sh" $@
}
dckimagebash() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckls' and look at the last column NAMES" >&2
    dckls
    return -1
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
    return -1
  fi

  local BASH_CMD=$1
  local IMAGE_NAME=$2

  echo "Login into a Bash docker images : ${IMAGE_NAME}"
  docker run --rm -ti --entrypoint ${BASH_CMD} ${IMAGE_NAME}
}

# Starting & administration
dckproxy() {
  usage $# "DOCKER_REGISTRY_DOMAIN_NAME"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local DOCKER_REGISTRY_DOMAIN_NAME=$1

  echo "Setting locally the Docker proxy $1 in ~/scripts/service_docker_proxy.bash"
  echo "ATTENTION : Doesn't work for boot2docker !! Use dckmregistryinsecure() or dckmregistry() INSTEAD !"
  
  echo 'export DOCKER_OPTS=" --registry-mirror 'https://${DOCKER_REGISTRY_DOMAIN_NAME}' --insecure-registry 'http://${DOCKER_REGISTRY_DOMAIN_NAME}'"' > $LOCAL_SCRIPTS_FOLDER/env-docker-proxy.bash
}

dckexport() {
  usage $# "IMAGE_NAME:TAG_NAME" "[FILENAME_TAR]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dckls' and look at the 2 columns REPOSITORY:TAG" >&2
    dckls
    return -1
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
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
    return -1
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

# https://docs.docker.com/engine/userguide/networking/
dcknetls() {
  echo "docker network ls"
  docker network ls
}
dcknetlsfull() {
  dcknetls
  echo "== Inspect bridge ==" 
  docker network inspect bridge
  echo "== Inspect host ==" 
  docker network inspect host
}
# https://docs.docker.com/engine/reference/commandline/network_rm/
dcknetrm() {
  usage $# "NETWORK_NAME_OR_IDs"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any names run 'dcknetls'" >&2
    dcknetls
    return -1
  fi

  echo "docker network rm $@"
  docker network rm $@

  dcknetls
}
dcknethosts() {
  cat /etc/hosts
}

dckhello() {
  echo "Testing if docker works?"
  docker run --rm hello-world
}

dckcreate() {
  usage $# "IMAGE_NAME" "INSTANCE_NAME" "[MORE_ARG]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any image run 'dckls' and look at the column REPOSITORY" >&2 
    dckls 
    return -1
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
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local IMAGE_NAME=$1
  local INSTANCE_NAME=${2:-$1}
  local MORE_ARG=${@:3}

  echo "Start docker daemon > docker run -d --name ${INSTANCE_NAME} ${MORE_ARG} -P ${IMAGE_NAME}"
  docker run -d --name ${INSTANCE_NAME} ${MORE_ARG} -P ${IMAGE_NAME}

  STATUS=$?
  if [ "${STATUS}" -eq 0 ]
    then
      docker port ${INSTANCE_NAME}

      echo "dcklogs ${INSTANCE_NAME} : to tail log of this image"
      echo "dckinspect ${INSTANCE_NAME} : to inspect characteristics of this image"
      echo "dcktop ${INSTANCE_NAME} : to top from this image"
      echo "dckrm ${INSTANCE_NAME} : to stop and remove image"
    else
      echo "== An error has happen. Please check if an existing instance has a conflict using cmd 'dckps'. Error code=$STATUS  ==" >&2
  fi

  return $?
}
dckrunjavaenv() {
  usage $# "IMAGE_NAME:service-a:0.0.1-SNAPSHOT" "[SYS_ENV_ARRAY]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local IMAGE_NAME=$1
  local PORT=8080
  local INSTANCE_NAME="${IMAGE_NAME%\:*}"

  local OPTIONAL_ARGS=""
  for SYS_ENV in "${@:2}"; do
    OPTIONAL_ARGS="${OPTIONAL_ARGS} -e ${SYS_ENV}"
  done

  dckrunjava "${IMAGE_NAME}" "${PORT}" "${INSTANCE_NAME}" "--rm ${OPTIONAL_ARGS}"
}
dckrunjava() {
  usage $# "IMAGE_NAME:service-a:0.0.1-SNAPSHOT" "[PORT:8080]" "[INSTANCE_NAME]" "[SYS_ENV_PREFIXED_BY_-e]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
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
}
dckrunjenkinsnode() {
  usage $# "INSTANCE_NAME:jenkins-nodejs" "[FOLDER_PATH]" "[PORT_JENKINS:8080]" "[PORT_SONARQUBE:9000]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
  if [[ "$?" -ne 0 ]]; then return -1; fi
 
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
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FOLDER_PATH=${3:-$PWD}
  dckweb "nginx" "$FOLDER_PATH:/usr/share/nginx/html" $@
}
dckrunphp() {
  usage $# "INSTANCE_NAME" "[PORT]" "[FOLDER_PATH:PWD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  FOLDER_PATH=${3:-$PWD}
  dckweb "php:7.0-apache" "$FOLDER_PATH:/var/www/html" $@
  #dckweb "php:7.0-fpm" "$FOLDER_PATH:/var/www/html" $@
}
dckweb() {
  usage $# "[IMAGE_NAME:nginx]" "[OPTIONAL_ARGS]" "[INSTANCE_NAME:web]" "[PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

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
  if [[ "$?" -ne 0 ]]; then return -1; fi

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

dckrmimage() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any image run 'dckls' and look at the column REPOSITORY" >&2 
    dckls 
    return -1
  fi

  echo "docker rmi $@"
  docker rmi $@
  dckls
}

dckbuild() {
  usage $# "IMAGE_NAME[:TAG_NAME]" "[DOCKERFILE_NAME]" "[ROOT_PATH]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "It is HIGHLY recommended to name the image that you will create. You can optionally append a :TAG_NAME" >&2 
    return -1
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

dcmpstart() {
  docker-compose up
}
dcmpstartd() {
  docker-compose up -d
  dckps
}
dcmpstop() {
  docker-compose down
}

dcmpps() {
  docker-compose ps
}
dcmplogs() {
  usage $# "INSTANCE_NAME"
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any image run 'dcmpps'" >&2
    dcmpps
    return -1
  fi
  docker-compose logs $1
}
