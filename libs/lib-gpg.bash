GPG_HOME=~/.gnupg

export GPG_TTY=$(tty)

# GPG version 2 may be on your system with the executable name gpg2 . 
# Either executable can be used for these demonstrations. Both are very compatible with each other. 
# (If you want to know a million different opinions on which you should be using, do a web search.) 
# - Version 1 is more tested, and is usually a single monolithic executable. 
# - Version 2 is compiled with crypto libraries like libgcrypt externally linked, and is designed to work better 
#    with external password entry tools. That is, gpg2 is designed for graphical environments, while gpg works 
#    better for automated and command-line use. From the command-line, I use version 1.
GPG_CMD=${GPG_CMD:-gpg}

# More about signature & commands
# http://central.sonatype.org/pages/working-with-pgp-signatures.html
# http://blog.sonatype.com/2010/01/how-to-generate-pgp-signatures-with-maven/
gpgcd() {
  if [ ! -f "$GPG_HOME/pubring.gpg" ]; then
  	echo "list-keys will initialize the Public key" >&2
    gpgls
  fi  
  if [ ! -f "$GPG_HOME/secring.gpg" ]; then
  	echo "Attention no secret key use > gpgkeysgen" >&2
  	return -1
  fi
  cd $GPG_HOME
}
# https://www.futureboy.us/pgp.html
gpgkeysgen() {
  $GPG_CMD --gen-key
}

gpgkeysls() {
  echo "List keys : pub SIZE/KEY_ID CREATION_DATE"
	$GPG_CMD --list-keys
}
gpguid() {
  gpgkeysls | grep ^uid
}
gpgkeyspublic() {
  gpgkeysls | grep ^pub
}
gpgkeysprivate() {
  $GPG_CMD --list-secret-keys | grep ^sec
}

gpgsign() {
  if [ ! -f "$1" ]; then
    echo "== Please supply argument(s) > gpgsign FILENAME ==" >&2
    return -1
  fi
  echo $GPG_CMD -ab $1
  $GPG_CMD -ab $1

  if [ -f "$1.asc" ]; then
    echo "File '$1.asc' created sucessfully!"
  fi
}
gpgverify() {
  if [ ! -f "$1" ]; then
    echo "== Please supply argument(s) > gpgverify ASC_FILENAME ==" >&2
    return -1
  fi
  fileext=${1##*.}
  if [ ! $fileext = "asc" ]; then
    echo "== You need to pass an .asc file as first parameter! ==" >&2
    return -1
  fi
  echo $GPG_CMD --verify $1
  $GPG_CMD --verify $1
}

gpgexport() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "== Please supply argument(s) > gpgexport EMAIL@gpg.local ==" >&2
    gpguid
    return -1
  fi
  $GPG_CMD --armor --export $1
}
gpgimport() {
  if [ ! -f "$1" ]; then
    echo "== Please supply argument(s) > gpgimport FILENAME ==" >&2
    return -1
  fi
  $GPG_CMD --import $1

  echo "== List all keys =="
  gpgkeysls
}

gpgexportprivate() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "== Please supply argument(s) > gpgexportprivate EMAIL@gpg.local ==" >&2
    gpguid
    return -1
  fi
  gpg --export-secret-key -a $1
}
gpgimportprivate() {
  if [ ! -f "$1" ]; then
    echo "== Please supply argument(s) > gpgimportprivate FILENAME ==" >&2
    return -1
  fi
  $GPG_CMD --allow-secret-key-import --import $1

  echo "== List all keys =="
  gpgkeysprivate
}
gpgkeysrevoke() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "== Please supply argument(s) > gpgkeysrevoke EMAIL@gpg.local ==" >&2
    gpguid
    return -1
  fi
  $GPG_CMD --gen-revoke --armor --output=RevocationCertificate.asc $1
}
gpgkeysfingerprint() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "== Please supply argument(s) > gpgkeysrevoke EMAIL@gpg.local ==" >&2
    gpguid
    return -1
  fi
  $GPG_CMD --fingerprint $1
}


gpgkeysdeploy() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "== Please supply argument(s) > gpgkeysdeploy KEY_ID/or/EMAIL ==" >&2
    gpguid
    return -1
  fi
  $GPG_CMD --keyserver hkp://pool.sks-keyservers.net --send-keys $1  
}
gpgkeysreceive() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
    echo "== Please supply argument(s) > gpgkeysreceive REMOTE_KEY_ID/or/EMAIL ==" >&2
    return -1
  fi
  $GPG_CMD --keyserver hkp://pool.sks-keyservers.net --recv-keys $1
}
