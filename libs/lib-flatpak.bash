inst_obsidian() {
  ${SUDO_CONDITIONAL} flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  ${SUDO_CONDITIONAL} flatpak install flathub md.obsidian.Obsidian
}
obsidian() {
  flatpak run md.obsidian.Obsidian
}
