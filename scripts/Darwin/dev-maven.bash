import lib-dev-maven

# brew default installation folder
export MAVEN_HOME=/usr/local/opt/maven/libexec

# Skip nexus HTTPS invalid certificate
# export MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Xmx512m" 
# -Djavax.net.ssl.trustStore=~/keystore.jks -Djavax.net.ssl.trustStorePassword=123456 "

inst_maven() { # Install maven using brew
  brew install maven
}

mcompile() {
  mvn compile
}
mvndpsrc() {
  mvn source:jar-no-fork deploy -DskipTests -Denforcer.skip -DaltDeploymentRepository=D-SHC-00355713-release::default::http://D-SHC-00355713:8888/nexus/content/repositories/releases
}

mvnrun() {
  mvnsk spring-boot:run 
}

mvnrepocn() {
  local L_MVN_SETTINGS_FILE=settings_CN.xml

  # If MVN_SETTINGS_STANDALONE doesn't exist, try to use Maven one
  if [ ! -f "$MVN_REPO_ROOT/$L_MVN_SETTINGS_FILE" ]; then
      cp ~/scripts/cache_files/$L_MVN_SETTINGS_FILE $MVN_REPO_ROOT
  fi
  mvnreponexus CN	
}
