iospair() {
  idevicepair pair
  sudo mkdir /media/$USER/ios
  sudo chown -R $USER /media/$USER/ios
  ifuse /media/$USER/ios/ 
}
iosvalidate() {
  idevicepair validate
}

iosdebug() {
  export GNUTLS_DEBUG_LEVEL=99
}
