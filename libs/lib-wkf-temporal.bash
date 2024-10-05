alias t='temporal'
alias tw='temporal workflow'
alias ts='temporal server start-dev'
alias tsdb='temporal server start-dev --db-filename ~/temporal.db'

# send process to background so you can continue using the terminal
alias tsbg='temporal server start-dev &> /dev/null & disown'

inst_temporal() {
    echo "brew install temporal"
    brew install temporal
}