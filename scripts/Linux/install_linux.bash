if [ -f /etc/redhat-release ]; then
  source ext_centos
fi
if [ -f /etc/lsb-release ]; then
  source ext_ubuntu
fi
import lib-inst

inst_net() {
  inst net-tools nmap netcat telnet
}
