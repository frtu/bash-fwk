import lib-file-transfer
import lib-virtualbox
import lib-vm

VAGRANT_BOXES_FOLDER=~/.vagrant.d/boxes
VAGRANT_MACHINES_SUBFOLDER=./.vagrant/machines


# ==================================================
# Vagrant Box Administration
# ==================================================
# vagb : Vagrant box cmds https://www.vagrantup.com/docs/cli/box.html
# - vagbls : List all boxes in the catalog
# - vagbadd [_instance] : Add boxes
# - vagbrm [box catalog name] : Remove boxes from ls

# https://www.vagrantup.com/docs/boxes.html
# https://atlas.hashicorp.com/boxes/

vagbls() {
	# ls $VAGRANT_BOXES_FOLDER
	echo "=== Vagrant boxes catalog ==="
	vagrant box list
	echo ""
	echo "=> Remove any box from Catalog with 'vagbrm [box name]'"
}
vagbadd_win8() {
	# vagbadd Windows8 http://aka.ms/vagrant-win8-ie10 Win8.IE10.For.Vagrant.box
	vagbadd Windows81 http://aka.ms/vagrant-win81-ie11 Win8.1.IE11.For.Vagrant.box
}

vagbadd_aerospike() {
	# http://www.aerospike.com/docs/operations/install/vagrant/mac/
	# https://s3-us-west-1.amazonaws.com/aerospike-vagrant/previous_version/virtualbox/as_centos-6.6-x86_64.box
	# vagbadd aerospike/centos-6.5 https://atlas.hashicorp.com/aerospike/boxes/centos-6.5/versions/3.8.1/providers/virtualbox.box vagrant-aerospike-centos-6.5-3.8.1.box
	vagbadd aerospike/centos-6.5 https://atlas.hashicorp.com/aerospike/boxes/centos-6.5/versions/3.8.2.3/providers/virtualbox.box vagrant-aerospike-centos-6.5-3.8.2.3.box
}

vagbadd_centos_puppet() {
	vagbadd puppetlabs/centos-6.6-64-puppet https://atlas.hashicorp.com/puppetlabs/boxes/centos-6.6-64-puppet/versions/1.0.3/providers/virtualbox.box vagrant-puppetlabs-centos-6.6-64-1.0.3.box
}

vagbadd_docker() {
	vagbadd boot2docker https://atlas.hashicorp.com/hashicorp/boxes/boot2docker/versions/1.7.8/virtualbox.box vagrant-boot2docker-1.7.8.box
	# vagrant plugin install vagrant-docker-compose
}
vagbadd_centos() {
	vagbadd centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box vagrant-centos65-v6.5.3_64.box
}
vagbadd_ubuntu() {
	# vagbadd precise64 http://files.vagrantup.com/precise64.box
	#vagbadd precise64 https://atlas.hashicorp.com/hashicorp/boxes/precise64/versions/1.1.0/providers/virtualbox.box vagrant-ubuntu-precise64-1.1.0.box
	vagbadd ubuntu/trusty64 https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/20170810.0.0/providers/virtualbox.box vagrant-ubuntu-trusty64-20170810.box
}
vagbadd_ubuntu18() {
	vagbadd generic/ubuntu1804 https://vagrantcloud.com/generic/boxes/ubuntu1804/versions/2.0.4/providers/virtualbox.box vagrant-ubuntu1804-2.0.4.box
}

vagbadd_docker_centos() {
	vagbadd centos2docker https://atlas.hashicorp.com/blacklabelops/boxes/dockerdev/versions/1.0.5/providers/virtualbox.box vagrant-centos2docker-1.0.5.box
	# vagrant plugin install vagrant-docker-compose
}

vagbadd_docker_ubuntu_trusty() {
	vagrant plugin install vagrant-docker-compose
	vagbadd williamyeh/ubuntu-trusty64-docker https://vagrantcloud.com/williamyeh/boxes/ubuntu-trusty64-docker/versions/1.12.1.20160830/providers/virtualbox.box vagrant-williamyeh--ubuntu-trusty64-docker-1.12.1.20160830.box
}

vagbadd_docker_ubuntu() {
	BOX_FILENAME=$VM_ARCHIVE_FOLDER/docker-ubuntu-trusty64.box
	BOX_NAME=docker-ubuntu-trusty64

	echo "vagrant box add $BOX_NAME $BOX_FILENAME"
	vagrant box add $BOX_NAME $BOX_FILENAME

	echo "vagrant init $BOX_NAME"
	vagrant init $BOX_NAME
}

vagbadd() {
  usage $# "BOX_NAME" "[BOX_URL]" "[BOX_FILENAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local BOX_NAME=$1
  local BOX_URL=$2

  if [ -z "$3" ]; then
    local BOX_FILENAME=$VM_ARCHIVE_FOLDER/$1.box
  else
    local BOX_FILENAME=$VM_ARCHIVE_FOLDER/$3
  fi

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

  echo "vagrant box add $BOX_NAME $BOX_FILENAME --force"
  vagrant box add $BOX_NAME $BOX_FILENAME --force

  echo "vagrant init $BOX_NAME"
  vagrant init $BOX_NAME
}
vagbrm() {
	if [ $# -eq 0 ]; then
      echo "Please add the name of the box to remove with 'vagbrm [BOX_NAME]'"
	  echo "=== Vagrant boxes catalog ==="
      vagrant box list
      return
  	fi
  	vagrant box remove $1
}

# ==================================================
# Vagrant install and usage
# ==================================================
vagls() {
	vagrant global-status --prune

	if [[ -d $VAGRANT_MACHINES_SUBFOLDER ]]; then
		echo "== List local vagrant name =="
		ls $VAGRANT_MACHINES_SUBFOLDER
	fi
}

vaginst_script() {
	INSTALL_SCRIPT="curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash"
    echo "CALL : root@vagrant> $INSTALL_SCRIPT"
	vagssh "$($INSTALL_SCRIPT)"
}
vagenabledocker() {
	vagssh "echo 'import "lib-docker"' > ~/scr-local/service-docker.bash"
}

vagstart() {
	vagtemplate "up"
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
}

vagtemplate() {
  if [ ! -f Vagrantfile ]; then
    echo "Please run this command in a folder containing Vagrantfile."
    echo "- Create one using cmd > vagbadd_xx"
    echo "- Go to an existing folder looking at the last column directory."
    vagrant global-status --prune
    return -1
  fi

  echo "vagrant $1"
  vagrant $1
}
# https://www.hashicorp.com/blog/feature-preview-vagrant-1-6-docker-dev-environments.html
