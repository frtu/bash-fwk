import lib-dev-kotlin

inst_kotlin() {
  usage $# "[VERSION:1.4.21]"

  local VERSION=$1
  if [ -n "${VERSION}" ]; then
    VERSION=@${VERSION}
  fi

  echo "== MAY BE ADVICED TO UPDATE REPO WITH > upd"
  inst kotlin${VERSION}
}
ktbin() {
  binappend /Users/fred/.sdkman/candidates/kotlin/current/bin
}
