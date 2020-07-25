REQ_FILENAME=requirements.txt

ppinst() {
  usage $# "[PACKAGE]"

  local PACKAGE=$1

  if [ -n "$PACKAGE" ]
    then
      local INST_ARG="${PACKAGE}"
    else
      if [[ -f "${REQ_FILENAME}" ]] 
        then 
          local INST_ARG="-r ${REQ_FILENAME}"
        else
          echo "[ERROR] Please pass an argument PACKAGE or create a local file : ${REQ_FILENAME}" >&2
          return 1
      fi      
  fi

  echo "pip install ${INST_ARG}"
  pip install ${INST_ARG}
}

ppinst_mtcnn() {
  ppinst mtcnn
}