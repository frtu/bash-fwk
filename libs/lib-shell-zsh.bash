zsvi() {
  vi ~/.zshrc
}
shellomz() {
  echo "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
shellpower() {
  echo "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
}
zspluginhighlight() {
  zsplugin zsh-syntax-highlighting
}
zspluginautosuggestions() {
  zsplugin zsh-autosuggestions
}
zspluginhistory() {
  zsplugin zsh-history-substring-search 
}
zsplugin() {
  usage $# "PLUGIN" "[REPO:zsh-users]"
  ## Display Usage and exit if insufficient parameters. Parameters prefix with [ are OPTIONAL.
  if [[ "$?" -ne 0 ]]; then return 1; fi

  local PLUGIN=$1
  local REPO=${2:-zsh-users}
  echo "git clone https://github.com/${REPO}/${PLUGIN}.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/${PLUGIN}"
  git clone https://github.com/${REPO}/${PLUGIN}.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/${PLUGIN}
}
