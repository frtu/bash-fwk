# Starting & administration
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