#import lib-k8s
import lib-k8s-helm

inst_hf() { 
  inst helmfile
}

hf() { 
  helmfile "version" $@
}
hfls() { 
  hftpl "list" $@
}
hfstatus() { 
  hftpl "status" $@
}
hfdiff() { 
  hftpl "diff" $@
}
# Apply all your chart releases
hfapply() { 
  hftpl "apply" $@
}
# Sync all your chart releases
hfsync() { 
  hftpl "sync" $@
}
# Sync all your chart releases (offline)
hfcharts() { 
  hftpl "charts"$@
}
hfrepo() { 
  hftpl "repos" $@
}
hfdep() { 
  hftpl "deps" $@
}
hfrm() { 
  hftpl "destroy"
}

hftest() { 
  hftpl "test" $@
}
hfbuild() { 
  hftpl "build" $@
}

hftpl() { 
  usage $# "CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "helmfile $@"
  helmfile $@
}
