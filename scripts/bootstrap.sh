#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_LINK="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

run() {
  if $DRY_RUN; then
    printf '[anteprima] '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

link_file() {
  local source="$1"
  local destination="$2"
  local relative="${destination#"$HOME"/}"

  if [[ -L "$destination" ]] &&
     [[ "$(readlink "$destination")" == "$source" ]]; then
    echo "Già collegato: $destination"
    return
  fi

  if [[ -e "$destination" || -L "$destination" ]]; then
    echo "Backup: $destination"
    run mkdir -p "$BACKUP_DIR/$(dirname "$relative")"
    run mv "$destination" "$BACKUP_DIR/$relative"
  fi

  echo "Collegamento: $destination -> $source"
  run mkdir -p "$(dirname "$destination")"
  run ln -s "$source" "$destination"
}

echo "Repository: $DOTFILES_DIR"
echo "Sistema: $(uname -s)"

if [[ -e "$DOTFILES_LINK" || -L "$DOTFILES_LINK" ]]; then
  if [[ -L "$DOTFILES_LINK" ]] &&
     [[ "$(readlink "$DOTFILES_LINK")" == "$DOTFILES_DIR" ]]; then
    echo "Alias del repository già presente: $DOTFILES_LINK"
  else
    echo "Errore: $DOTFILES_LINK esiste già e punta altrove."
    echo "Controllalo manualmente prima di continuare."
    exit 1
  fi
else
  echo "Alias repository: $DOTFILES_LINK -> $DOTFILES_DIR"
  run ln -s "$DOTFILES_DIR" "$DOTFILES_LINK"
fi

link_file "$DOTFILES_LINK/home/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_LINK/home/.zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_LINK/home/.gitconfig" "$HOME/.gitconfig"
link_file \
  "$DOTFILES_LINK/home/.config/starship.toml" \
  "$HOME/.config/starship.toml"

if [[ -d "$DOTFILES_LINK/home/.config/wezterm" ]]; then
  link_file \
    "$DOTFILES_LINK/home/.config/wezterm" \
    "$HOME/.config/wezterm"
fi

if $DRY_RUN; then
  echo "Anteprima completata: nessun file è stato modificato."
else
  echo "Configurazione completata."
  echo "Eventuali originali si trovano in: $BACKUP_DIR"
fi
