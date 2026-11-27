#!/usr/bin/env bash
# Enlaza los dotfiles en $HOME. Con GNU Stow si está disponible;
# si no, con symlinks directos (sin dependencias).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(nvim zsh git tmux terminal)
TARGET="${HOME}"
STAMP="$(date +%Y%m%d-%H%M%S)"

log() { printf '==> %s\n' "$*"; }

backup_if_real() {
  local dest="$1"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    log "backup: $dest -> $dest.bak.$STAMP"
    mv "$dest" "$dest.bak.$STAMP"
  fi
}

link_with_stow() {
  cd "$REPO"
  stow --target="$TARGET" \
    --ignore='(^|/)README\.md' \
    --ignore='\.stow-local-ignore' \
    "${PACKAGES[@]}"
}

link_with_ln() {
  local pkg src rel dest
  for pkg in "${PACKAGES[@]}"; do
    while IFS= read -r -d '' src; do
      rel="${src#"$REPO/$pkg/"}"
      dest="$TARGET/$rel"
      mkdir -p "$(dirname "$dest")"
      backup_if_real "$dest"
      [[ -L "$dest" ]] && rm "$dest"
      ln -s "$src" "$dest"
    done < <(find "$REPO/$pkg" -type f -print0)
  done
}

if command -v stow >/dev/null 2>&1; then
  # Stow rechaza sobrescribir archivos reales: los respaldamos antes.
  for f in "$TARGET/.zshrc" "$TARGET/.p10k.zsh" "$TARGET/.gitconfig" \
           "$TARGET/.tmux.conf" "$TARGET/.config/nvim" "$TARGET/.config/alacritty"; do
    backup_if_real "$f"
  done
  link_with_stow
else
  log "GNU Stow no encontrado: uso symlinks directos."
  log "Para tener Stow en Arch: sudo pacman -S stow"
  link_with_ln
fi

log "Listo. Recarga la terminal con: source ~/.zshrc"
