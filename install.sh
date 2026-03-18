#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$BIN_DIR"

# Symlink para que los cambios en el proyecto se reflejen de inmediato
ln -sf "$SCRIPT_DIR/valet" "$BIN_DIR/valet"
chmod +x "$SCRIPT_DIR/valet"

# Verificar que ~/.local/bin está en el PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo ""
  echo "⚠️  $BIN_DIR no está en tu PATH."
  echo "   Añade esto a tu ~/.bashrc o ~/.zshrc y recarga la terminal:"
  echo ""
  echo '   export PATH="$HOME/.local/bin:$PATH"'
  echo ""
fi

echo "✅ valet-fedora instalado → $BIN_DIR/valet"
echo "   Próximo paso: valet install"
echo ""
