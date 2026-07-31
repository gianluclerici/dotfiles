# Homebrew su Mac Apple Silicon
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

# Homebrew su Mac Intel
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"

# Homebrew su Linux
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Configurazione privata o specifica del computer
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
