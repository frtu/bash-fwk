# Starting & administration
dckproxy() {
  if [ -z "$1" ]; then
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
  if [ -z "$1" ]
    then
      local IMAGE_NAME=ubuntu
    else
      local IMAGE_NAME=$1
  fi
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
    echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES"
    dckps
    return -1
  fi
  echo "docker $@"
  docker $@
}

dckbash() {
  if [ $# -eq 0 ]; then
    echo "Please supply the argument : IMAGE_NAME. If you don't know any names run 'dckps' and look at the last column NAMES"
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
  if [ $# -eq 0 ]; then
    echo "Please supply argument(s) SOURCE DESTINATION (Prefix the image location with \"IMAGE_NAME:/tmp\"). If you don't know any names run 'dckps' and look at the last column NAMES"
    dckps
    return -1
  fi
  echo "Copy from docker images : $IMAGE_NAME"
  docker cp $1 $2
}
dckrm() {
  if [ $# -eq 0 ]; then
    echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES"
    return -1
  fi
  docker stop $@
  docker rm -f $@
  dckps
}
dcksave() {
  if [ $# -eq 0 ]; then
    echo "== Please supply argument(s) > dcksave IMAGE_NAME:TAG_NAME [FILENAME_TAR] =="
    echo "If you don't know any names run 'dckls' and look at the 2 columns REPOSITORY:TAG"
    dckls
    return -1
  fi
  FILENAME_TAR=${2:-docker_save.tar}

  echo "docker save $1 > $FILENAME_TAR"
  docker save $1 > $FILENAME_TAR
  gzip $FILENAME_TAR
  echo "Save image $1 to $FILENAME_TAR.gz"
}
dckload() {
  if [ $# -eq 0 ]; then
    echo "== Please supply argument(s) > dckload FILENAME_TAR =="
    return -1
  fi

  tarfilename=$1

  fileext=${1##*.}
  if [[ $fileext = "gz" ]]; then
    echo "Detected fileext=$fileext > gunzip $1"
    gunzip $1
    tarfilename=${1%.*}
  fi

  echo "docker load -i $tarfilename"
  docker load -i $tarfilename
  dckls
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
  if [ -z "$2" ]
    then
      local INSTANCE_NAME=$1
    else
      local INSTANCE_NAME=$2
  fi
  local IMAGE_NAME=$1
  shift 2
  
  echo "Start docker daemon > docker run --name $INSTANCE_NAME $@ -P -d $IMAGE_NAME"
	docker run --name $INSTANCE_NAME $@ -P -d $IMAGE_NAME

  return $?
}

dcknginx() {
  if [ $# -eq 0 ]; then
    echo "Please supply argument(s) > dcknginx INSTANCE_NAME [PORT] [PATH]"
    return -1
  fi
  FOLDER_PATH=${3:-$PWD}
  dckweb "nginx" "$FOLDER_PATH:/usr/share/nginx/html" $@
}
dckphp() {
  if [ $# -eq 0 ]; then
    echo "Please supply argument(s) > dckphp INSTANCE_NAME [PORT] [PATH]"
    return -1
  fi
  FOLDER_PATH=${3:-$PWD}
  dckweb "php:7.0-apache" "$FOLDER_PATH:/var/www/html" $@
}
dckweb() {
  # By default image name is "nginx"
  local IMAGE_NAME=${1:-nginx}

  # Setting the folder name
  if [ -n "$2" ]; then
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -v $2"
  fi

  # If no name passed, use "web"
  local INSTANCE_NAME=${3:-web}

  # If no port pass, use dynamic attr port
  if [ -n "$4" ]; then
    echo "== Connect to this host using http://localhost:$4 =="
    local OPTIONAL_ARGS="$OPTIONAL_ARGS -p $4:80"
  fi

  dckstartdaemon $IMAGE_NAME $INSTANCE_NAME "$OPTIONAL_ARGS"

  STATUS=$?
  if [ "$STATUS" -eq 0 ]
    then
      docker port $INSTANCE_NAME

      echo "dcklogs $INSTANCE_NAME : to tail log of this image"
      echo "dckinspect $INSTANCE_NAME : to inspect characteristics of this image"
      echo "dcktop $INSTANCE_NAME : to top from this image"
      echo "dckrm $INSTANCE_NAME : to stop and remove image"
    else
      echo "== An error has happen. Please check if an existing instance has a conflict using cmd 'dckps'. Error code=$STATUS  =="
  fi
}

dckcleanimage() {
  if [ $# -eq 0 ]; then
    echo "Please supply argument(s) \"REPOSITORY\". If you don't know any image run 'dckls' and look at the column REPOSITORY"
    return -1
  fi
  docker rmi $@
}
