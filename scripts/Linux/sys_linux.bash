if [ -f /etc/redhat-release ]; then
  source $SCRIPTS_FOLDER/ext_centos
fi
if [ -f /etc/lsb-release ]; then
  source $SCRIPTS_FOLDER/ext_debian
fi
import lib-inst
import lib-systemctl

inst_net() {
  inst net-tools nmap telnet curl ${NET_PKG_EXTRA}
}
