import lib-file-transfer

USR_KEYS=~/.ssh/authorized_keys

genkey() {
  ssh-keygen -f -t rsa -b 4096 -C "$1"     
}

pushkey() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Please profide a fully qualified hostname as first parameter!"
    return -1
  fi

  echo "scp -r ~/.ssh/id_rsa.pub $1:$USR_KEYS"
  scp -r ~/.ssh/id_rsa.pub $1:$USR_KEYS
}

pushkeyfolder() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "Please profide a fully qualified hostname as first parameter!"
    return -1
  fi

  if [ -f "$USR_KEYS" ]; then
    echo "ssh -o StrictHostKeyChecking=no $USER@$1 'mkdir -p ~/.ssh/'"
    ssh -o StrictHostKeyChecking=no $USER@$1 'mkdir -p ~/.ssh/'
    
    trscppush $1 $USR_KEYS "~/.ssh/"
  fi
}
