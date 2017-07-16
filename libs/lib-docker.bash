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
  docker images
}
# See running
dckps() {
  docker ps -a
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
      local IMAGE_NAME=$1
    else
      local IMAGE_NAME=$2
  fi
  echo "Start docker daemon -d & open port -P : name=$IMAGE_NAME image=$1 optional_args=$3"
	docker run -d -P $3 --name $IMAGE_NAME $1
}
dcknginx() {
	if [ -n "$1" ]
	  then
        local OPTIONAL_ARGS="-v $1:/usr/share/nginx/html"
  	else
  		echo "You can pass a folder as first argument to indicate where nginx should take his document folder!"
  fi
	dckstartdaemon nginx web "$OPTIONAL_ARGS"
}

dckcleanimage() {
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) \"REPOSITORY\". If you don't know any image run 'dckls' and look at the column REPOSITORY"
      return
  fi
  docker rmi $@
}