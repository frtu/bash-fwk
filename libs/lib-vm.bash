VM_ROOT_FOLDER=~/VMs
VM_ARCHIVE_FOLDER=$VM_ROOT_FOLDER/_archives_

cdvm() {
  mkdir -p $VM_ROOT_FOLDER
  cd $VM_ROOT_FOLDER
}
mkvm() {
  mkdir -p $VM_ARCHIVE_FOLDER	
}
