# Configurazione zsh condivisa tra macOS e Linux

export EDITOR="code --wait"

# Alias comuni
alias ll="ls -lah"
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
alias c="clear"

# Carica la configurazione del sistema operativo
case "$(uname -s)" in
  Darwin)
    [[ -f "$HOME/.dotfiles/platform/macos/.zshrc" ]] &&
      source "$HOME/.dotfiles/platform/macos/.zshrc"
    ;;
  Linux)
    [[ -f "$HOME/.dotfiles/platform/linux/.zshrc" ]] &&
      source "$HOME/.dotfiles/platform/linux/.zshrc"
    ;;
esac

# Configurazione privata o specifica del singolo computer
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Prompt Starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
