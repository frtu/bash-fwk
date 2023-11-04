# https://python-poetry.org/docs/#installation
inst_poetry() {
  echo "curl -sSL https://install.python-poetry.org | python3 -"
  curl -sSL https://install.python-poetry.org | python3 -

  binappend ~/.local/bin/
}
uninst_poetry() {
  echo "curl -sSL https://install.python-poetry.org | python3 - --uninstall"
  curl -sSL https://install.python-poetry.org | python3 - --uninstall
}

pt() {
  echo "poetry --version"
  poetry --version

  echo "======================="
  poetry env info
}
ptupd() {
  usage $# "[VERSION:1.6.1]"

  echo "poetry self update $@"
  poetry self update $@
}

ptinit() {
  echo "poetry init $@"
  poetry init $@
}
ptinst() {
  echo "poetry install"
  poetry install
}
ptstart() {
  echo "poetry run start $@"
  poetry run start $@
}

ptadd() {
  usage $# "PACKAGE"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  echo "poetry add $@"
  poetry add $@
}

ptaddpg() {
  ptinst psycopg2-binary
}
ptaddarg() {
  ptinst argparse
}
ptadddotenv() {
  ptinst python-dotenv
}
