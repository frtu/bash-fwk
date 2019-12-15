import lib-file-transfer

# ATTENTION MUST BE ~ since remote may have different path
AUTH_KEYS="~/.ssh/authorized_keys"

SSH_CONFIG_BASE="/etc/ssh/ssh_config"

SSH_ROOT="$HOME/.ssh"
SSH_CONFIG="$HOME/.ssh/config"

DEFAULT_KEY_NAME="id_rsa"
DEFAULT_KEY_PRI="${SSH_ROOT}/${DEFAULT_KEY_NAME}"
DEFAULT_KEY_PUB="$DEFAULT_KEY_PRI.pub"

sshcd() {
  cd $SSH_ROOT
}
# Useful when manually creating authorized_keys or ssh_config
sshmkdir() {
  if [ ! -d "${SSH_ROOT}" ]; then
    echo "== Create non existing folder : $SSH_ROOT =="
    mkdir -p $SSH_ROOT
    chmod 700 $SSH_ROOT
  fi
}

# Keys management
sshkeysgen() {
  local KEY_NAME=${1:-$DEFAULT_KEY_NAME}

  KEY_PRI="${SSH_ROOT}/${KEY_NAME}"

  echo "ssh-keygen -t rsa -b 4096 -f $KEY_PRI"
  ssh-keygen -t rsa -b 4096 -f $KEY_PRI
}
sshkeysls() {
  echo "Listing keys available in $SSH_ROOT"

  for file in $SSH_ROOT/*.pub ; do 
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    echo "- $filename"
  done
}
sshkeyscp() {
  usage $# "KEY_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "-- To list all key names run 'sshkeysls' --" >&2
    sshkeysls
    return -1
  fi

  local KEY_NAME=${1:-$DEFAULT_KEY_NAME}

  KEY_PUB="${SSH_ROOT}/${KEY_NAME}.pub"

  echo "pbcopy < $KEY_PUB"
  pbcopy < $KEY_PUB
}
sshkeyspush() {
  usage $# "SSH_HOSTNAME" "[KEY_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "-- To list all key names run 'sshkeysls' --" >&2
    sshkeysls
    return -1
  fi

  local SSH_HOSTNAME=$1
  local KEY_NAME=${2:-$DEFAULT_KEY_NAME}

  KEY_PUB="${SSH_ROOT}/${KEY_NAME}.pub"

  echo "ssh -o StrictHostKeyChecking=no ${SSH_HOSTNAME} 'mkdir -p ~/.ssh/'"
  ssh -o StrictHostKeyChecking=no ${SSH_HOSTNAME} 'mkdir -p ~/.ssh/'

  echo "scp -r ${KEY_PUB} ${SSH_HOSTNAME}:${AUTH_KEYS}"
  scp -r ${KEY_PUB} ${SSH_HOSTNAME}:${AUTH_KEYS}
}
sshkeyspushpair() {
  usage $# "SSH_HOSTNAME" "[KEY_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "-- To list all key names run 'sshkeysls' --" >&2
    sshkeysls
    return -1
  fi

  local SSH_HOSTNAME=$1
  local KEY_NAME=${2:-$DEFAULT_KEY_NAME}

  sshkeyspush ${SSH_HOSTNAME} ${KEY_NAME}

  KEY_PRI="${SSH_ROOT}/${KEY_NAME}"
  echo "scp ${KEY_PRI} ${SSH_HOSTNAME}:~/.ssh/${KEY_NAME}"
  scp ${KEY_PRI} ${SSH_HOSTNAME}:~/.ssh/${KEY_NAME}
}
sshkeyspushlocalauth() {
  usage $# "SSH_HOSTNAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SSH_HOSTNAME=$1
  if [ -f "$AUTH_KEYS" ]; then
    echo "ssh -o StrictHostKeyChecking=no $USER@$SSH_HOSTNAME 'mkdir -p ~/.ssh/'"
    ssh -o StrictHostKeyChecking=no $USER@$SSH_HOSTNAME 'mkdir -p ~/.ssh/'
    
    trscppush $SSH_HOSTNAME $AUTH_KEYS "~/.ssh/"
  fi
}

# Connect
sshkey() {
  usage $# "SSH_HOSTNAME" "[KEY_NAME]" "[USERNAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "-- To list all key names run 'sshkeysls' --" >&2
    sshkeysls
    return -1
  fi

  local SSH_HOSTNAME=$1
  local KEY_NAME=${2:-$DEFAULT_KEY_NAME}
  local USERNAME=$3

  KEY_PRI="${SSH_ROOT}/${KEY_NAME}"
  if [ ! -f "${KEY_PRI}" ]; then
    echo "-- Key '${KEY_PRI}' not found try this command to list available keys 'sshkeysls' --" >&2
    sshkeysls
    return -1
  fi

  if [ -n "${USERNAME}" ]; then
    SSH_HOSTNAME=${USERNAME}@${SSH_HOSTNAME}
  fi

  echo "ssh -i ${KEY_PRI} ${SSH_HOSTNAME}"
  ssh -i ${KEY_PRI} ${SSH_HOSTNAME}
}

## Config management
sshconfuser() {
  usage $# "SSH_CONFIG_ALIAS" "SSH_HOSTNAME" "[KEY_NAME]" "[USERNAME]" "[SSH_PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "-- To list all key names run 'sshkeysls' --" >&2
    sshkeysls
    return -1
  fi

  local SSH_CONFIG_ALIAS=$1
  local SSH_HOSTNAME=$2
  local KEY_NAME=${3:-$DEFAULT_KEY_NAME}
#  local USERNAME=${4:-$USER}
  local USERNAME=$4
  local SSH_PORT=$5

  KEY_PRI="${SSH_ROOT}/${KEY_NAME}"
  if [ ! -f "${KEY_PRI}" ]; then
    echo "-- Key '${KEY_PRI}' not found try this command to list available keys 'sshkeysls' --" >&2
    sshkeysls
    return -1
  fi

  # Create .ssh if not exist
  sshmkdir
  echo "== Write file $SSH_CONFIG =="

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
  if [ -f "${KEY_PRI}" ]; then
    echo "  IdentityFile ${KEY_PRI}" >> $SSH_CONFIG
  fi
}
sshconfusercreatekey() {
  usage $# "SSH_CONFIG_ALIAS" "SSH_HOSTNAME" "KEY_NAME" "[USERNAME]" "[SSH_PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SSH_CONFIG_ALIAS=$1
  local SSH_HOSTNAME=$2
  local KEY_NAME=${3:-$DEFAULT_KEY_NAME}
  local USERNAME=$4
  local SSH_PORT=$5

  KEY_PRI="${SSH_ROOT}/${KEY_NAME}"
  if [ ! -f "${KEY_PRI}" ]; then
    echo "== Since ${KEY_PRI} doesn't exist create a new one! ==" >&2
    sshkeysgen ${KEY_NAME}
  fi

  sshconfuser $SSH_CONFIG_ALIAS $SSH_HOSTNAME $KEY_NAME $USERNAME $SSH_PORT
}

# Port forwarding
sshproxy() {
  usage $# "SSH_HOSTNAME" "FWD_HOSTNAME" "[FWD_PORT]" "[LOCAL_PORT]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SSH_HOSTNAME=$1
  local FWD_HOSTNAME=$2
  local FWD_PORT=${3:-22}
  local LOCAL_PORT=$4

  if [ -n "${LOCAL_PORT}" ]; then
    # -D : open on a local port for distant forward
    local EXTRA_PARAMS="-ND localhost:${LOCAL_PORT}"
  fi

  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#Jump_Hosts_--_Passing_Through_a_Gateway_or_Two
  echo "Connecting to ${SSH_HOSTNAME} ${FWD_HOSTNAME}"
  # -W : stdio forwarding
  ssh -o ProxyCommand="ssh -W %h:${FWD_PORT} ${FWD_HOSTNAME}" ${SSH_HOSTNAME}
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
  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#Passing_Through_a_Gateway_Using_stdio_Forwarding_(Netcat_Mode)
  
  if [ -n "${LOCAL_PORT}" ]; then
    echo "  DynamicForward ${LOCAL_PORT}"                       >> $SSH_CONFIG
  fi
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
    # https://network23.org/inputisevil/2015/09/05/dynamic-port-forwarding-with-ssh-and-socks5/#2e9f
    echo ">> ATTENTION -N stops SSH from executing commands! Prompt is deactivated!"
    # -D : open on a local port for distant forward
    local EXTRA_PARAMS="-D ${LOCAL_PORT}"
  fi

  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#ProxyCommand_with_Netcat
  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#Jump_Hosts_--_Passing_Through_a_Gateway_or_Two
  echo "ssh ${EXTRA_PARAMS} -o ProxyCommand="ssh ${FWD_HOSTNAME} nc %h ${FWD_PORT}" ${SSH_HOSTNAME}"
  ssh ${EXTRA_PARAMS} -o ProxyCommand="ssh ${FWD_HOSTNAME} nc %h ${FWD_PORT}" ${SSH_HOSTNAME}
}
sshproxyconftunnel() {
  usage $# "LOCAL_PORT" "SSH_HOSTNAME" "SSH_PORT" "[KEY_NAME]" "[USERNAME]" "[SSH_CONFIG_ALIAS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi


  local LOCAL_PORT=$1
  local SSH_HOSTNAME=$2
  local REMOTE_PORT=$3
  local KEY_NAME=${4:-$DEFAULT_KEY_NAME}
  local USERNAME=${5:-$USER}
  local SSH_CONFIG_ALIAS=${6:-tunnel}

  sshconfusercreatekey ${SSH_CONFIG_ALIAS} ${SSH_HOSTNAME} ${KEY_NAME} ${USERNAME}
  echo "  LocalForward ${LOCAL_PORT} 127.0.0.1:${REMOTE_PORT}"   >> $SSH_CONFIG

  FUNCTION_NAME="ssh${SSH_CONFIG_ALIAS}"
  TARGET_SERVICE_FILENAME=${LOCAL_SCRIPTS_FOLDER}/${FUNCTION_NAME}.bash
  echo "${FUNCTION_NAME}() {"             > $TARGET_SERVICE_FILENAME
  echo "  ssh -f -N ${SSH_CONFIG_ALIAS}"  >> $TARGET_SERVICE_FILENAME
  echo "}"                                >> $TARGET_SERVICE_FILENAME

  refresh
  echo "== Enabling function '${FUNCTION_NAME}' at $TARGET_SERVICE_FILENAME =="
}

sshproxysocks() {
  usage $# "LOCAL_PORT" "SSH_HOSTNAME" "FWD_PORT" "[USERNAME]" "[FWD_HOSTNAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local LOCAL_PORT=$1
  local SSH_HOSTNAME=$2
  local FWD_PORT=$3
  local USERNAME=${4:-$USER}
  local FWD_HOSTNAME=${5:-127.0.0.1}

  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#Port_Forwarding_Via_a_Single_Intermediate_Host
  # Forward LOCAL_PORT -> SSH_HOSTNAME (intermediate) -> FWD_HOSTNAME (target behind fw)
  echo "ssh -f -N -L ${LOCAL_PORT}:${FWD_HOSTNAME}:${FWD_PORT} ${USERNAME}@${SSH_HOSTNAME}"
  ssh -f -N -L ${LOCAL_PORT}:${FWD_HOSTNAME}:${FWD_PORT} ${USERNAME}@${SSH_HOSTNAME}

  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#SOCKS_Proxy_Via_a_Single_Intermediate_Host
  # ssh -D ${LOCAL_PORT} -J ${FWD_HOSTNAME}:${FWD_PORT} ${SSH_HOSTNAME}
}
sshproxysocksconnect() {
  echo "Use the previously port configured with sshproxysocks()"
  usage $# "LOCAL_PORT" "[USERNAME]" "[FWD_HOSTNAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local LOCAL_PORT=$1
  local USERNAME=${2:-$USER}
  local FWD_HOSTNAME=${3:-127.0.0.1}

  # https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#Port_Forwarding_Via_a_Single_Intermediate_Host
  # Forward LOCAL_PORT -> SSH_HOSTNAME (intermediate) -> FWD_HOSTNAME (target behind fw)
  echo "ssh -p ${LOCAL_PORT} ${USERNAME}@${SSH_HOSTNAME}"
  ssh -p ${LOCAL_PORT} ${USERNAME}@${SSH_HOSTNAME}
}

