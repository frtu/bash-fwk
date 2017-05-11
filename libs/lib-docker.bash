# Starting & administration
dckrepo() {
  if [ -z "$1" ]; then
      echo "== Please pass the Domain name of your Docker registry. ==" >&2
      return
  fi

  echo "export DOCKER_OPTS='$DOCKER_OPTS --insecure-registry $1'" 
  export DOCKER_OPTS="$DOCKER_OPTS --insecure-registry $1"
}

dcklist() {
  echo "List all existing docker images"
  docker images
}
# See running
dckps() {
  docker ps -a
}

dckhello() {
	echo "Testing if docker works?"
	docker run hello-world
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
dckbash() {
  if [ -z "$1" ]
    then
      local IMAGE_NAME=ubuntu
    else
      local IMAGE_NAME=$1
  fi
  echo "Login into a Bash docker images : $IMAGE_NAME"
	docker exec -it $IMAGE_NAME bash
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

dckstart() {
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES"
      return
  fi
  docker start $1
}
dckstop() {
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES"
      return
  fi
  docker stop $1
}

dckrm() {
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) \"IMAGE_NAME\". If you don't know any names run 'dckps' and look at the last column NAMES"
      return
  fi

  docker stop $1
  docker rm -f $1
  docker ps
}

dckcleanimage() {
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) \"REPOSITORY\". If you don't know any image run 'dcklist' and look at the column REPOSITORY"
      return
  fi
  docker rmi $1
}