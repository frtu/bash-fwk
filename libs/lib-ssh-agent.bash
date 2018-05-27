#!/bin/sh
# Loading local keys
export SSH_ROOT="$HOME/.ssh"
export SSH_ENV="$SSH_ROOT/env"

sshagentstart() {
     echo "Initialising new SSH agent..."
     ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo SSH Agent started
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     for i in ~/.ssh/*rsa; do /usr/bin/ssh-add "$i"; done
     sshagentls
}
sshagentstop() {
     ssh-add -D
     ssh-agent -k
}
sshagentls() {
     echo List of keys
     ssh-add -l
}
