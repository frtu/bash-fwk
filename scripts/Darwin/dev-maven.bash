import lib-dev-maven

# brew default installation folder
export MAVEN_HOME=/usr/local/opt/maven/libexec

# Skip nexus HTTPS invalid certificate
# export MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Xmx512m" 
# -Djavax.net.ssl.trustStore=~/keystore.jks -Djavax.net.ssl.trustStorePassword=123456 "

inst_maven() { # Install maven using brew
  brew install maven
}

