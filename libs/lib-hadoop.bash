alias hls='hadoop fs -ls '
alias hdu='hadoop fs -du -h '

# https://hadoop.apache.org/docs/r2.7.2/hadoop-project-dist/hadoop-hdfs/HdfsQuotaAdminGuide.html
alias hquota='hadoop fs -count -q -h -v '

hdirsize() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
      echo "Usage : hdirsize HDFS_FOLDER [HDFS_MORE_ARG]. Run 'hdfs dfs -count -q' on each subfolders of HDFS_FOLDER" >&2
      echo " HDFS_MORE_ARG : -h = human readable, -v = verbose" >&2
      return -1
  fi

  local HDFS_FOLDER=$1
  local HDFS_MORE_ARG=${@:2}

  hdircmd $HDFS_FOLDER "hdfs dfs -count -q $HDFS_MORE_ARG"
}
hdirls() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
      echo "Usage : hdirls HDFS_FOLDER [HDFS_MORE_ARG]. Run 'hdfs dfs -ls' on each subfolders of HDFS_FOLDER" >&2
      return -1
  fi

  local HDFS_FOLDER=$1
  local HDFS_MORE_ARG=${@:2}

  hdircmd $HDFS_FOLDER "hdfs dfs -ls $HDFS_MORE_ARG"
}

hdircmd() {
  # MIN NUM OF ARG
  if [[ "$#" < "2" ]]; then
      echo "Usage : hdircmd HDFS_FOLDER HDFS_CMD.. . Run 'HDFS_CMD..' on each subfolders of HDFS_FOLDER" >&2
      return -1
  fi

  local HDFS_FOLDER=$1
  local HDFS_CMD=${@:2}

  echo "hdfs dfs -ls $HDFS_FOLDER | awk -v COMMAND=\"$HDFS_CMD \" '{system(COMMAND \$8)}'"
  hdfs dfs -ls $HDFS_FOLDER | awk -v COMMAND="$HDFS_CMD " '{system(COMMAND $8)}'
}
