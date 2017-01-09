USR_BIN=/usr/local/bin

export PATH=$PATH:\
$USR_BIN:\
$HOME/bin

cdbin(){
  cd $USR_BIN
}

disksize() {
  df -h
}

foldersize() {
	du -sh ./*
}
