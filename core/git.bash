gpatch() {
	if [ -z "$1" ]
    	then
        	local DIFF_NAME=diff
	    else
    	    local DIFF_NAME=$1
  	fi
	echo "git diff > $DIFF_NAME.patch"
	git diff > $DIFF_NAME.patch
}

gpatchapply() {
	if [ -z "$1" ]
    	then
        	local DIFF_NAME=diff
	    else
    	    local DIFF_NAME=$1
  	fi
	
	if [ -f "$DIFF_NAME.patch" ]; then
		echo "Applying patch with 'git apply $DIFF_NAME.patch'"
		git apply $DIFF_NAME.patch
	fi
}