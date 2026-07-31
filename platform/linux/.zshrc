# Configurazione specifica per Linux

# Rileva JAVA_HOME dalla posizione di javac
if command -v javac >/dev/null 2>&1; then
  JAVAC_PATH="$(readlink -f "$(command -v javac)")"
  export JAVA_HOME="$(dirname "$(dirname "$JAVAC_PATH")")"
  export PATH="$JAVA_HOME/bin:$PATH"
  unset JAVAC_PATH
fi

# Equivalente Linux del comando macOS "open"
if command -v xdg-open >/dev/null 2>&1; then
  alias open="xdg-open"
fi

