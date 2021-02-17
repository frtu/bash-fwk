#!/bin/sh
inst_jmeter() {
  inst jmeter
}

# https://www.linkedin.com/pulse/apache-jmeter-basics-common-errors-issues-best-practices-prasad/
jm() {
  echo "jmeter $@"
  jmeter $@
}

jmcli() {
  usage $# "JMX_FILE" "[LOG_FILE:result.jtl]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local JMX_FILE=$1
  local LOG_FILE=${2:-result.jtl}

  if [ ! -f "$JMX_FILE" ]; then
    echo "Please make sure the jmx file exist : JMX_FILE=${JMX_FILE}" >&2 
    jmcli
    return 1
  fi

  command="${@:3} jmeter -n -t \"$JMX_FILE\" -l \"$LOG_FILE\""

  echo ${command}
  eval $command
}

jmcliext() {
  usage $# "JMX_FILE" "[LOG_FILE:result.jtl]" "[MEM:512m]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local JMX_FILE=$1
  local LOG_FILE=${2:-result.jtl}
  local MEM=${3:-512m}

  jmcli "$JMX_FILE" "$LOG_FILE" "env JVM_ARGS=\"-Xms${MEM} -Xmx${MEM}\""
}