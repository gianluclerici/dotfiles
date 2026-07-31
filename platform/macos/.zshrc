# Java 21 su macOS
if /usr/libexec/java_home -v 21 >/dev/null 2>&1; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 21)
  export PATH="$JAVA_HOME/bin:$PATH"
fi
