rc() {
  rclone version
}
rcls() {
  rctpl ls gdrive:
}
rcconf() {
  rctpl config
}

rctpl() {
  echo "rclone $@"
  rclone $@
}