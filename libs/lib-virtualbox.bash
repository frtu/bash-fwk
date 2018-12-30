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
vboxinfo() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    echo "If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\"" >&2
    echo "" >&2
    vboxls -a
    return -1
  fi

  local IMAGE_NAME=$1
  echo "VBoxManage showvminfo ${IMAGE_NAME} --machinereadable"
  VBoxManage showvminfo ${IMAGE_NAME} --machinereadable
}

vboxstart() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    echo "If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\"" >&2
    echo "" >&2
    vboxls -a
    return -1
  fi

  local IMAGE_NAME=$1
  echo "VBoxManage startvm ${IMAGE_NAME} --type headless"
  VBoxManage startvm ${IMAGE_NAME} --type headless
}
vboxstop() {
  usage $# "IMAGE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    echo "If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\"" >&2
    echo "" >&2
    vboxls -a
    return -1
  fi

  local IMAGE_NAME=$1
  echo "VBoxManage controlvm ${IMAGE_NAME} poweroff"
  VBoxManage controlvm ${IMAGE_NAME} poweroff
}

#vboxcreate() {
#  usage $# "IMAGE_NAME" "BASE_FOLDER" "[CPU_NB]" "[MEMORY_MB]"
#  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
#  if [[ "$?" -ne 0 ]]; then return -1; fi
#
#  local IMAGE_NAME=$1
#  local BASE_FOLDER=$2
#  local CPU_NB=${3:-1}
#  local MEMORY_MB=${4:-1024}
#
#  echo "VBoxManage createvm --basefolder ${BASE_FOLDER}/${IMAGE_NAME} --name ${IMAGE_NAME}"
#  VBoxManage createvm --basefolder ${BASE_FOLDER}/${IMAGE_NAME} --name ${IMAGE_NAME}
#  #VBoxManage createvm --basefolder ${BASE_FOLDER}/${IMAGE_NAME} --name ${IMAGE_NAME} --r
#
#  echo "VBoxManage modifyvm ${IMAGE_NAME} --firmware bios --bioslogofadein off --bioslogofadeout off --bioslogodiiosbootmenu disabled --ostype Linux26_64 --cpus ${CPU_NB} --memory ${MEMORY_MB} --acpi on --ioapic on --rtcuseutc on --natdnshostresolver1 off --natdnsproxy1 on --cpuhotplug off -on --hwvirtex on --nestedpaging on --largepages on --vtxvpid on --accelerate3d off --boot1 dvd"
#  VBoxManage modifyvm ${IMAGE_NAME} --firmware bios --bioslogofadein off --bioslogofadeout off --bioslogodiiosbootmenu disabled --ostype Linux26_64 --cpus ${CPU_NB} --memory ${MEMORY_MB} --acpi on --ioapic on --rtcuseutc on --natdnshostresolver1 off --natdnsproxy1 on --cpuhotplug off -on --hwvirtex on --nestedpaging on --largepages on --vtxvpid on --accelerate3d off --boot1 dvd
#
#  echo "VBoxManage modifyvm ${IMAGE_NAME} --nic1 nat --nictype1 82540EM --cableconnected1 on"
#  VBoxManage modifyvm ${IMAGE_NAME} --nic1 nat --nictype1 82540EM --cableconnected1 on
#}
vboxstorage() {
  usage $# "IMAGE_NAME" "IMAGE_FILEPATH" "[PORT_NUMBER]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    echo "If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\"" >&2
    echo "" >&2
    vboxls -a
    return -1
  fi

  local IMAGE_NAME=$1
  local IMAGE_FILEPATH=$2
  local PORT_NUMBER=${3:-0}

  if [ ! -f "$IMAGE_FILEPATH" ]; then
    echo "File doesn't exist $IMAGE_FILEPATH"
    return -1
  fi

  echo "VBoxManage storagectl ${IMAGE_NAME} --name SATA --add sata --hostiocache on"
  VBoxManage storagectl ${IMAGE_NAME} --name SATA --add sata --hostiocache on

  extension="${IMAGE_FILEPATH##*.}"
  if [ "$extension" == "iso" ]; then
    echo "VBoxManage storageattach ${IMAGE_NAME} --storagectl SATA --port ${PORT_NUMBER} --device 0 --type dvddrive --medium ${IMAGE_FILEPATH}"
    VBoxManage storageattach ${IMAGE_NAME} --storagectl SATA --port ${PORT_NUMBER} --device 0 --type dvddrive --medium ${IMAGE_FILEPATH}
  fi
  if [ "$extension" == "vmdk" ]; then
    echo "VBoxManage storageattach ${IMAGE_NAME} --storagectl SATA --port ${PORT_NUMBER} --device 0 --type hdd --medium ${IMAGE_FILEPATH}"
    VBoxManage storageattach ${IMAGE_NAME} --storagectl SATA --port ${PORT_NUMBER} --device 0 --type hdd --medium ${IMAGE_FILEPATH}
  fi
}
vboxmemory() {
  usage $# "IMAGE_NAME" "MEMORY_MB"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local IMAGE_NAME=$1
  local MEMORY_MB=$2

  echo "VBoxManage modifyvm $IMAGE_NAME --memory $MEMORY_MB"
  VBoxManage modifyvm $IMAGE_NAME --memory $MEMORY_MB
}
vboxport() {
  usage $# "IMAGE_NAME" "PORT"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    echo "- IMAGE_NAME : see 'vboxls'" >&2
    echo "- PORT : Must be a number between 1024 < PORT < 65535!" >&2
    echo "" >&2
    echo "If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\"" >&2
    echo "" >&2
    vboxls -a
    return -1
  fi

  local IMAGE_NAME=$1
  local PORT=$2

  echo "== Mapping virtualbox image=$IMAGE_NAME port=$PORT => If port already exist, you can ignore VBoxManage raised exception=="
  echo "VBoxManage controlvm $IMAGE_NAME natpf1 \"tcp-port$PORT,tcp,,$PORT,,$PORT\";"
  #VBoxManage modifyvm $IMAGE_NAME natpf1 "tcp-port$PORT,tcp,,$PORT,,$PORT";
  VBoxManage controlvm $IMAGE_NAME natpf1 "tcp-port$PORT,tcp,,$PORT,,$PORT";
}
vboxnetdhcp() {
  echo "VBoxManage list dhcpservers"
  VBoxManage list dhcpservers
}
vboxnetls() {
  echo "VBoxManage list hostonlyifs"
  VBoxManage list hostonlyifs
}
vboxnetcreate() {
  echo "VBoxManage hostonlyif create"
  VBoxManage hostonlyif create
}
vboxnetrm() {
  usage $# "NETWORK_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    echo "If you don't know any names run 'vboxnetls'" >&2
    echo "" >&2
    vboxnetls
    return -1
  fi

  local NETWORK_NAME=$1
  echo "VBoxManage hostonlyif remove ${NETWORK_NAME}"
  VBoxManage hostonlyif remove ${NETWORK_NAME}
}
vboxnetconfig() {
  usage $# "NETWORK_NAME" "[IP]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    echo "If you don't know any names run 'vboxnetls'" >&2
    echo "" >&2
    vboxnetls
    return -1
  fi

  local NETWORK_NAME=$1
  local IP=${2:-192.168.99.1}
  echo "VBoxManage hostonlyif ipconfig ${NETWORK_NAME} --ip ${IP} --netmask 255.255.255.0"
  VBoxManage hostonlyif ipconfig ${NETWORK_NAME} --ip ${IP} --netmask 255.255.255.0
}
vboxsnapshot() {
  usage $# "IMAGE_NAME" "[SNAPSHOT_NAME]" "[SNAPSHOT_DESC]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then
    echo "If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\"" >&2
    echo "" >&2
    vboxls -a
    return -1
  fi

  local IMAGE_NAME=$1
  local SNAPSHOT_NAME=${2:-$1-snapshot}
  local SNAPSHOT_DESC=${3:-This is the snapshot of $1}
  echo "VBoxManage snapshot $IMAGE_NAME take $SNAPSHOT_NAME --description \"$SNAPSHOT_DESC\""
  VBoxManage snapshot $IMAGE_NAME take $SNAPSHOT_NAME --description "$SNAPSHOT_DESC"
}
vboxrmsoft() {
  usage $# "IMAGE_HASH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local IMAGE_HASH=$1
  echo "Only remove from VBox listing > VBoxManage unregistervm $IMAGE_HASH --delete"
  VBoxManage unregistervm $IMAGE_HASH --delete
}
