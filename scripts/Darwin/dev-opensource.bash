import lib-dev-maven-release
# MAC OSX
export GPG_CMD=gpg2
import lib-gpg

# GPG version 2 may be on your system with the executable name gpg2 . 
# Either executable can be used for these demonstrations. Both are very compatible with each other. 
# (If you want to know a million different opinions on which you should be using, do a web search.) 
# - Version 1 is more tested, and is usually a single monolithic executable. 
# - Version 2 is compiled with crypto libraries like libgcrypt externally linked, and is designed to work better 
#    with external password entry tools. That is, gpg2 is designed for graphical environments, while gpg works 
#    better for automated and command-line use. From the command-line, I use version 1.

inst_gpg() {
  brew install gnupg2
  brew install gpg-agent
}

# gpgagentstart() {
# 	eval $(gpg-agent --daemon --no-grab --write-env-file $HOME/.gpg-agent-info)
# 	export GPG_TTY=$(tty)
# 	export GPG_AGENT_INFO	
# }
