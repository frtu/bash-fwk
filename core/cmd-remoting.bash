import lib-file-transfer

USR_KEYS=~/.ssh/authorized_keys

pushcore() {
  if [ $# -eq 0 ]; then
    echo "Please profide a fully qualified hostname as first parameter!"
    return 1
  fi

  if [ -f "$USR_KEYS" ]; then
    echo "ssh -o StrictHostKeyChecking=no $USER@$1 'mkdir -p ~/.ssh/'"
    ssh -o StrictHostKeyChecking=no $USER@$1 'mkdir -p ~/.ssh/'
    
    trscppush $1 $USR_KEYS "~/.ssh/"
  fi
  trscppush $1 ~/.bash_profile "~/"
}
