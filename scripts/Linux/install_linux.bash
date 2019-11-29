if [ -f /etc/redhat-release ]; then
  source $SCRIPTS_FOLDER/ext_centos
fi
if [ -f /etc/lsb-release ]; then
  source $SCRIPTS_FOLDER/ext_debian
fi
import lib-inst

inst_net() {
  inst net-tools nmap netcat telnet curl ${NET_PKG_EXTRA}
}
