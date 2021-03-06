# ATTENTION wget is not always installed by default. TODO : Should fallback to curl
# Only download if target doesn't exist
trwgetlazy() { 
  usage $# "FILENAME" "HTTP_URL" "[HTTP_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FILENAME=$1
  local HTTP_URL=$2
  local HTTP_PARAMS=$3

  if [ -f $FILENAME ]; then
      echo "Skip wget since file exist, use this one $FILENAME" >&2
      return -1
  fi

  #if [ ! -z "$3" ]; then
      #HTTP_PARAMS=--header "$3"
  #fi

  echo "Downloading : wget --no-cookies --no-check-certificate -O ${FILENAME} --header "${HTTP_PARAMS}" $HTTP_PARAMS ${HTTP_URL}"
  wget --no-cookies --no-check-certificate -O "${FILENAME}_downloading" --header "${HTTP_PARAMS}" $HTTP_PARAMS ${HTTP_URL}

  STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
    mv ${FILENAME}_downloading ${FILENAME} 
    echo "Done : ${FILENAME}"
  fi
}
# Download using "*_downloading" extension, and remove only if succeed
trwgetsafe() {
  usage $# "FILENAME" "HTTP_URL"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FILENAME=$1
  local HTTP_URL=$2

  echo "Downloading : wget -O ${FILENAME} ${HTTP_URL}"
  wget -O "${FILENAME}_downloading" ${HTTP_URL}
  
  STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
    mv ${FILENAME}_downloading ${FILENAME} 
    echo "Done : ${FILENAME}"
  fi
}

