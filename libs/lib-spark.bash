import lib-hadoop-admin
import lib-dev-maven

export LIVY_HOME=/apps/livy-server-0.3.0
export LIVY_CONF_DIR=${LIVY_HOME}/bin

alias scd='cd ${SPARK_HOME}'
alias scdlivy='cd ${LIVY_HOME}'

srun() {
  usage $# "SPARK_JAR" "[OPTIONAL_ARG]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local SPARK_JAR=$1

  echo "spark-submit --master yarn $SPARK_JAR ${@:2}"
  spark-submit --master yarn $SPARK_JAR ${@:2}
}
sdljar() {
  usage $# "JAR_GAV"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local JAR_GAV=$1

  mvndljar ${JAR_GAV} ${SPARK_HOME}/jars
}