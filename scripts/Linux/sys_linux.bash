if [ -f /etc/redhat-release ]; then
  source $SCRIPTS_FOLDER/ext_centos
fi
if [ -f /etc/lsb-release ]; then
  source $SCRIPTS_FOLDER/ext_debian
  source $SCRIPTS_FOLDER/ext_ubuntu
fi
import lib-inst
import lib-systemctl

inst_net() {
  inst net-tools nmap telnet curl ${NET_PKG_EXTRA}
}
inst_pip() {
  inst python3-pip
}
inst_youtube() {
  inst youtube-dl
}
