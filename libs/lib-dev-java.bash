import lib-inst-sdk

export JH_ROOT=/Library/Java/JavaVirtualMachines

export JH11=$(/usr/libexec/java_home -v 11)
export JAVA_HOME=$JH11

jsetsdk() {
  usage $# "SDK_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then 
    echo "Please specify one of the VERSION here :" >&2
    sdkinstls java
    return 1; 
  fi

  echo "setjdk ${SDK_CANDIDATE_PATH}/$@"
  setjdk ${SDK_CANDIDATE_PATH}/$@

  java --version
}
jdksetoracle() {
  usage $# "VERSION"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  setjdk `/usr/libexec/java_home -v $@`
}
function jdkset() {
  if [ $# -ne 0 ]; then
   removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
   if [ -n "${JAVA_HOME+x}" ]; then
    removeFromPath $JAVA_HOME
   fi
   unset JAVA_HOME
   export JAVA_HOME=$@
   export PATH=$JAVA_HOME/bin:$PATH
  fi
}
function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

jv() {
  echo "======== ALL ========"
  java --version
  echo "======== JDK Oracle ========"
  /usr/libexec/java_home $@
}
jls() {
  echo "======== Listing JDK installed by SDK ========"
  sdkinstls java
  echo "======== Listing JDK Oracle ========"
  ll ${JH_ROOT}
  jv "-V"
}

jcd() {
  cd ${JH_ROOT}
}
jdkbin() {
  binappend $JAVA_HOME/bin
  java -version
}
jset8() {
  jset $JH8
}
jset11() {
  jset $JH11
}
jset() {
  usage $# "JDK_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  export JAVA_HOME=$1
  jdkbin
}
jdeactivate() {
  usage $# "JDK_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INFO_PLIST_PATH=$(/usr/libexec/java_home -v $1)/../Info.plist
  mv ${INFO_PLIST_PATH} ${INFO_PLIST_PATH}.disabled
}
jactivate() {
  usage $# "JDK_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local INFO_PLIST_PATH=$(/usr/libexec/java_home -v $1)/../Info.plist
  mv ${INFO_PLIST_PATH}.disabled ${INFO_PLIST_PATH}
}
jmv() {
  usage $# "VERSION" "JDK_FOLDER"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local VERSION=$1
  local JDK_PATH=$2
  
  echo "sudo mv ${JDK_PATH} ${JH_ROOT}"
  sudo mv ${JDK_PATH} ${JH_ROOT}

  envcreate JH${VERSION} ${JH_ROOT}/${JDK_PATH}/Contents/Home
}

jkeyls() {
  usage $# "[JKS_FILENAME]" "[PASSWORD]"

  local JKS_FILENAME=$1
  local PASSWORD=${2:-changeit}

  if [ -z "$CERT_FILENAME" ]; then
        local JKS_PATH=$JAVA_HOME/jre/lib/security/cacerts
    else
        local JKS_PATH=$JAVA_HOME/jre/lib/security/${JKS_FILENAME}
  fi
  if [ -n "$PASSWORD" ]; then
    local EXTRA_ARGS="${EXTRA_ARGS} -storepass ${PASSWORD}"
  fi

  echo "keytool -list -keystore ${JKS_PATH} ${EXTRA_ARGS}"
  keytool -list -keystore ${JKS_PATH} ${EXTRA_ARGS}
}
jkeyimport() {
  usage $# "JKS_FILENAME" "[JKS_NAME]" "[PASSWORD]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local JKS_FILENAME=$1
  local JKS_NAME=$2
  local PASSWORD=${3:-changeit}

  if [ -z "$CERT_FILENAME" ]; then
        local JKS_PATH=$JAVA_HOME/jre/lib/security/cacerts
    else
        local JKS_PATH=$JAVA_HOME/jre/lib/security/${JKS_FILENAME}
  fi

  echo "sudo keytool -v -importcert -alias ${JKS_NAME} -file ${JKS_FILENAME} -keystore ${JKS_PATH} -storepass XXXXXX"
  sudo keytool -v -importcert -alias ${JKS_NAME} -file ${JKS_FILENAME} -keystore ${JKS_PATH} -storepass ${PASSWORD}
}

jgrep() {
  grep -r $1 --include=*.java .
}

dljdk8() {
  dllazy "jdk-8u60-linux-x64.rpm" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"
}
dljdk() {
  dllazy $1 $2 "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" 
}
