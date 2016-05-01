wgetlazy() {
  if [ $# -eq 0 ]; then
      echo "wgetlazy FILENAME HTTP_URL [HTTP_PARAMS]"
      exit 1
  fi

  #if [ ! -z "$3" ]; then
      #HTTP_PARAMS=--header "$3"
  #fi

  # Download file ONLY if it doesn't exist
  if [ ! -f $1 ]
    then
      echo "wget --no-cookies --no-check-certificate -O $1 $HTTP_PARAMS $2"
      wget --no-cookies --no-check-certificate -O $1 --header "$3" $HTTP_PARAMS $2
    else
      echo "File exist, use this one $1"
  fi
}

wgetsafe() {
  echo "Downloading : wget -O $1 $2"
  wget -O $1.bak $2
  mv $1.bak $1  
  echo "Done : $1"
}
