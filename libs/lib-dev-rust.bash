CARGO_HOME=$HOME/.cargo
RUSTUP_HOME=$HOME/.rustup
#PATH=$CARGO_HOME/bin:$PATH

inst_rust() {
  curl https://sh.rustup.rs -sSf | sh $@
  # source $HOME/.cargo/env
  # rustup component add rustfmt
}
uninst_rust() {
  rustup self uninstall
}

rt() {
  rustup --version
}
rtinst() {
  usage $# "VERSION"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local VERSION=$1
  
  echo "rustup install ${VERSION}"
  rustup install ${VERSION}
}
rtupd() {
  rustup update
}
