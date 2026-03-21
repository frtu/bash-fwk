if [ -f /etc/redhat-release ]; then
  import lib-inst
  import lib-systemctl
  source $SCRIPTS_FOLDER/ext_centos
fi
if [ -f /etc/lsb-release ]; then
  import lib-inst
  import lib-systemctl
  source $SCRIPTS_FOLDER/ext_debian
  source $SCRIPTS_FOLDER/ext_ubuntu
fi
if [ -f /etc/alpine-release ]; then
  source $SCRIPTS_FOLDER/ext_alpine
fi

# System metrics
syscpu() {
  echo "lscpu $@"
  lscpu "$@"
}
sysmem() {
  echo "free -m $@"
  free -m "$@"
}
sysdisk() {
  echo "lsblk $@"
  lsblk "$@"
}
# view and tune SATA/IDE hard disk drive (HDD) and solid-state drive (SSD) parameters, including cache settings, sleep modes, 
# power management, and DMA settings
sysbenchdisk() {
  usage $# "DISK_NAME:nvme0n1" "[ZOOKEEPER_HOSTNAME:zookeeper]" "[FILENAME_TO_PERSIST]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    # List block devices
    sysdisk
    return 1
  fi

  local DISK_NAME=$1
  echo "sudo hdparm -t --direct /dev/${DISK_NAME}"
  sudo hdparm -t --direct /dev/${DISK_NAME}
}
# Displaying information about PCI buses in the system and devices connected to them.
# See disk speed (lnkstat 5GT/downgraded or 8GT))
syspcibus() {
  echo "sudo lspci -vvvv"
  sudo lspci -vvvv
}
# displays system startup messages, hardware detection, device driver messages, and critical errors,
# making it essential for troubleshooting.
syslog() {
  echo "dmesg --follow $@"
  dmesg --follow $@
}

inst_net() {
  inst curl wget net-tools nmap tcpdump ${NET_PKG_EXTRA}
}
# some basics for file manipulation, build processes, version control
inst_tools() {
  inst vim git jq ripgrep build-essential
}
inst_desktop() {
  inst gh ffmpeg chromium
}
inst_full() {
  inst_net
  inst_tools
  inst_desktop
}

## Samba
inst_samba() {
  inst samba samba-common-bin
}
smbrestart() {
  srvrestart smbd
}
smbconf() {
  sudo vi /etc/samba/smb.conf
}
smbadduser() {
  usage $# "USERNAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local USERNAME=$1
  echo "sudo smbpasswd -a ${USERNAME}"
  sudo smbpasswd -a ${USERNAME}
}

inst_brew() {
  echo "Install Homebrew on Linux : https://docs.brew.sh/Homebrew-on-Linux"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
inst_zsh() {
  # switch to zsh to mirror Mac (optional)
  inst zsh
  # change default shell
  chsh -s $(which zsh)

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
inst_proc() {
  inst procps
}
inst_node() {
  # get Node22 and install it globally
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install nodejs -y

  # make a global npm directory that your user can have access
  # to rather than in /lib where the default is.
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  
  # update path to ensure you can install and run npm modules from CLI
  echo "export PATH=$HOME/.npm-global/bin:$PATH" >> ~/.zshrc
}
inst_pip() {
  inst python3-pip
}
inst_youtube() {
  inst youtube-dl
}
inst_vlc() {
  inst vlc
}
inst_docker() {
  sh -c "$(curl -fsSL https://get.docker.com)"
}
inst_ollama() {
  curl -fsSL https://ollama.com/install.sh | sh
  enablelib ai-ollama
}
