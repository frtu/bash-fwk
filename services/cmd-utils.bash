# Command utils
mkcd() {
  mkdir $1 && cd $1
}

disksize() {
  df -h
}
