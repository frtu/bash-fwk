import lib-dev-python

alias t='temporal'
alias tw='temporal workflow'
alias ts='temporal server start-dev'
alias tspersist='ts --db-filename'
alias tsport='ts --ui-port'
alias tsdb='temporal server start-dev --db-filename ~/temporal.db'

# send process to background so you can continue using the terminal
alias tsbg='temporal server start-dev &> /dev/null & disown'

inst_temporal() {
  inst temporal
}
ppinst_temporal() {
  penv
  # ppinst temporalio pytest_asyncio
  python -m pip install temporalio pytest_asyncio
}