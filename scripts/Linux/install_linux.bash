if [ -f /etc/redhat-release ]; then
  export INSTALL_TOOL="yum -y"
  export UNINSTALL_TOOL="yum autoremove"
fi
if [ -f /etc/lsb-release ]; then
  export INSTALL_TOOL="apt -y"
  export UNINSTALL_TOOL="apt purge"
  export CLEANUP_TOOL="apt autoremove --purge"
fi
import lib-inst

inst_net() {
  inst net-tools nmap netcat telnet
}
