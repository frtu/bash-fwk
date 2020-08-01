import lib-file-transfer
import lib-virtualbox
import lib-vm

VAGRANT_BOXES_FOLDER=~/.vagrant.d/boxes

VAGRANT_MACHINES_SUBFOLDER=./.vagrant/machines
VAGRANT_VBOX_SUBFOLDER=$VAGRANT_MACHINES_SUBFOLDER/default/virtualbox

# ==================================================
# Vagrant Box Administration
# ==================================================
# vagb : Vagrant box cmds https://www.vagrantup.com/docs/cli/box.html
# - vagbls : List all boxes in the catalog
# - vagbadd [_instance] : Add boxes
# - vagbrm [box catalog name] : Remove boxes from ls

# https://www.vagrantup.com/docs/boxes.html
# https://atlas.hashicorp.com/boxes/
cdvagb() {
  cd $VAGRANT_BOXES_FOLDER
}
vagbls() {
	# ls $VAGRANT_BOXES_FOLDER
	echo "=== Vagrant boxes catalog ==="
	vagrant box list
	echo ""
	echo "=> Remove any box from Catalog with 'vagbrm [box name]'"
}
vagbadd_win8() {
	# vagbadd Windows8 Win8.IE10.For.Vagrant.box http://aka.ms/vagrant-win8-ie10
	vagbadd Windows81 Win8.1.IE11.For.Vagrant.box http://aka.ms/vagrant-win81-ie11
}

vagbadd_aerospike() {
	# http://www.aerospike.com/docs/operations/install/vagrant/mac/
	# https://s3-us-west-1.amazonaws.com/aerospike-vagrant/previous_version/virtualbox/as_centos-6.6-x86_64.box
	vagbadd aerospike/centos-6.5 vagrant-aerospike-centos-6.5-3.8.2.3.box https://atlas.hashicorp.com/aerospike/boxes/centos-6.5/versions/3.8.2.3/providers/virtualbox.box
}

vagbadd_centos_puppet() {
	vagbadd puppetlabs/centos-6.6-64-puppet vagrant-puppetlabs-centos-6.6-64-1.0.3.box https://atlas.hashicorp.com/puppetlabs/boxes/centos-6.6-64-puppet/versions/1.0.3/providers/virtualbox.box
}

vagbadd_docker() {
	vagbadd boot2docker vagrant-boot2docker-1.7.8.box https://atlas.hashicorp.com/hashicorp/boxes/boot2docker/versions/1.7.8/virtualbox.box
	# vagrant plugin install vagrant-docker-compose
}
vagbadd_centos() {
	vagbadd centos65 vagrant-centos65-v6.5.3_64.box https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box
}
vagbadd_centos7() {
  vagbadd centos/7 CentOS-7-x86_64-Vagrant-1905_01.VirtualBox.box https://vagrantcloud.com/centos/boxes/7/versions/1905.1/providers/virtualbox.box
}
vagbadd_centos8() {
  vagbadd centos/8 CentOS-8-Vagrant-8.0.1905-1.x86_64.vagrant-virtualbox.box https://vagrantcloud.com/centos/boxes/8/versions/1905.1/providers/virtualbox.box
}

vagbadd_ubuntu() {
	# vagbadd precise64 http://files.vagrantup.com/precise64.box
	#vagbadd precise64 https://atlas.hashicorp.com/hashicorp/boxes/precise64/versions/1.1.0/providers/virtualbox.box vagrant-ubuntu-precise64-1.1.0.box
	vagbadd ubuntu/trusty64 vagrant-ubuntu-trusty64-20170810.box https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/20170810.0.0/providers/virtualbox.box
}
vagbadd_ubuntu18() {
  #vagbadd generic/ubuntu1804 vagrant-ubuntu1804-2.0.4.box https://vagrantcloud.com/generic/boxes/ubuntu1804/versions/2.0.4/providers/virtualbox.box
  vagbadd bento/ubuntu-18.04 vagrant-ubuntu1804-202005-21-0.box https://vagrantcloud.com/bento/boxes/ubuntu-18.04/versions/202005.21.0/providers/virtualbox.box
}

vagbadd_docker_centos() {
	vagbadd williamyeh/centos7-docker vagrant-williamyeh-centos7-docker-1.0.5.box https://vagrantcloud.com/williamyeh/boxes/centos7-docker/versions/1.12.1.20160830/providers/virtualbox.box
	# vagrant plugin install vagrant-docker-compose
}

vagbadd_docker_ubuntu_trusty() {
	vagrant plugin install vagrant-docker-compose
	vagbadd williamyeh/ubuntu-trusty64-docker vagrant-williamyeh--ubuntu-trusty64-docker-1.12.1.20160830.box https://vagrantcloud.com/williamyeh/boxes/ubuntu-trusty64-docker/versions/1.12.1.20160830/providers/virtualbox.box
}

vagbadd_docker_ubuntu() {
	BOX_FILENAME=$VM_ARCHIVE_FOLDER/docker-ubuntu-trusty64.box
	vagbadd "docker-ubuntu-trusty64" $BOX_FILENAME
}

