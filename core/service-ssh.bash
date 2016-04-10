#!/bin/sh
# Loading local keys
export SSH_ENV="$HOME/.ssh_env"

start_agent() {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo SSH Agent started
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     for i in ~/.ssh/*-rsa; do /usr/bin/ssh-add "$i"; done
     echo List of keys
     ssh-add -l
}
stop_agent() {
	ssh-add -D
	ssh-agent -k
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi
