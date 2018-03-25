export DEFAULT_ZOOKEEPER_HOSTNAME=localhost
export DEFAULT_ZOOKEEPER_PORT=2181

zknetstat() {
	if [ -z "$1" ]
    	then
        	local ZOOKEEPER_PORT=$DEFAULT_ZOOKEEPER_PORT
	    else
    	    local ZOOKEEPER_PORT=$1
  	fi
	netstat -an | grep $ZOOKEEPER_PORT
}

zkping() {
	if [ -z "$1" ]
    	then
        	local ZOOKEEPER_PORT=$DEFAULT_ZOOKEEPER_PORT
	    else
    	    local ZOOKEEPER_PORT=$1
  	fi
	if [ -z "$2" ]
    	then
        	local ZOOKEEPER_HOSTNAME=$DEFAULT_ZOOKEEPER_HOSTNAME
	    else
    	    local ZOOKEEPER_HOSTNAME=$1
  	fi
	echo ruok | nc $ZOOKEEPER_HOSTNAME $ZOOKEEPER_PORT
}
zkstatus() {
	if [ -z "$1" ]
    	then
        	local ZOOKEEPER_PORT=$DEFAULT_ZOOKEEPER_PORT
	    else
    	    local ZOOKEEPER_PORT=$1
  	fi
	if [ -z "$2" ]
    	then
        	local ZOOKEEPER_HOSTNAME=$DEFAULT_ZOOKEEPER_HOSTNAME
	    else
    	    local ZOOKEEPER_HOSTNAME=$1
  	fi
  	echo status | nc $ZOOKEEPER_HOSTNAME $ZOOKEEPER_PORT
}
