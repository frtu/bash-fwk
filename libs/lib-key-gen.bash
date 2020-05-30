genkeypair() {
  usage $# "KEY_PRIVATE_FILE" "[KEY_SIZE:4096|521]" "[KEY_TYPE:rsa|ecdsa]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KEY_PRIVATE_FILE=$1
  local KEY_SIZE=${2:-4096}
  local KEY_TYPE=${3:-rsa}

  #if [[ ! $KEY_PRIVATE_FILE == *\.* ]]; then
    local KEY_PRIVATE_FILE="${KEY_PRIVATE_FILE}-${KEY_TYPE}-${KEY_SIZE}"
  #fi

  echo "ssh-keygen -t ${KEY_TYPE} -b ${KEY_SIZE} -f ${KEY_PRIVATE_FILE}"
  ssh-keygen -t ${KEY_TYPE} -b ${KEY_SIZE} -f ${KEY_PRIVATE_FILE}

  ll ${KEY_PRIVATE_FILE}
}
# https://www.golinuxcloud.com/generate-self-signed-certificate-openssl/
gencertkey() {
  usage $# "CERT_FILE:server|server.crt" "[KEY_PRIVATE_FILE:server.key]" "[KEY_SIZE:4096|521]" "[KEY_TYPE:rsa|ecdsa]" "[TTL:365]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CERT_FILE=$1
  local KEY_PRIVATE_FILE=$2
  local KEY_SIZE=${3:-4096}
  local KEY_TYPE=${4:-rsa}
  local TTL=${5:-365}
  local EXTRA_PARAMS=${@:6}

  if [[ -n "${KEY_PRIVATE_FILE}" ]]
    then
      local KEY_PRIVATE_FILE_PATH=${KEY_PRIVATE_FILE}
    else
      local KEY_PRIVATE_FILE_PATH="${CERT_FILE}.key"
  fi

  gencertself "${CERT_FILE}" "gen" "${TTL}" "-newkey ${KEY_TYPE}:${KEY_SIZE} -keyout ${KEY_PRIVATE_FILE_PATH} ${EXTRA_PARAMS}"
}
gencertself() {
  usage $# "CERT_FILE:server|server.crt" "KEY_PRIVATE_FILE_PATH:gen" "[TTL:365]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CERT_FILE=$1
  local KEY_PRIVATE_FILE_PATH=$2
  local TTL=${3:-365}
  local EXTRA_PARAMS=${@:4}

  if [[ ! $CERT_FILE == *\.* ]]; then
    local CERT_FILE="${CERT_FILE}.crt"
  fi

  gencert "${CERT_FILE}" "${KEY_PRIVATE_FILE_PATH}" "${TTL}" "-x509 -nodes" "${EXTRA_PARAMS}"
}
gencert() {
  usage $# "CERT_FILE:server|server.csr" "KEY_PRIVATE_FILE_PATH:gen" "[TTL:365]" "[EXTRA_PARAMS]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CERT_FILE=$1
  local KEY_PRIVATE_FILE_PATH=$2
  local TTL=${3:-365}
  local EXTRA_PARAMS=${@:4}

  if [[ ! $CERT_FILE == *\.* ]]; then
    local CERT_FILE="${CERT_FILE}.csr"
  fi
  if [ "$KEY_PRIVATE_FILE_PATH" != "gen" ]; then
    if [ ! -f ${KEY_PRIVATE_FILE_PATH} ]; then
      echo "- KEY FILE NOT FOUND : ${KEY_PRIVATE_FILE_PATH}" >&2
      return 1
    fi
    local EXTRA_PARAMS="-key ${KEY_PRIVATE_FILE_PATH} ${EXTRA_PARAMS}"
  fi

  # req : PKCS#10 certificate request and certificate generating utility.
  # -newkey arg : this option creates a new certificate request and a new private key. The argument takes one of several forms. rsa:nbits, where nbits is the number of bits, generates an RSA key nbits in size.
  # -keyout filename : this gives the filename to write the newly created private key to.
  # -out filename : This specifies the output filename to write to or standard output by default.
  # -days n : when the -x509 option is being used this specifies the number of days to certify the certificate for. The default is 30 days.

  # -x509 : this option outputs a self signed certificate instead of a certificate request. This is typically used to generate a test certificate or a self signed root CA.
  # -nodes : if this option is specified then if a private key is created it will not be encrypted.

  echo "openssl req -new -sha256 -out ${CERT_FILE} -days ${TTL} ${EXTRA_PARAMS}"
  openssl req -new -sha256 -out ${CERT_FILE} -days ${TTL} ${EXTRA_PARAMS}

  ll $1
}
printkey() {
  usage $# "KEY_PRIVATE_FILE_PATH"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local KEY_PRIVATE_FILE_PATH=$1
  echo "openssl rsa -in ${KEY_PRIVATE_FILE_PATH} -check"
  openssl rsa -in ${KEY_PRIVATE_FILE_PATH} -check
}
printreqcert() {
  usage $# "CERT_FILE:server.csr"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CERT_FILE=$1
  echo "openssl req -in ${CERT_FILE} -noout -text"
  openssl req -in ${CERT_FILE} -noout -text
}
printcert() {
  usage $# "CERT_FILE:server.csr"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  local CERT_FILE=$1
  echo "openssl x509 -in ${CERT_FILE} -noout -text"
  openssl x509 -in ${CERT_FILE} -noout -text
}
printcertsslserver() {
  usage $# "DOMAIN_NAME:HTTPS_PORT"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  openssl s_client -showcerts -connect $@ </dev/null 2>/dev/null|openssl x509 -outform PEM > cert.pem
}
keystoregen() {
  keytool -genkey -alias msmaster -keyalg RSA -keystore KeyStore.jks -keysize 2048
}
printcertserver() {
  usage $# "DOMAIN_NAME:HTTPS_PORT"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi

  keytool -printcert -sslserver $@
}