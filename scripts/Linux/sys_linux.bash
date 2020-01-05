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

# https://flavio.castelli.me/2018/07/18/hackweek-project-docker-registry-mirror/
inst_helm() {
  # https://www.linode.com/docs/kubernetes/how-to-install-apps-on-kubernetes-with-helm/
  inst socat
  curl -L https://git.io/get_helm.sh | bash
  enablelib helm
  # helm init --service-account tiller --upgrade
}