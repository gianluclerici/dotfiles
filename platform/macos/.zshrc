# Java 21 su macOS
if /usr/libexec/java_home -v 21 >/dev/null 2>&1; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 21)
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# Flutter SDK su macOS
if [[ -d "$HOME/SDKs/flutter/bin" && ":$PATH:" != *":$HOME/SDKs/flutter/bin:"* ]]; then
  export PATH="$HOME/SDKs/flutter/bin:$PATH"
fi

# Android SDK su macOS
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"

  for android_path in \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/emulator" \
    "$ANDROID_HOME/cmdline-tools/latest/bin"; do
    if [[ -d "$android_path" && ":$PATH:" != *":$android_path:"* ]]; then
      export PATH="$android_path:$PATH"
    fi
  done
  unset android_path
fi
