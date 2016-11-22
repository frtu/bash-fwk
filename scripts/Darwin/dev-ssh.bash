#!/bin/sh

connect() {
  if [ $# -eq 0 ]
    then
      echo "Please specify a SSH_HOSTNAME"
      exit 1
  fi

  local SSH_HOSTNAME=$1
  if [ -z "$2" ]
    then
        local USERNAME=$USER
    else
        local USERNAME=$2
  fi
  echo ssh -o StrictHostKeyChecking=no $USERNAME@$SSH_HOSTNAME "$3"
  ssh -o StrictHostKeyChecking=no $USERNAME@$SSH_HOSTNAME "$3"
}
