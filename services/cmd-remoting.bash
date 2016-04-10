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

scppushcore() {
  if [ $# -eq 0 ]; then
    echo "Please profide a fully qualified hostname as first parameter!"
    exit 1
  fi

  if [ -f "~/.ssh/authorized_keys" ]; then
    echo "ssh -o StrictHostKeyChecking=no $USER@$1 'mkdir -p ~/.ssh/'"
    ssh -o StrictHostKeyChecking=no $USER@$1 'mkdir -p ~/.ssh/'
    scppush $1 ~/.ssh/authorized_keys "~/.ssh/"
  fi
  scppush $1 ~/.bash_profile "~/"
}

scpget() {
  if [ -z "$3" ]
    then
        local FIRST_FOLDER=$2
        local SECOND_FOLDER=$2
    else
        local FIRST_FOLDER=$2
        local SECOND_FOLDER=$3
  fi
  echo scp $USER@$1:$FIRST_FOLDER "$SECOND_FOLDER"
  sudo scp $USER@$1:$FIRST_FOLDER "$SECOND_FOLDER"
}
scpgetdir() {
  if [ -z "$3" ]
    then
        local FIRST_FOLDER=$2
        local SECOND_FOLDER=$2
    else
        local FIRST_FOLDER=$2
        local SECOND_FOLDER=$3
  fi
  echo scp -r $USER@$1:$FIRST_FOLDER "$SECOND_FOLDER"
  sudo scp -r $USER@$1:$FIRST_FOLDER "$SECOND_FOLDER"
}
scppush() {
  if [ -z "$3" ]
    then
        local FIRST_FOLDER=$2
        local SECOND_FOLDER=$2
    else
        local FIRST_FOLDER=$2
        local SECOND_FOLDER=$3
  fi
  echo scp "$FIRST_FOLDER" $USER@$1:$SECOND_FOLDER
  sudo scp "$FIRST_FOLDER" $USER@$1:$SECOND_FOLDER
}
scppushdir() {
  if [ -z "$3" ]
    then
        local FIRST_FOLDER=$2
        local SECOND_FOLDER=$2
    else
        local FIRST_FOLDER=$2
        local SECOND_FOLDER=$3
  fi
  echo scp -r "$FIRST_FOLDER" $USER@$1:$SECOND_FOLDER
  sudo scp -r "$FIRST_FOLDER" $USER@$1:$SECOND_FOLDER
}