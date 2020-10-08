# https://stackoverflow.com/questions/122327/how-do-i-find-the-location-of-my-python-site-packages-directory
py() {
  python --version
  echo "================="
  python -m site
}
