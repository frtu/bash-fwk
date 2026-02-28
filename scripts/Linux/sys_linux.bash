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
  inst curl net-tools nmap tcpdump ${NET_PKG_EXTRA}
}
inst_proc() {
  inst procps
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
