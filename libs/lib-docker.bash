import lib-vm

# Starting & administration
dckproxy() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
      echo "== Please pass the Domain name of your Docker registry. ==" >&2
      return -1
  fi
  echo "Setting locally the Docker proxy $1 in ~/scripts/service_docker_proxy.bash"
  echo "ATTENTION : Doesn't work for boot2docker !! Use dckmregistryinsecure() or dckmregistry() INSTEAD !"
  
  echo 'export DOCKER_OPTS=" --registry-mirror 'https://$1' --insecure-registry 'http://$1'"' > $LOCAL_SCRIPTS_FOLDER/env-docker-proxy.bash
}

dckls() {
  echo "List all existing docker images"
  docker version
  docker images
}
# See running
dckps() {
  docker ps -a
}

dcksearch() {
  dcktpl "search" $@
}
dckpull() {
  local IMAGE_NAME=${1:-ubuntu}

	echo "Fetching new docker images : $IMAGE_NAME"
	docker pull $IMAGE_NAME
}

dckstart() {
  dcktpl "start" $@
}
dckstartall() {
  dckstart $(docker ps -aq)
}
dckinspect() {
  dcktpl "inspect" $@
}
dcklogs() {
  dcktpl "logs" $@
}
dcktop() {
  dcktpl "top" $@
}
dckstop() {
  dcktpl "stop" $@
}
dckstopall() {
  dckstop $(docker ps -aq)
}
dcktpl() {
  if [ -z "$2" ]; then
    echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    dckps
    return -1
  fi
  echo "docker $@"
  docker $@
}

dckbash() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Please supply the argument : IMAGE_NAME. If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    dckps
    return -1
  fi

  local IMAGE_NAME=$1
  if [ -z "$2" ]
    then
      echo "Login into a Bash docker images : $IMAGE_NAME"
      docker exec -it $IMAGE_NAME bash
    else
      shift 1
      echo "CALL : root@$IMAGE_NAME> $@"
      echo "$@" | docker exec -i $IMAGE_NAME bash
  fi
}
dckcp() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Please supply argument(s) SOURCE DESTINATION (Prefix the image location with \"IMAGE_NAME:/tmp\"). If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    dckps
    return -1
  fi
  echo "Copy from docker images : $IMAGE_NAME"
  docker cp $1 $2
}
dckrm() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES" >&2
    return -1
  fi
  docker stop $@
  docker rm -f $@
  dckps
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
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "== Please supply argument(s) > dckimport FILENAME_TAR ==" >&2
    return -1
  fi

  local VM_NAME=$1
  # If the local file exist
  if [ ! -f $VM_NAME ]; then
    # Add VM_ROOT_FOLDER
    VM_NAME=$VM_ARCHIVE_FOLDER/$1
  fi
  if [ ! -f $VM_NAME ]; then
    VM_NAME=$VM_ARCHIVE_FOLDER/docker_$1.tar.gz
  fi
  if [ ! -f $VM_NAME ]; then
    echo "Cannot find file '$1' or '$VM_NAME'" >&2
    return -1
  fi

  echo "docker load -i $VM_NAME"
  docker load -i $VM_NAME

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
  docker network ls
  echo "== Inspect bridge ==" 
  docker network inspect bridge
  echo "== Inspect host ==" 
  docker network inspect host
}
dcknethosts() {
  cat /etc/hosts
}

dckhello() {
  echo "Testing if docker works?"
  docker run hello-world
}
dckstartdaemon() {
  usage $# "IMAGE_NAME" "[INSTANCE_NAME]" "[DCK_PORT_DECLARATION]" "[MORE_ARG]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local IMAGE_NAME=$1
  local INSTANCE_NAME=${2:-$1}
  local MORE_ARG=${@:3}

  echo "Start docker daemon > docker run --name ${INSTANCE_NAME} ${MORE_ARG} -P -d ${IMAGE_NAME}"
  docker run --name ${INSTANCE_NAME} ${MORE_ARG} -P -d ${IMAGE_NAME}

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

dckrunjenkins() {
  usage $# "INSTANCE_NAME" "[PORT]" "[PATH:PWD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FOLDER_PATH=${3:-$PWD}
  # -p 8082:8080 -p 50000:50000
  dckweb "jenkins/jenkins" "$FOLDER_PATH:/var/jenkins_home" $@
}
dckrunnginx() {
  usage $# "INSTANCE_NAME" "[PORT]" "[PATH:PWD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FOLDER_PATH=${3:-$PWD}
  dckweb "nginx" "$FOLDER_PATH:/usr/share/nginx/html" $@
}
dckrunphp() {
  usage $# "INSTANCE_NAME" "[PORT]" "[PATH:PWD]"
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

    echo "dckmport ${INSTANCE_NAME} ${PORT} : to expose the port (only needed once per VM)"
  fi

  dckstartdaemon ${IMAGE_NAME} ${INSTANCE_NAME} "${OPTIONAL_ARGS}"
}

dckrunmysql() {
  usage $# "[IMAGE_NAME:mysql\:5.7.17]" "[INSTANCE_NAME:mysql]" "[PORT:password]" "[PATH:3306]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  # By default image name is "mysql:5.7.17"
  local IMAGE_NAME=${1:-mysql\:5.7.17}
  # If no name passed, use "mysql"
  local INSTANCE_NAME=${2:-mysql}
  local PASSWORD=${3:-password}
  local PORT=${4:-3306}

  # https://hub.docker.com/_/mysql/
  dckstartdaemon ${IMAGE_NAME} ${INSTANCE_NAME} "-e MYSQL_ROOT_PASSWORD=${PASSWORD} -p ${PORT}:3306"

  STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
    echo "dckmport ${INSTANCE_NAME} ${PORT} : to expose the port (only needed once per VM)"
  fi
}

dckrmimage() {
  usage $# "REPOSITORY"
  if [[ "$?" -ne 0 ]]; then 
    echo "If you don't know any image run 'dckls' and look at the column REPOSITORY" >&2 
    dckls 
    return -1
  fi
  docker rmi $@
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
