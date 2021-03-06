import lib-hive

# https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/HDFSCommands.html
alias hversion='hdfs version'

alias hls='hdfs dfs -ls '
alias hmkdir='hdfs dfs -mkdir '
alias hcpget='hdfs dfs -copyToLocal '
alias hcpput='hdfs dfs -copyFromLocal '
alias hcpputf='hdfs dfs -copyFromLocal -f '

alias hdu='hdfs dfs -du -h '

# https://hadoop.apache.org/docs/r2.7.2/hadoop-project-dist/hadoop-hdfs/HdfsQuotaAdminGuide.html
alias hquota='hadoop fs -count -q -h -v '

alias hput='hdfs dfs -put '
alias hget='hdfs dfs -get '
alias hcat='hdfs dfs -cat '
alias htext='hdfs dfs -text '

hdircsv() {
  usage $# "HDFS_FOLDER" "FILENAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local HDFS_FOLDER=$1
  local FILENAME=$2

  echo "QUOTA REM_QUOTA SPACE_QUOTA REM_SPACE_QUOTA DIR_COUNT FILE_COUNT CONTENT_SIZE PATHNAME" > $FILENAME
  hdirsize ${HDFS_FOLDER} | trimspacetab >> $FILENAME

  STATUS=$?
  if [ "$STATUS" -eq 0 ]
    then
      echo "== Sub folder sizes imported to file ${FILENAME} from folder ${HDFS_FOLDER} =="
      cat $FILENAME
    else
      echo "== An error has happen." >&2
  fi
}
hdirsize() {
  usage $# "HDFS_FOLDER" "[OPTIONAL_ARG]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo " Run 'hdfs dfs -count -q' on each subfolders of HDFS_FOLDER" >&2
    echo " HDFS_MORE_ARG : -h = human readable, -v = verbose" >&2
    return -1 
  fi

  local HDFS_FOLDER=$1
  local OPTIONAL_ARG=${@:2}

  hdirtpl ${HDFS_FOLDER} "hdfs dfs -count -q ${OPTIONAL_ARG}"
}
hdirls() {
  usage $# "HDFS_FOLDER" "[OPTIONAL_ARG]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Run 'hdfs dfs -ls [OPTIONAL_ARG]' on each subfolders of HDFS_FOLDER" >&2
    return -1 
  fi

  local HDFS_FOLDER=$1
  local OPTIONAL_ARG=${@:2}

  hdirtpl ${HDFS_FOLDER} "hdfs dfs -ls ${OPTIONAL_ARG}"
}

hdirtpl() {
  usage $# "HDFS_FOLDER" "HDFS_MANY_ARGS_CMD"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Allow to run 'HDFS_MANY_ARGS_CMD..' on each subfolders of HDFS_FOLDER" >&2
    return -1 
  fi

  local HDFS_FOLDER=$1
  local HDFS_MANY_ARGS_CMD=${@:2}

  echo "hdfs dfs -ls ${HDFS_FOLDER} | awk -v COMMAND=\"$HDFS_MANY_ARGS_CMD \" '{system(COMMAND \$8)}'" >&2
  hdfs dfs -ls ${HDFS_FOLDER} | awk -v COMMAND="$HDFS_MANY_ARGS_CMD " '{system(COMMAND $8)}'
}
