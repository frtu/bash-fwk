CARGO_HOME=$HOME/.cargo
# Toolchain management : version and package manager
RUSTUP_HOME=$HOME/.rustup
#PATH=$CARGO_HOME/bin:$PATH

# https://www.rust-lang.org/tools/install
inst_rust() {
  curl https://sh.rustup.rs -sSf | sh $@
  # source $CARGO_HOME/env
  # rtaddrustfmt
}
uninst_rust() {
  echo "rustup self uninstall"
  rustup self uninstall
}

# https://github.com/rust-lang/rustup.rs/blob/master/README.md
rt() {
  echo "rustup --version"
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
  echo "rustup update"
  rustup update
}

rtadd() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "rustup component add $@"
  rustup component add $@
}
rtaddrustfmt() {
  rtadd rustfmt
}

# Build and package manager
# https://www.rust-lang.org/learn/get-started
rtc() {
  echo "cargo --version"
  cargo --version
}
rtcbuild() {
  echo "cargo build"
  cargo build
}
rtcrun() {
  echo "cargo run"
  cargo run
}
rtctest() {
  echo "cargo test"
  cargo test
}
rtcbench() {
  echo "cargo bench"
  cargo bench
}
rtcdoc() {
  echo "cargo doc"
  cargo doc
}
