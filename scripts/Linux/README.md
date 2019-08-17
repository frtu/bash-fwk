# Linux scripts

How to quickly start with Linux (Ubuntu)

## One line download and install
### Locally Ubuntu
	echo "$(curl -fsSL https://raw.githubusercontent.com/frtu/bash-fwk/master/autoinstaller4curl-ubuntu.bash)" | bash


## Installation

### Docker

Install docker :
```
enabledockerlinux
```

### NodeJS

Install NodeJS 10 :
```
inst_node10
```

Or for NodeJS x, just use the generic cmd with the desired version :
```
inst_node 12
```

### S Socks

Install SSocks :
```
inst_ssocks
```

=> check the python folder
```
ll /usr/local/lib/
```

```
sudo vi /usr/local/lib/python3.7/dist-packages/shadowsocks/crypto/openssl.py
```
- Replace the 2 occurence of EVP\_CIPHER\_CTX\_cleanup => EVP\_CIPHER\_CTX\_reset

### Youtube DL

```
inst_youtube
```

## Docker module

List all docker instances :
```
dckps
```

Create a new Jenkins docker instance :

```
dckrunjenkins jenkins ~/data
```

## Tech details
- setup.bash : is the shell installer script
- autoinstaller4curl.bash : remote installer that git clone this repo and launch setup.bash
