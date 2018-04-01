import lib-hadoop

export HADOOP_CONFIG=${HADOOP_HOME}/etc/hadoop
export HADOOP_LOG_DIR=${HADOOP_HOME}/logs

# https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html
hnamenodeformat() {
  hdfs namenode -format
}

hnamenode() {
  start-dfs.sh
}
hnamenodestop() {
  stop-dfs.sh
}
hnodemgr() {
  start-yarn.sh
}
hnodemgrstop() {
  stop-yarn.sh
}

hconfigcore() {
  vi ${HADOOP_CONFIG}/core-site.xml
}
hconfigsite() {
  vi ${HADOOP_CONFIG}/hdfs-site.xml
}
hconfigmapred() {
  vi ${HADOOP_CONFIG}/mapred-site.xml
}
hconfigyarn() {
  vi ${HADOOP_CONFIG}/yarn-site.xml
}
hcdlog() {
  cd ${HADOOP_LOG_DIR}
}
