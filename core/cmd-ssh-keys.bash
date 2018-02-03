import lib-file-transfer

USR_KEYS="$HOME/.ssh/authorized_keys"

SSH_CONFIG_BASE="/etc/ssh/ssh_config"

SSH_ROOT="$HOME/.ssh"
SSH_CONFIG="$HOME/.ssh/config"

DEFAULT_KEYS_PRI="$HOME/.ssh/id-rsa"
DEFAULT_KEYS_PUB="$KEYS_PRI.pub"

sshgenkey() {
  ssh-keygen -f -t rsa -b 4096 -C "$1"     
}

sshmkdir() {
  mkdir -p $SSH_ROOT
  chmod 700 $SSH_ROOT
}
sshcd() {
  cd $SSH_ROOT
}

sshconfuser() {
  # MIN NUM OF ARG
  if [[ "$#" < "2" ]]; then
    echo "Usage: sshconfuser SSH_HOST_ALIAS SSH_HOSTNAME" >&2
    return -1
  fi

  local SSH_HOST_ALIAS=$1
  local SSH_HOSTNAME=$2
#  local USERNAME=${3:-$USER}
  local USERNAME=$3
#  local KEYS_PRI=${4:-$DEFAULT_KEYS_PRI}
  local KEYS_PRI=$4

  echo "Host ${SSH_HOST_ALIAS}"     >> $SSH_CONFIG
  echo "  HostName ${SSH_HOSTNAME}" >> $SSH_CONFIG
#  echo "#  Port NUMBER_TO_SET"    >> $SSH_CONFIG
  
  if [ -n "${USERNAME}" ]; then
    echo "  User ${USERNAME}"    >> $SSH_CONFIG
  fi
  if [ -f "${KEYS_PRI}" ]; then
    echo "  IdentityFile ${KEYS_PRI}"    >> $SSH_CONFIG
  fi
}

sshconfproxy() {
  # MIN NUM OF ARG
  if [[ "$#" < "4" ]]; then
    echo "Usage: sshconfproxy SSH_HOST_ALIAS SSH_HOSTNAME LOCAL_PORT FWD_HOSTNAME [FWD_PORT]" >&2
    return -1
  fi

  local SSH_HOST_ALIAS=$1
  local SSH_HOSTNAME=$2
  local LOCAL_PORT=$3
  local FWD_HOSTNAME=$4
  local FWD_PORT=${5:-22}

  echo "Host ${SSH_HOST_ALIAS}"                               >> $SSH_CONFIG
  echo "  HostName ${SSH_HOSTNAME}"                           >> $SSH_CONFIG  
  echo "  ProxyCommand ssh ${FWD_HOSTNAME} -W %h:${FWD_PORT}" >> $SSH_CONFIG
  echo "  DynamicForward ${LOCAL_PORT}"                       >> $SSH_CONFIG
}

pushkey() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Usage: pushkey SSH_HOSTNAME [KEYS_PUB]. KEYS_PUB is optional and fix which public key to push" >&2
    return -1
  fi

  local SSH_HOSTNAME=$1
  local KEYS_PUB=${2:-$DEFAULT_KEYS_PUB}

  echo "scp -r $KEYS_PUB $SSH_HOSTNAME:$USR_KEYS"
  scp -r $KEYS_PUB $SSH_HOSTNAME:$USR_KEYS
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
