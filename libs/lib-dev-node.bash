nj() {
  echo "> node -v"
  node -v
  echo "> npm -v"
  npm -v
  echo "> node -p process.versions"
  node -p process.versions
}

njinststart() {
  echo "> npm install"
  npm install
  echo "> npm start"
  npm start
}
njbuild() {
  echo "> npm run build"
  npm run build
}
njbuildNdeploy() {
  njbuild

  echo "> npm install -g serve"
  sudo npm install -g serve
  echo "> serve -s build&"
  serve -s build&
}