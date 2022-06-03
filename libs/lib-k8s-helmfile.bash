#import lib-k8s
import lib-k8s-helm

inst_hf() { 
  inst helmfile
}

hf() { 
  helmfile "version"
}

hftpl() { 
  usage $# "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "helmfile $@"
  helmfile $@
}
