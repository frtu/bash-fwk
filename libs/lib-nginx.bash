import lib-key-gen

nginst() {
  inst nginx
}

# http://nginx.org/en/docs/switches.html
# MORE : https://www.nginx.com/resources/wiki/start/topics/tutorials/commandline/
ng() {
  ngtpl -V
}
ngstart() {
  usage $# "[CONFIG_PATH]" "[ERROR_FILE_PATH]" "[GLOBAL_CONFIG_DIRECTIVES:http://nginx.org/en/docs/ngx_core_module.html]"

  local CONFIG_PATH=$1
  local ERROR_FILE_PATH=$2
  local GLOBAL_CONFIG_DIRECTIVES=${@:3}

  if [ -f "$CONFIG_PATH" ]; then
    local EXTRA_ARGS="${EXTRA_ARGS} -c ${CONFIG_PATH}"
  fi
  if [ -n "$ERROR_FILE_PATH" ]; then
    local EXTRA_ARGS="${EXTRA_ARGS} -e ${ERROR_FILE_PATH}"
  fi
  if [ -n "$GLOBAL_CONFIG_DIRECTIVES" ]; then
    local EXTRA_ARGS="${EXTRA_ARGS} -g ${GLOBAL_CONFIG_DIRECTIVES}"
  fi
  
  ngtpl ${EXTRA_ARGS}
}
ngstop() {
  ngtpl -s quit
}
ngstopforce() {
  ngtpl -s stop
}
ngrestart() {
  ngtpl -s reload
}
ngtpl() {
  echo "sudo nginx $@"
  sudo nginx $@
}

ngcertselfsigned() {
  usage $# "CERT_KEY_FILE_BASE_NAME:cert" "DOMAIN_NAME"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local CERT_KEY_FILE_BASE_NAME=$1
  local DOMAIN_NAME=$2

  gencertkey ${CERT_KEY_FILE_BASE_NAME}.pem ${CERT_KEY_FILE_BASE_NAME}.key 2048 rsa 365 -subj "/CN=${DOMAIN_NAME}"
  printcert ${CERT_KEY_FILE_BASE_NAME}.pem

  echo "===================================================================="
  echo "printkey ${CERT_KEY_FILE_BASE_NAME}.key : to print the generated key"
  echo "printcert ${CERT_KEY_FILE_BASE_NAME}.pem : to print the generated cert"
}
