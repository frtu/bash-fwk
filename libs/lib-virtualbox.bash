# https://www.virtualbox.org/manual/ch08.html
vboxls() {
  if [ "$1" == "-a" ]
    then
      echo "List ALL VMs > VBoxManage list vms"
      VBoxManage list vms
    else
      echo "List all RUNNING VMs (for all VMs use -a)> VBoxManage list runningvms"
      VBoxManage list runningvms
  fi
}

vboxstart() {
  if [ $# -eq 0 ]; then
    echo "Please specify parameters > 'vboxstart IMAGE_NAME'. If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\""
    echo ""
    vboxls
    return -1
  fi
  echo "VBoxManage startvm $1 --type headless"
  VBoxManage startvm $1 --type headless
}
vboxstop() {
  if [ $# -eq 0 ]; then
    echo "Please specify parameters > 'vboxstop IMAGE_NAME'. If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\""
    echo ""
    vboxls
    return -1
  fi
  echo "VBoxManage controlvm $1 poweroff"
  VBoxManage controlvm $1 poweroff
}

vboxmemory() {
  if [ -z "$1" ]; then
    echo "Please specify IMAGE_NAME parameter > 'vboxmemory IMAGE_NAME MEMORY_MB'. If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\""
    echo ""
    vboxls
    return -1
  fi
  if [ -z "$2" ]; then
    echo "Please specify MEMORY_MB parameter > 'vboxmemory IMAGE_NAME MEMORY_MB' in MB"
    return -1
  fi

  local IMAGE_NAME=$1
  local MEMORY_MB=$2

  VBoxManage modifyvm $IMAGE_NAME --memory $MEMORY_MB
}
vboxport() {
  if [ -z "$1" ]; then
    echo "Please specify IMAGE_NAME parameter > 'vboxport IMAGE_NAME PORT'. If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\""
    echo ""
    vboxls
    return -1
  fi
  if [ -z "$2" ]; then
    echo "Please specify PORT parameter > 'vboxport IMAGE_NAME PORT'. Must be a number between 1024 < PORT < 65535!"
    return -1
  fi

  local IMAGE_NAME=$1
  local PORT=$2

  echo "== Mapping virtualbox image=$IMAGE_NAME port=$PORT => If port already exist, you can ignore VBoxManage raised exception=="
  echo "VBoxManage controlvm $IMAGE_NAME natpf1 \"tcp-port$PORT,tcp,,$PORT,,$PORT\";"
  #VBoxManage modifyvm $IMAGE_NAME natpf1 "tcp-port$PORT,tcp,,$PORT,,$PORT";
  VBoxManage controlvm $IMAGE_NAME natpf1 "tcp-port$PORT,tcp,,$PORT,,$PORT";
}
vboxsnapshot() {
  if [ $# -eq 0 ]; then
    echo "Please specify parameters > 'vboxsnapshot IMAGE_NAME [SNAPSHOT_NAME] [SNAPSHOT_DESC]'. If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\""
    echo ""
    vboxls
    return -1
  fi

  local IMAGE_NAME=$1
  local SNAPSHOT_NAME=${2:-$1-snapshot}
  local SNAPSHOT_DESC=${3:-This is the snapshot of $1}
  echo "VBoxManage snapshot $IMAGE_NAME take $SNAPSHOT_NAME --description \"$SNAPSHOT_DESC\""
  VBoxManage snapshot $IMAGE_NAME take $SNAPSHOT_NAME --description "$SNAPSHOT_DESC"
}

vboxrmsoft() {
  if [ $# -eq 0 ]; then
    echo "Please specify parameters > 'vboxrm IMAGE_HASH'. If you don't know any names run 'vboxls' and look at the first column \{INST_HASH\}"
    echo ""
    vboxls
    return -1
  fi

  local IMAGE_HASH=$1
  
  echo "Only remove from VBox listing > VBoxManage unregistervm $IMAGE_HASH --delete"
  VBoxManage unregistervm $IMAGE_HASH --delete
}
