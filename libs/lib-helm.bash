# https://www.baeldung.com/kubernetes-helm
hminfo() { 
  hmtpl "version"
}

hminit() { 
  echo "== Initialize Helm server (Tiller) into the current K8s context =="
  hmtpl "init" $@
}
hmcreate() { 
  hmtpl "create" $@
}
hmgen() { 
  hmtpl "lint" $@
  hmtpl "template" $@
}
hmpkg() { 
  hmtpl "package" $@
}
hmtpl() { 
  if [ -z "$2" ]; then
    echo "Please supply argument(s) \"CHART_FOLDER\"." >&2
    return -1
  fi
  echo "helm $@"
  helm $@
}

hmls() { 
  hmtpl "ls" "--all"
}
hminstall() { 
  usage $# "CHART_FOLDER" "[INSTANCE_NAME]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CHART_FOLDER=$1
  local INSTANCE_NAME=$2

  if [ -n "$INSTANCE_NAME" ]
    then
      local INSTANCE_NAME=--name ${INSTANCE_NAME}
    else
      local INSTANCE_NAME="--generate-name"
  fi

  hmtpl "install" ${CHART_FOLDER} ${INSTANCE_NAME}
}
hmupgrade() { 
  usage $# "CHART_FOLDER" "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CHART_FOLDER=$1
  local INSTANCE_NAME=$2

  hmtpl "upgrade" ${INSTANCE_NAME} ${CHART_FOLDER}
}
hmrollback() { 
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  hmtpl "rollback" ${INSTANCE_NAME} 1
}
hmrm() { 
  usage $# "INSTANCE_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INSTANCE_NAME=$1
  hmtpl "delete" "--purge" ${INSTANCE_NAME}
}
