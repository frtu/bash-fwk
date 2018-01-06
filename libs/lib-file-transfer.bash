# ATTENTION wget is not always installed by default. TODO : Should fallback to curl
# Only download if target doesn't exist
trwgetlazy() { 
  if [ $# -eq 0 ]; then
      echo "wgetlazy FILENAME HTTP_URL [HTTP_PARAMS]"
      return 1
  fi
  if [ -f $1 ]; then
      echo "File exist, use this one $1"
      return 1
  fi

  #if [ ! -z "$3" ]; then
      #HTTP_PARAMS=--header "$3"
  #fi

  echo "wget --no-cookies --no-check-certificate -O $1 $HTTP_PARAMS $2"
  wget --no-cookies --no-check-certificate -O $1 --header "$3" $HTTP_PARAMS $2
}
# Download using "*_downloading" extension, and remove only if succeed
trwgetsafe() {
  echo "Downloading : wget -O $1 $2"
  wget -O $1_downloading $2
  mv $1_downloading $1  
  echo "Done : $1"
}

# Using echo & tee over SSH to transfer a file
trsshpush() {
  local SSH_FULL_HOSTPATH=$1
  local LOCAL_RESOURCE=$2

  echo "ATTENTION : use this command based on ~ with relative folder, since ~ differs on machines"
  
  if [ -z "$SSH_FULL_HOSTPATH" ]; then
    echo "Please specify required SSH_FULL_HOSTPATH parameters > 'trsshpush SSH_FULL_HOSTPATH LOCAL_RESOURCE'."
    echo "SSH_FULL_HOSTPATH can be IP, SSH_HOSTNAME or USER@SSH_HOSTNAME"
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
    echo "Please specify required LOCAL_RESOURCE parameters > 'trsshpush SSH_FULL_HOSTPATH LOCAL_RESOURCE'."
    echo "LOCAL_RESOURCE needs to be a valid file"
    return -1
  fi
}

trscppush() {
  if [ -z "$1" ]; then
    echo "Please specify required SSH_FULL_HOSTPATH parameters > 'trscppush SSH_FULL_HOSTPATH REMOTE_RESOURCE [LOCAL_RESOURCE]'."
    echo "SSH_FULL_HOSTPATH can be IP, SSH_HOSTNAME or USER@SSH_HOSTNAME"
    return -1
  fi
  if [ -z "$2" ]; then
    echo "Please specify required SSH_FULL_HOSTPATH parameters > 'trscppush SSH_FULL_HOSTPATH REMOTE_RESOURCE [LOCAL_RESOURCE]'."
    return -1
  fi
  local SSH_FULL_HOSTPATH=$1
  local LOCAL_RESOURCE=$2
  local REMOTE_RESOURCE=${3:-$2}

  if [ -d "$LOCAL_RESOURCE" ]; then
    echo scp -r "$LOCAL_RESOURCE" $SSH_FULL_HOSTPATH:"$REMOTE_RESOURCE"
    sudo scp -r "$LOCAL_RESOURCE" $SSH_FULL_HOSTPATH:"$REMOTE_RESOURCE"
  elif [ -f "$LOCAL_RESOURCE" ]; then
    echo scp "$LOCAL_RESOURCE" $SSH_FULL_HOSTPATH:"$REMOTE_RESOURCE"
    sudo scp "$LOCAL_RESOURCE" $SSH_FULL_HOSTPATH:"$REMOTE_RESOURCE"
  else
    echo "$LOCAL_RESOURCE is not valid"
    return -1
  fi
}
trscpget() {
  if [ -z "$1" ]; then
    echo "Please specify required SSH_FULL_HOSTPATH parameters > 'trscpget SSH_FULL_HOSTPATH REMOTE_RESOURCE [LOCAL_RESOURCE]'."
    echo "SSH_FULL_HOSTPATH can be IP, SSH_HOSTNAME or USER@SSH_HOSTNAME"
    return -1
  fi
  if [ -z "$2" ]; then
    echo "Please specify required SSH_FULL_HOSTPATH parameters > 'trscpget SSH_FULL_HOSTPATH REMOTE_RESOURCE [LOCAL_RESOURCE]'."
    return -1
  fi
  local SSH_FULL_HOSTPATH=$1
  local REMOTE_RESOURCE=$2
  local LOCAL_RESOURCE=${3:-$2}

  if [ -d "$LOCAL_RESOURCE" ]; then
    echo scp -r $SSH_FULL_HOSTPATH:$REMOTE_RESOURCE "$LOCAL_RESOURCE"
    sudo scp -r $SSH_FULL_HOSTPATH:$REMOTE_RESOURCE "$LOCAL_RESOURCE"
  elif [ -f "$LOCAL_RESOURCE" ]; then
    echo scp $SSH_FULL_HOSTPATH:$REMOTE_RESOURCE "$LOCAL_RESOURCE"
    sudo scp $SSH_FULL_HOSTPATH:$REMOTE_RESOURCE "$LOCAL_RESOURCE"
  else
    echo "$LOCAL_RESOURCE is not valid"
    return -1
  fi
}