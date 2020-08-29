export JH_ROOT=/Library/Java/JavaVirtualMachines

export JH8=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME=$JH8

function setjdk() {
  if [ $# -ne 0 ]; then
   removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
   if [ -n "${JAVA_HOME+x}" ]; then
    removeFromPath $JAVA_HOME
   fi
   export JAVA_HOME=`/usr/libexec/java_home -v $@`
   export PATH=$JAVA_HOME/bin:$PATH
  fi
}
function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

jls() {
  ll /Library/Java/JavaVirtualMachines/
  echo "Official lib var is :"
  /usr/libexec/java_home
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

jdk8() {
  jdkset $JH8
}
jdk12() {
  jdkset $JH12
}
jdkset() {
  usage $# "JDK_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  export JAVA_HOME=$1
  jdkbin
}
jdkbin() {
  binappend $JAVA_HOME/bin
  java -version
}

jkeylist() {
  if [ -z "$1" ]
    then
        local JKS_PATH=$JAVA_HOME/jre/lib/security/cacerts
    else
        local JKS_PATH=$JAVA_HOME/jre/lib/security/$1
  fi
  echo Listing JKS_PATH=$JKS_PATH
  if [ -z "$2" ]
    then
      keytool -list -keystore $JKS_PATH -storepass changeit
    else
      keytool -list -keystore $JKS_PATH
  fi
}

jkeyimport() {
  if [ $# -eq 0 ]
    then
      echo "Please supply argument(s) \"CERT_FILENAME \[JKS_NAME\]\""
      return
  fi
  if [ -z "$2" ]
    then
        local JKS_PATH=$JAVA_HOME/jre/lib/security/cacerts
    else
        local JKS_PATH=$JAVA_HOME/jre/lib/security/$1
  fi
  echo Importing CERT_FILENAME=$CERT_FILENAME   JKS_PATH=$JKS_PATH
  sudo keytool -v -importcert -alias $1 -file $1 -keystore $JKS_PATH -storepass changeit
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
