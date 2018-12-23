#!/bin/sh
# Loading local keys
export SSH_ROOT="$HOME/.ssh"
export SSH_ENV="$SSH_ROOT/env"
export SSH_BIN="/usr/bin"

sshagentstart() {
     echo "= Initialising new SSH agent... ="
     ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo "SSH Agent started"
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     sshagentaddfiles
     sshagentls
}
sshagentstop() {
     sshagentrm
     ssh-agent -k
}
sshagentls() {
     echo List of keys
     ssh-add -l
}
sshagentrm() {
     rm -f "${SSH_ENV}"
     ssh-add -D
}
sshagentadd() {
     if [ -f "$1" ]; then
          sshagentaddfiles "$1"
          return
     fi
     local SSH_KEY_FILE=$SSH_ROOT/$1
     if [ -f "$SSH_KEY_FILE" ]; then
          sshagentaddfiles "$SSH_KEY_FILE"
          return
     fi
     sshagentaddfiles $SSH_ROOT
}
sshagentaddfiles() {
     if [ -f "$1" ]; then
          ssh-add "$1"
     fi
     if [ -d "$1" ]; then
          echo "= Scan folder $SSH_ROOT for RSA files ="
          for i in $1/*rsa; do sshagentaddfiles "$i"; done
     fi
}
