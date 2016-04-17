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
  	echo "Start docker daemon -d & open port -P : $IMAGE_NAME"
	docker run -d -P --name $1 $2
}

# See running
dckps() {
	docker ps
}
