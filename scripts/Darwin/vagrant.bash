import lib-download


VAGRANT_BOXES_FOLDER=~/.vagrant.d/boxes
VAGRANT_MACHINES_SUBFOLDER=./.vagrant/machines

VM_ROOT_FOLDER=~/VMs
VM_ARCHIVE_FOLDER=$VM_ROOT_FOLDER/_archives_

# https://www.vagrantup.com/docs/boxes.html
# https://atlas.hashicorp.com/boxes/
cdvm() {
	mkdir -p $VM_ROOT_FOLDER
	cd $VM_ROOT_FOLDER
}

vag_push_script() {
	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl.bash)" | vagrant ssh	
}

vag_add_win8() {
	# vag_add Windows8 http://aka.ms/vagrant-win8-ie10 Win8.IE10.For.Vagrant.box
	vag_add Windows81 http://aka.ms/vagrant-win81-ie11 Win8.1.IE11.For.Vagrant.box
}

vag_add_aerospike() {
	# http://www.aerospike.com/docs/operations/install/vagrant/mac/
	# https://s3-us-west-1.amazonaws.com/aerospike-vagrant/previous_version/virtualbox/as_centos-6.6-x86_64.box
	# vag_add aerospike/centos-6.5 https://atlas.hashicorp.com/aerospike/boxes/centos-6.5/versions/3.8.1/providers/virtualbox.box vagrant-aerospike-centos-6.5-3.8.1.box
	vag_add aerospike/centos-6.5 https://atlas.hashicorp.com/aerospike/boxes/centos-6.5/versions/3.8.2.3/providers/virtualbox.box vagrant-aerospike-centos-6.5-3.8.2.3.box
}

vag_add_centos_puppet() {
	vag_add puppetlabs/centos-6.6-64-puppet https://atlas.hashicorp.com/puppetlabs/boxes/centos-6.6-64-puppet/versions/1.0.3/providers/virtualbox.box vagrant-puppetlabs-centos-6.6-64-1.0.3.box
}

vag_add_docker() {
	vag_add boot2docker https://atlas.hashicorp.com/hashicorp/boxes/boot2docker/versions/1.7.8/virtualbox.box vagrant-boot2docker-1.7.8.box
	# vagrant plugin install vagrant-docker-compose
}
vag_add_centos() {
	vag_add centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box vagrant-centos65-v6.5.3_64.box
}
vag_add_ubuntu() {
	# vag_add precise64 http://files.vagrantup.com/precise64.box
	#vag_add precise64 https://atlas.hashicorp.com/hashicorp/boxes/precise64/versions/1.1.0/providers/virtualbox.box vagrant-ubuntu-precise64-1.1.0.box
	vag_add ubuntu/trusty64 https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20161205.0.0/providers/virtualbox.box vagrant-ubuntu-trusty64-20161205.box
}

vag_add_docker_centos() {
	vag_add centos2docker https://atlas.hashicorp.com/blacklabelops/boxes/dockerdev/versions/1.0.5/providers/virtualbox.box vagrant-centos2docker-1.0.5.box
	# vagrant plugin install vagrant-docker-compose
}
vag_add_docker_ubuntu() {
	BOX_FILENAME=$VM_ARCHIVE_FOLDER/docker-ubuntu-trusty64.box
	BOX_NAME=docker-ubuntu-trusty64

	echo "vagrant box add $BOX_NAME $BOX_FILENAME"
	vagrant box add $BOX_NAME $BOX_FILENAME

	echo "vagrant init $BOX_NAME"
	vagrant init $BOX_NAME
}

vag_add() {
	echo $@
	if [ $# -eq 0 ]; then
      echo "vag_add BOX_NAME [BOX_URL] [BOX_FILENAME]"
      exit 1
  	fi

  	local BOX_NAME=$1
   	if [ -z "$3" ]
    	then
        	local BOX_FILENAME=$VM_ARCHIVE_FOLDER/$1.box
	    else
    	    local BOX_FILENAME=$VM_ARCHIVE_FOLDER/$3
  	fi

	# Download file ONLY if it doesn't exist
	if [ ! -f $BOX_FILENAME ]; 
		then
			mkdir -p $VM_ARCHIVE_FOLDER
			wgetsafe $BOX_FILENAME $2
	    else
    	    echo "Vagrant Box file exist, use this one $BOX_FILENAME"
	fi
	echo "vagrant box add $BOX_NAME $BOX_FILENAME --force"
	vagrant box add $BOX_NAME $BOX_FILENAME --force

	echo "vagrant init $BOX_NAME"
	vagrant init $BOX_NAME
}

vaglist() {
	# ls $VAGRANT_BOXES_FOLDER
	echo "=== Vagrant boxes catalog ==="
	vagrant box list
	echo "=== Vagrant instances ==="
	vagrant global-status --prune

	if [[ -d $VAGRANT_MACHINES_SUBFOLDER ]]; then
		echo "== List local vagrant name =="
		ls $VAGRANT_MACHINES_SUBFOLDER
	fi
}

vag_local_sync() {
	cp -R "$BACKUP_ROOT_FOLDER/Vagrant/" .
  	mkdir -p bash_lib/
  	cp -R "$BACKUP_ROOT_FOLDER/bash_lib/" bash_lib/
	# cp $BACKUP_ROOT_FOLDER/bash_lib/_bash_profile bash_lib/
}

vag_start() {
	vagrant up
}
vag_stop() {
	vagrant halt
}
vag_destroy_vm() {
	vagrant destroy
}
# https://www.hashicorp.com/blog/feature-preview-vagrant-1-6-docker-dev-environments.html
