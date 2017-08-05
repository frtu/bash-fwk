# Starting & administration
dckproxy() {
  if [ -z "$1" ]; then
      echo "== Please pass the Domain name of your Docker registry. ==" >&2
      return
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
  if [ -z "$2" ]
    then
      echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES"
      dckps
      return -1
  fi
  echo "docker $@"
  docker $@
}

dckbash() {
  if [ $# -eq 0 ]
    then
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
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) SOURCE DESTINATION (Prefix the image location with \"IMAGE_NAME:/tmp\"). If you don't know any names run 'dckps' and look at the last column NAMES"
      dckps
      return -1
  fi
  echo "Copy from docker images : $IMAGE_NAME"
  docker cp $1 $2
}
dckrm() {
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES"
      return
  fi
  docker stop $@
  docker rm -f $@
  dckps
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
}
dcknginx() {
  if [ $# -eq 0 ]; then
    echo "Please supply argument(s) > dcknginx PATH [PORT] [INSTANCE_NAME]"
    return
  fi
  if [ -n "$1" ]; then
    OPTIONAL_ARGS="-v $1:/usr/share/nginx/html"
  fi
  if [ -n "$2" ]; then
    OPTIONAL_ARGS="$OPTIONAL_ARGS -p $2:80"
  fi
  INSTANCE_NAME=${3:-web}
	dckstartdaemon nginx $INSTANCE_NAME "$OPTIONAL_ARGS"
  docker port $INSTANCE_NAME
  
  echo "dcklogs $1 : to tail log of this image"
  echo "dckinspect $1 : to inspect characteristics of this image"
  echo "dcktop $1 : to top from this image"
  echo "dckrm $1 : to stop and remove image"
}

dckcleanimage() {
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) \"REPOSITORY\". If you don't know any image run 'dckls' and look at the column REPOSITORY"
      return
  fi
  docker rmi $@
}