# Using echo & tee over SSH to transfer a file
trsshpush() {
  local SSH_FULL_HOSTPATH=$1
  local LOCAL_RESOURCE=$2

  echo "ATTENTION : use this command based on ~ with relative folder, since ~ differs on machines"
  
  if [ -z "$SSH_FULL_HOSTPATH" ]; then
    echo "Please specify required SSH_FULL_HOSTPATH parameters > 'trsshpush SSH_FULL_HOSTPATH LOCAL_RESOURCE'." >&2
    echo "SSH_FULL_HOSTPATH can be IP, SSH_HOSTNAME or USER@SSH_HOSTNAME" >&2
    return -1
  fi

  if [ -d "$LOCAL_RESOURCE" ]; then
    echo "== Copying directory $LOCAL_RESOURCE by concat into a single execution instruction COMMAND =="
    echo "ATTENTION : has some bugs not all the files are copied, may need to retry UNSUCCESFUL files ONLY"

    COMMAND=`{ printf "mkdir -p $LOCAL_RESOURCE"; }`
    for file in $LOCAL_RESOURCE* ; do 
      COMMAND=`{ printf %s "$COMMAND"; echo -e "\ntee $file <<EOF"; cat $file; echo "EOF"; }`
    done

    printf %s "$COMMAND" | ssh $SSH_FULL_HOSTPATH
  elif [ -f "$LOCAL_RESOURCE" ]; then
    echo "== Copying file $LOCAL_RESOURCE to $SSH_FULL_HOSTPATH=="
    COMMAND=`{ echo "tee $LOCAL_RESOURCE <<EOF"; cat $LOCAL_RESOURCE; echo "EOF"; }`
  
    printf %s "$COMMAND" | ssh $SSH_FULL_HOSTPATH
  else
    echo "Please specify required LOCAL_RESOURCE parameters > 'trsshpush SSH_FULL_HOSTPATH LOCAL_RESOURCE'." >&2
    echo "LOCAL_RESOURCE needs to be a valid file" >&2
    return -1
  fi
}
trscpproxypush() {
  usage $# "FWD_HOSTNAME" "SSH_FULL_HOSTPATH" "LOCAL_RESOURCE" "[REMOTE_RESOURCE]" "[FWD_PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local FWD_HOSTNAME=$1
  local SSH_FULL_HOSTPATH=$2
  local LOCAL_RESOURCE=$3
  local REMOTE_RESOURCE=${4:-$3}
  local FWD_PORT=${5:-22}

  # https://unix.stackexchange.com/questions/355640/how-to-scp-via-an-intermediate-machine
  trscppush "$SSH_FULL_HOSTPATH" "$LOCAL_RESOURCE" "$REMOTE_RESOURCE" "ssh ${FWD_HOSTNAME} nc %h ${FWD_PORT}"
}
trscppush() {
  usage $# "SSH_FULL_HOSTPATH" "LOCAL_RESOURCE" "[REMOTE_RESOURCE]" "[PROXY_CMD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Please specify required SSH_FULL_HOSTPATH parameters > '${FUNCNAME[1]} SSH_FULL_HOSTPATH LOCAL_RESOURCE [REMOTE_RESOURCE]'." >&2
    echo "SSH_FULL_HOSTPATH can be IP, SSH_HOSTNAME or USER@SSH_HOSTNAME" >&2
    return -1
  fi

  local SSH_FULL_HOSTPATH=$1
  local LOCAL_RESOURCE=$2
  local REMOTE_RESOURCE=${3:-$2}

  local PROXY_CMD=${@:4}

  # Check resource type based on local resource
  if [ -d "$LOCAL_RESOURCE" ]; then
    local EXTRA_ARGS="-r $EXTRA_ARGS"
  elif [ ! -f "$LOCAL_RESOURCE" ]; then
    echo "$LOCAL_RESOURCE is not valid"
    return -1
  fi

  if [ -n "${PROXY_CMD}" ]; then
    echo "scp ${EXTRA_ARGS} -o ProxyCommand=\"${PROXY_CMD}\" \"$LOCAL_RESOURCE\" $SSH_FULL_HOSTPATH:\"$REMOTE_RESOURCE\""
    scp ${EXTRA_ARGS} -o ProxyCommand="${PROXY_CMD}" "$LOCAL_RESOURCE" $SSH_FULL_HOSTPATH:"$REMOTE_RESOURCE"
  else
    echo "scp ${EXTRA_ARGS} \"$LOCAL_RESOURCE\" $SSH_FULL_HOSTPATH:\"$REMOTE_RESOURCE\""
    scp ${EXTRA_ARGS} "$LOCAL_RESOURCE" $SSH_FULL_HOSTPATH:"$REMOTE_RESOURCE"
  fi
}
trscpget() {
  usage $# "SSH_FULL_HOSTPATH" "REMOTE_RESOURCE" "[LOCAL_RESOURCE]" "[KEY_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "- SSH_FULL_HOSTPATH can be IP, SSH_HOSTNAME or USER@SSH_HOSTNAME" >&2
    echo "- LOCAL_RESOURCE MUST ends with / if that's a folder" >&2
    return -1
  fi

  local SSH_FULL_HOSTPATH=$1
  local REMOTE_RESOURCE=$2
  local LOCAL_RESOURCE=${3:-$2}
  local KEY_NAME=$4

  # Guess resource type based on remote url (please don't forget the / to indicate folder!)
  if [[ "$LOCAL_RESOURCE" == *\/ ]] || [["$REMOTE_RESOURCE" == *\/ ]]; then
    local EXTRA_ARGS="-r"
  fi

  if [ -n "${KEY_NAME}" ]; then
    KEY_PRI="${SSH_ROOT}/${KEY_NAME}"
    local EXTRA_ARGS="-i ${KEY_PRI} ${EXTRA_ARGS}"
  fi

  echo "scp ${EXTRA_ARGS} $SSH_FULL_HOSTPATH:\"$REMOTE_RESOURCE\" \"$LOCAL_RESOURCE\""
  scp ${EXTRA_ARGS} $SSH_FULL_HOSTPATH:"$REMOTE_RESOURCE" "$LOCAL_RESOURCE"
}
