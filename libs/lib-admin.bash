echo =======================
#echo SYS=$SYS
#echo BOX_HOME=$BOX_HOME
echo LIB_FOLDER=$LIB_FOLDER
echo BACKUP_FOLDER=$BACKUP_FOLDER
echo DOWNLOAD_FOLDER=~/dl
echo =======================

import() {
  echo "source $1.bash"; source "$i.bash";
}
import lib_install

cdcommon() {
  cd "$LIB_FOLDER"
}
cdbackup() {
  cd "$BACKUP_FOLDER"
}
backup() {
  cp ~/*.bash "$BACKUP_FOLDER"
  cp ~/bash_lib/*.bash "$LIB_FOLDER"
  cp ~/.bash_profile "$LIB_FOLDER/_bash_profile"
}
#restore() {
#  cp -R $BACKUP_FOLDER/ ~/
#  mkdir -p ~/bash_lib
#  cp $LIB_FOLDER/_bash_profile ~/.bash_profile
#  cp $LIB_FOLDER/*.bash ~/bash_lib/
#}
restore() {
  cdbackup
  cp ./*.bash ~/
  cdcommon
  mkdir -p ~/bash_lib
  cp ./_bash_profile ~/.bash_profile
  cp ./*.bash ~/bash_lib/
  cd ~
}
reload() {
  source ~/.bash_profile
}
replicate() {
  cp ~/.bash_profile .
  mkdir -p bash_lib/
  cp -R ~/bash_lib/ bash_lib/
}
