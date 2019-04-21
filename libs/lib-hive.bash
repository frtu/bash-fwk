trimspacetab() {
  # Remove all the leading space & duplicated space in the middle
  sed 's/^[ \t]*//; s/  */ /g' $@
}
trimfirstandlast() {
  sed 's/.$//; s/^.//' $@
}
trimjson() {
  sed 's/\\\"/\"/g' $@ | sed 's/\\\\/\\/g'
}
trimhivejson() {
  trimfirstandlast $@ | trimjson
}
wrapquote() {
  sed 's/^/"/;s/$/"/' $@
}
lineshow() {
  usage $# "SOURCE_FILE" "[NUMBER_OF_LINES]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local SOURCE_FILE=$1
  local NUMBER_OF_LINES=$2

  if [ -z "$NUMBER_OF_LINES" ]; 
  	then
      echo "head -n 2 $SOURCE_FILE"
      head -n 2 $SOURCE_FILE
    else
      echo "head -n ${NUMBER_OF_LINES} $SOURCE_FILE"
      head -n ${NUMBER_OF_LINES} $SOURCE_FILE
  fi
}
lineskipfirst() {
  usage $# "SOURCE_FILE" "[TARGET_FILE]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local SOURCE_FILE=$1
  local TARGET_FILE=$2

  if [ -z "$TARGET_FILE" ]; 
  	then
      echo "tail -n +2 $SOURCE_FILE"
      tail -n +2 $SOURCE_FILE
    else
      echo "tail -n +2 $SOURCE_FILE > $TARGET_FILE"
      tail -n +2 $SOURCE_FILE > $TARGET_FILE
  fi
}
lineappendfirst() {
  usage $# "SOURCE_FILE" "NEW_TEXT"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return -1; fi
  
  local SOURCE_FILE=$1
  local NEW_TEXT="${@:2}"

  # sed -i.bak $'1s/^/'.$NEW_TEXT.'\\\n/' $SOURCE_FILE
  eval "sed -i.bak $'1s/^/$NEW_TEXT\\\\\\n/' $SOURCE_FILE"
}
