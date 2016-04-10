replicate() {
  cp ~/.bash_profile .
  cp ~/.bashrc .
  mkdir -p libs/
  mkdir -p scripts/
  cp -R $LIBS_FOLDER libs/
  cp -R $SCRIPTS_FOLDER scripts/
}
