prjmvn() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
      echo "Usage : prjmvn COMMAND . Run 'mvn COMMAND' on each subfolders" >&2
      return -1
  fi

  local COMMAND="mvn $@"
  for directory in */ ; do 
    cd $directory
    if [ -f "pom.xml" ]
      then
        echo "== $PWD/$directory> $COMMAND =="
        eval "$COMMAND"
      else
        echo "== Skip folder $PWD/$directory because there is no 'pom.xml' file"
    fi
    cd ..
  done
}
prjmc() {
  prjmvn compile
}

prjgit() {
  # MIN NUM OF ARG
  if [[ "$#" < "1" ]]; then
      echo "Usage : prjgit COMMAND . Run 'git COMMAND' on each subfolders" >&2
      return -1
  fi

  local COMMAND="git $@"
  for directory in */ ; do 
    cd $directory
    if [ -d ".git" ]
      then
        echo "== $PWD/$directory> $COMMAND =="
        eval "$COMMAND"
      else
        echo "== Skip folder $PWD/$directory because there is no '.git' folder"
    fi
    cd ..
  done
}
prjgl() {
  prjgit pull $@
}
prjgf() {
  prjgit fetch --all $@
}

