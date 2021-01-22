import lib-hadoop

export HADOOP_BIN=${HADOOP_HOME}/bin
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HADOOP_LOG_DIR=${HADOOP_HOME}/logs

export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export YARN_HOME=$HADOOP_HOME

export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

alias hcd='cd ${HADOOP_HOME}'
alias hcdconf='cd ${HADOOP_CONF_DIR}'
alias hcdlog='cd ${HADOOP_LOG_DIR}'

# https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html
alias hnamenodeformat='hdfs namenode -format'

alias hsafeleave='hdfs dfsadmin -safemode leave'
alias hreport='hdfs dfsadmin -report'

hnamenode() {
  hdfs namenode &
}
hnamenodestop() {
  stop-dfs.sh
}

hdatanode() {
  hdfs datanode &
}
hnodemgr() {
  start-yarn.sh
}
hnodemgrstop() {
  stop-yarn.sh
}

hconfigcore() {
  vi ${HADOOP_CONF_DIR}/core-site.xml
}
hconfigsite() {
  vi ${HADOOP_CONF_DIR}/hdfs-site.xml
}
hconfigmapred() {
  vi ${HADOOP_CONF_DIR}/mapred-site.xml
}
hconfigyarn() {
  vi ${HADOOP_CONF_DIR}/yarn-site.xml
}
