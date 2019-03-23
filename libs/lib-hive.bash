trimfirstandlast() {
  sed 's/.$//; s/^.//' $@
}
trimjson() {
  sed 's/\\\"/\"/g' $@ | sed 's/\\\\/\\/g'
}
trimhivejson() {
  trimfirstandlast $@ | trimjson
}
wrapquote() {
  sed 's/^/"/;s/$/"/' $@
}