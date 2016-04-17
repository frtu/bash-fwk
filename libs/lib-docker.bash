# Starting & administration
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
dckimagelist() {
  	echo "List all existing docker images"
	docker images
}
dckbash() {
	if [ -z "$1" ]
    	then
        	local IMAGE_NAME=ubuntu
	    else
    	    local IMAGE_NAME=$1
  	fi
  	echo "Login into a Bash docker images : $IMAGE_NAME"
	docker run -it $IMAGE_NAME bash
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

# See running
dckps() {
	docker ps
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