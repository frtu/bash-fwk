import lib-file-transfer

# ATTENTION MUST BE ~ since remote may have different path
USR_KEYS="~/.ssh/authorized_keys"

SSH_CONFIG_BASE="/etc/ssh/ssh_config"

SSH_ROOT="$HOME/.ssh"
SSH_CONFIG="$HOME/.ssh/config"

DEFAULT_KEYS_NAME="id_rsa"
DEFAULT_KEYS_PRI="${SSH_ROOT}/${DEFAULT_KEYS_NAME}"
DEFAULT_KEYS_PUB="$DEFAULT_KEYS_PRI.pub"

sshkeysls() {
  echo "Listing keys available in $SSH_ROOT"

  for file in $SSH_ROOT/*.pub ; do 
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    echo "- $filename"
  done
}
sshkeysgen() {
  local KEYS_NAME=${1:-$DEFAULT_KEYS_NAME}

  KEYS_PRI="${SSH_ROOT}/${KEYS_NAME}"

  echo "ssh-keygen -t rsa -b 4096 -f $KEYS_PRI"
  ssh-keygen -t rsa -b 4096 -f $KEYS_PRI
}

# NOT NEEDED when calling sshkeysgen. ONLY useful to store authorized_keys or ssh_config
sshmkdir() {
  if [ ! -d "${SSH_ROOT}" ]; then
    echo "== Create non existing folder : $SSH_ROOT =="
    mkdir -p $SSH_ROOT
    chmod 700 $SSH_ROOT
  fi
}
sshcd() {
  cd $SSH_ROOT
}

sshportpush() {
  # MIN NUM OF ARG
  if [[ "$#" < "3" ]]; then
    echo "Usage: sshportpush LOCAL_PORT SSH_HOSTNAME SSH_PORT [USERNAME]" >&2
    return -1
  fi

  local LOCAL_PORT=$1
  local SSH_HOSTNAME=$2
  local SSH_PORT=$3
  local USERNAME=${4:-$USER}

  echo "ssh -f -N -L $LOCAL_PORT:127.0.0.1:$SSH_PORT $USERNAME@$SSH_HOSTNAME"
  ssh -f -N -L $LOCAL_PORT:127.0.0.1:$SSH_PORT $USERNAME@$SSH_HOSTNAME
}

sshconfport() {
  # MIN NUM OF ARG
  if [[ "$#" < "3" ]]; then
    echo "Usage: sshconfport LOCAL_PORT SSH_HOSTNAME SSH_PORT [KEYS_NAME] [USERNAME] [SSH_CONFIG_ALIAS]" >&2
    return -1
  fi

  local LOCAL_PORT=$1
  local SSH_HOSTNAME=$2
  local REMOTE_PORT=$3
  local KEYS_NAME=${4:-$DEFAULT_KEYS_NAME}
  local USERNAME=${5:-$USER}
  local SSH_CONFIG_ALIAS=${6:-tunnel}

  sshconfusercreatekey ${SSH_CONFIG_ALIAS} ${USERNAME} ${KEYS_NAME} ${SSH_HOSTNAME}
  echo "  LocalForward ${LOCAL_PORT} 127.0.0.1:${REMOTE_PORT}"   >> $SSH_CONFIG

  FUNCTION_NAME="ssh${SSH_CONFIG_ALIAS}"
  TARGET_SERVICE_FILENAME=${LOCAL_SCRIPTS_FOLDER}/${FUNCTION_NAME}.bash
  echo "${FUNCTION_NAME}() {"             > $TARGET_SERVICE_FILENAME
  echo "  ssh -f -N ${SSH_CONFIG_ALIAS}"  >> $TARGET_SERVICE_FILENAME
  echo "}"                                >> $TARGET_SERVICE_FILENAME

  reload
  echo "== Enabling function '${FUNCTION_NAME}' at $TARGET_SERVICE_FILENAME =="
}

sshconfusercreatekey() {
  # MIN NUM OF ARG
  if [[ "$#" < "3" ]]; then
    echo "Usage: sshconfusercreatekey SSH_CONFIG_ALIAS USERNAME KEYS_NAME [SSH_HOSTNAME] [SSH_PORT]" >&2
    return -1
  fi

  local SSH_CONFIG_ALIAS=$1
#  local USERNAME=${2:-$USER}
  local USERNAME=$2
  local KEYS_NAME=${3:-$DEFAULT_KEYS_NAME}
  local SSH_HOSTNAME=$4
  local SSH_PORT=$5

  if [ ! -f "${SSH_ROOT}/${KEYS_NAME}" ]; then
    echo "== Since ${SSH_ROOT}/${KEYS_NAME} doesn't exist create a new one! ==" >&2
    sshkeysgen ${KEYS_NAME}
  fi

  sshconfuser $SSH_CONFIG_ALIAS $USERNAME $KEYS_PRI $SSH_HOSTNAME $SSH_PORT
}

sshconfuser() {
  # MIN NUM OF ARG
  if [[ "$#" < "2" ]]; then
    echo "Usage: sshconfuser SSH_CONFIG_ALIAS USERNAME [KEYS_PRI] [SSH_HOSTNAME] [SSH_PORT]" >&2
    return -1
  fi

  local SSH_CONFIG_ALIAS=$1
#  local USERNAME=${2:-$USER}
  local USERNAME=$2
  local KEYS_PRI=$3
  local SSH_HOSTNAME=$4
  local SSH_PORT=$5

  # Create .ssh if not exist
  sshmkdir
  echo "== Write file $SSH_CONFIG =="
  echo "sshconfuser $SSH_CONFIG_ALIAS $USERNAME $KEYS_PRI $SSH_HOSTNAME $SSH_PORT"

  echo "Host ${SSH_CONFIG_ALIAS}"     >> $SSH_CONFIG
  if [ -n "${SSH_HOSTNAME}" ]; then
    echo "  HostName ${SSH_HOSTNAME}" >> $SSH_CONFIG
  fi
  if [ -n "${SSH_PORT}" ]; then
    echo "  Port ${SSH_PORT}"         >> $SSH_CONFIG
  fi
  if [ -n "${USERNAME}" ]; then
    echo "  User ${USERNAME}"         >> $SSH_CONFIG
  fi
  if [ -f "${KEYS_PRI}" ]; then
    echo "  IdentityFile ${KEYS_PRI}" >> $SSH_CONFIG
  fi
}

sshproxyconf() {
  usage $# "SSH_CONFIG_ALIAS" "SSH_HOSTNAME" "FWD_HOSTNAME" "[FWD_PORT]" "[LOCAL_PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SSH_CONFIG_ALIAS=$1
  local SSH_HOSTNAME=$2
  local FWD_HOSTNAME=$3
  local FWD_PORT=${4:-22}

  local LOCAL_PORT=$5

  # Create .ssh if not exist
  sshmkdir
  echo "== Write file $SSH_CONFIG =="

  echo "Host ${SSH_CONFIG_ALIAS}"                             >> $SSH_CONFIG
  echo "  HostName ${SSH_HOSTNAME}"                           >> $SSH_CONFIG  
  echo "  ProxyCommand ssh ${FWD_HOSTNAME} -W %h:${FWD_PORT}" >> $SSH_CONFIG

  if [ -n "${LOCAL_PORT}" ]; then
    echo "  DynamicForward ${LOCAL_PORT}"                       >> $SSH_CONFIG
  fi
}

sshproxy() {
  usage $# "SSH_CONFIG_ALIAS" "SSH_HOSTNAME" "FWD_HOSTNAME" "[FWD_PORT]" "[LOCAL_PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SSH_CONFIG_ALIAS=$1
  local SSH_HOSTNAME=$2
  local FWD_HOSTNAME=$3
  local FWD_PORT=${4:-22}

  local LOCAL_PORT=$5

  if [ -n "${LOCAL_PORT}" ]; then
    local EXTRA_ARGS="-ND localhost:${LOCAL_PORT}"
  fi

  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts
  echo "Connecting to ${SSH_CONFIG_ALIAS} ${LOCAL_PORT}"
  ssh -o ProxyCommand="ssh -W %h:${FWD_PORT} ${FWD_HOSTNAME}" ${SSH_HOSTNAME}
  
  # ssh -J -D ${LOCAL_PORT} ${FWD_HOSTNAME}:${FWD_PORT} ${SSH_HOSTNAME}
}

sshproxync() {
  usage $# "SSH_CONFIG_ALIAS" "SSH_HOSTNAME" "FWD_HOSTNAME" "[FWD_PORT]" "[LOCAL_PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SSH_CONFIG_ALIAS=$1
  local SSH_HOSTNAME=$2
  local FWD_HOSTNAME=$3
  local FWD_PORT=${4:-22}

  local LOCAL_PORT=$5

  if [ -n "${LOCAL_PORT}" ]; then
    local EXTRA_ARGS="-ND localhost:${LOCAL_PORT}"
  fi

  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts
  echo "ssh ${EXTRA_ARGS} -o ProxyCommand="ssh ${FWD_HOSTNAME} nc %h ${FWD_PORT}" ${SSH_HOSTNAME}"
  ssh ${EXTRA_ARGS} -o ProxyCommand="ssh ${FWD_HOSTNAME} nc %h ${FWD_PORT}" ${SSH_HOSTNAME}
}

pushkey() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Usage: pushkey SSH_HOSTNAME [KEYS_NAME]. KEYS_NAME is optional and fix which public key to push" >&2
    return -1
  fi

  local SSH_HOSTNAME=$1
  local KEYS_NAME=${2:-$DEFAULT_KEYS_NAME}

  KEYS_PUB="${SSH_ROOT}/${KEYS_NAME}.pub"

  echo "ssh -o StrictHostKeyChecking=no ${SSH_HOSTNAME} 'mkdir -p ~/.ssh/'"
  ssh -o StrictHostKeyChecking=no ${SSH_HOSTNAME} 'mkdir -p ~/.ssh/'

  echo "scp -r ${KEYS_PUB} ${SSH_HOSTNAME}:${USR_KEYS}"
  scp -r ${KEYS_PUB} ${SSH_HOSTNAME}:${USR_KEYS}
}

pushkeyfolder() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Usage: pushkeyfolder SSH_HOSTNAME" >&2
    return -1
  fi

  local SSH_HOSTNAME=$1
  if [ -f "$USR_KEYS" ]; then
    echo "ssh -o StrictHostKeyChecking=no $USER@$SSH_HOSTNAME 'mkdir -p ~/.ssh/'"
    ssh -o StrictHostKeyChecking=no $USER@$SSH_HOSTNAME 'mkdir -p ~/.ssh/'
    
    trscppush $SSH_HOSTNAME $USR_KEYS "~/.ssh/"
  fi
}
