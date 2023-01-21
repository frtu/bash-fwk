CARGO_HOME=$HOME/.cargo
# Toolchain management : version and package manager
RUSTUP_HOME=$HOME/.rustup
#PATH=$CARGO_HOME/bin:$PATH

# https://www.rust-lang.org/tools/install
inst_rust() {
  curl https://sh.rustup.rs -sSf | sh $@
  # source $CARGO_HOME/env
  # rtaddrustfmt
  enablelib dev-rust
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
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "rustup component add $@"
  rustup component add $@
}
rtaddrustfmt() {
  rtadd rustfmt
}
rtaddclippy() {
  rtadd clippy
}
rttarpaulin() {
  rtcinstall cargo-tarpaulin
}

rttool() {
  echo "rustup toolchain list"
  rustup toolchain list
}
rttoolset() {
  usage $# "TOOLCHAIN"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "> If you don't know any names run 'rttool'" >&2
    rttool
    return 1
  fi

  echo "rustup set default-host $@"
  rustup set default-host $@
}


# Build and package manager
# https://www.rust-lang.org/learn/get-started
rtc() {
  rtctpl --version $@
}
rtcbuild() {
  rtctpl build $@
}
rtcinstall() {
  rtctpl install $@
}
rtcrun() {
  rtctpl run $@
}
rtctest() {
  rtctpl test $@
}
rtcbench() {
  rtctpl bench $@
}
rtcdoc() {
  rtctpl doc $@
}
# Format all code
rtcformat() {
  rtctpl fmt --all $@
}
# Lint using https://github.com/rust-lang/rust-clippy
rtclint() {
  rtctpl clippy --all -- -D warnings $@
}

rtctpl() {
  usage $# "CMD" "[ADDITIONAL_PARAMS]"
   # MIN NUM OF ARG
  if [[ "$?" -ne 0 ]]; then return 1; fi

  echo "cargo $@"
  cargo $@
}