# lib commands

All the bash commands you can activate with :

* List all the lib available : ```lslibs```
* Import (temporary) : ```import lib-*``` (*like ```import lib-git```*)
* Persist import : ```enablelib *``` (*like ```enablelib git```*)
* Remove persisted import : ```disablelib *``` (*like ```disablelib git```*)

## Library 'git'

### Remote
#### Clone repository

Clone a git repo using **REPO\_NAME/PROJECT\_NAME** you copy from browser :

```
gcl "REPO_NAME/PROJECT_NAME"
```

You can also use the long syntax to :

* checkout a particular branch (you can script) 
* pass an Enterprise Github URL (by default use 'github.com')

```
gcl "REPO_NAME" "PROJECT_NAME" "[BRANCH_NAME]" "[GITHUB_ROOT_URL:github.com]"
```

#### Link local to remote repository

Link to a remote git repo using **REPO\_NAME/PROJECT\_NAME** you copy from browser :

```
gremoteadd "REPO_NAME/PROJECT_NAME"
```

You can also use the long syntax to :

* checkout a particular name if you have **MANY origin** (you can script) 
* pass an Enterprise Github URL (by default use 'github.com')

```
gremoteadd "REPO_NAME" "PROJECT_NAME" "[REMOTE_NAME:origin]" "[GITHUB_ROOT_URL:github.com]"
```

You can also use the long syntax to :

* checkout a particular branch (you can script) 
* pass an Enterprise Github URL (by default use 'github.com')

```
gremoteaddbr "REPO_NAME" "PROJECT_NAME" "[BRANCH_NAME]" "[GITHUB_ROOT_URL:github.com]"
```

#### Remote repo

* List all remote repositories : ```gremotels```
* Merge another remote branch into local : ```gremotemerge "REPO_NAME" "PROJECT_NAME" "BRANCH_NAME" "[GITHUB_ROOT_URL:github.com]"```
* Remove particular remote repository : ```gremoterm "REMOTE_NAME"```


### Local commands

#### Git tags

* List tags : ```gtag```
* List tags & ISO date : ```gtagdate```
* Push a local tag to remote ```gtagpush "TAG_NAME"```

#### Git branches

* List all branches : ```gbrls```
* Create a new branch : ```gbradd "BRANCH_NAME:master" "[REPO_NAME:origin]"```
* Rename a branch : ```gbrmv "OLD_BRANCH_NAME" "NEW_BRANCH_NAME"```
* Remove a branch : ```gbrrm "BRANCH_NAME" "[FALLBACK_BRANCH_AFTER_DELETE:master]"```

#### Git patches

* Generate a diff file from local change : ```gpatch "DIFF_FILENAME"```
* Apply diff file into local repo : ```gpatchapply "DIFF_FILENAME"```

#### Configuration

* List all local configurations : ```gconfls```
* Set a new configuration : ```gconfset "CONF_PARAM_NAME" "CONF_PARAM_VALUE"```
* Configure user name : ```gconfsetname "NAME_PARAM_VALUE"```
* Configure email : ```gconfsetemail "EMAIL_PARAM_VALUE"```
* Configure proxy : ```gconfsetproxy "PROXY_PARAM_VALUE"```