vagbadd() {
  usage $# "BOX_NAME" "[BOX_FILENAME]" "[BOX_URL]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local BOX_NAME=$1
  local BOX_FILENAME=$2
  local BOX_URL=$3

  if [ ! -f "$BOX_FILENAME" ]; then
    if [ -z "$BOX_FILENAME" ]; then
      local BOX_FILENAME=$VM_ARCHIVE_FOLDER/$1.box
    else
      local BOX_FILENAME=$VM_ARCHIVE_FOLDER/$2
    fi
  fi

  if [ -n "$BOX_URL" ]; then
    # Download file ONLY if it doesn't exist
    if [ ! -f $BOX_FILENAME ]; then
      mkdir -p $VM_ARCHIVE_FOLDER
      if [ -n "$SKIP" ]
        then
         trwgetlazy $BOX_FILENAME $BOX_URL
        else
         trwgetsafe $BOX_FILENAME $BOX_URL
      fi
    else
      echo "Vagrant Box file exist, use this one $BOX_FILENAME"
    fi
  fi

  echo "vagrant box add $BOX_NAME $BOX_FILENAME --force"
  vagrant box add $BOX_NAME $BOX_FILENAME --force

  echo "vagrant init $BOX_NAME"
  vagrant init $BOX_NAME
}
vagbrm() {
  usage $# "BOX_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
	if [ $# -eq 0 ]; then
    echo "Please add the name of the box to remove with 'vagbrm [BOX_NAME]'" >&2
	  echo "=== Vagrant boxes catalog ===" >&2
    vagrant box list
    return
  fi

  local BOX_NAME=$1
  echo "vagrant box remove $BOX_NAME"
  vagrant box remove $BOX_NAME

  vagbls
}

# ==================================================
# Vagrant install and usage
# ==================================================
cdvag() {
  cd $VAGRANT_MACHINES_SUBFOLDER
}

vagls() {
	vagrant global-status --prune

	if [[ -d $VAGRANT_MACHINES_SUBFOLDER ]]; then
		echo "== List local vagrant name =="
		ls $VAGRANT_MACHINES_SUBFOLDER
	fi
}
vaginst_vbguest() {
  usage $# "[COMMAND:install|update|repair]"

  local COMMAND=${1:-install}
  vagrant plugin ${COMMAND} vagrant-vbguest
}

vaginst_fwk() {
  INSTALL_SCRIPT="curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash"

  echo "CALL : root@vagrant> $INSTALL_SCRIPT"
  vagssh "$($INSTALL_SCRIPT)"
}
alias vagfwkinst='vaginst_fwk'
vagfwkmount() {
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  vboxmountfwk ${INSTANCE_NAME} /home/vagrant
}

vagstart() {
	vagtemplate "up"
}
vagprovision() {
  vagtemplate "provision"
}
vagstop() {
	vagtemplate "halt"
}
vagssh() {
  if [ -z "$1" ]
    then
      vagtemplate "ssh"
    else
      echo "CALL : root@$IMAGE_NAME> $@"
      echo "$@" | vagtemplate "ssh"
  fi
}
vagrm() {
	vagtemplate "destroy"

  vboxls
}
vagtemplate() {
  if [ ! -f Vagrantfile ]; then
    echo "Please run this command in a folder containing Vagrantfile." >&2
    echo "- Create one using cmd > vagbadd_xx" >&2
    echo "- Go to an existing folder looking at the last column directory." >&2
    vagls
    return -1
  fi

  echo "vagrant $@"
  vagrant $@
}

vagexport() {
  usage $# "[BOX_NAME]" "[BOX_FILENAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local BOX_NAME=$1
  local BOX_FILENAME=$2

  #if [[ -f Vagrantfile ]]; then
  #  local EXTRA_PARAMS="$EXTRA_PARAMS --vagrantfile Vagrantfile"
  #fi
  if [[ -n "$BOX_NAME" ]]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS --base $BOX_NAME"
    elif [[ ! -f Vagrantfile ]]; then
      usage $# "BOX_NAME" "[BOX_FILENAME:package.box]"
      ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
      echo "If you don't know any names run 'vboxls' and look at the first column \"VBOX_INST_NAMES\"" >&2
      echo "" >&2
      vboxls -a
      return -1
  fi
  if [ -n "$BOX_FILENAME" ]
    then
      local EXTRA_PARAMS="$EXTRA_PARAMS --output ${BOX_FILENAME}"
    elif [[ -n "$BOX_NAME" ]]; then
      local EXTRA_PARAMS="$EXTRA_PARAMS --output ${BOX_NAME}.box"
  fi

  echo "vagrant package $EXTRA_PARAMS"
  vagrant package $EXTRA_PARAMS
}
vagexportkeyvbox() {
  if [[ ! -f "$VAGRANT_VBOX_SUBFOLDER/private_key" ]]; then
    echo "Cannot find key at : $VAGRANT_VBOX_SUBFOLDER/private_key" >&2
    return -1
  fi

  cp $VAGRANT_VBOX_SUBFOLDER/private_key .
  echo "Succesfully copy key locally : ${PWD}/private_key"
}
vagimportkeyvbox() {
  if [[ ! -f "private_key" ]]; then
    echo "Cannot find key at : ./private_key" >&2
    return -1
  fi
  
  mkdir -p $VAGRANT_VBOX_SUBFOLDER
  cp private_key $VAGRANT_VBOX_SUBFOLDER
  echo "Succesfully copy key locally : ${VAGRANT_VBOX_SUBFOLDER}/private_key"
}

vagenabledocker() {
  vagssh "echo 'import "lib-docker"' > ~/scr-local/service-docker.bash"
}
# https://www.hashicorp.com/blog/feature-preview-vagrant-1-6-docker-dev-environments.html
