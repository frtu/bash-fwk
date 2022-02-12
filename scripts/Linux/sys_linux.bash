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
