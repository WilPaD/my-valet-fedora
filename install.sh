#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$BIN_DIR"

# Symlink para que los cambios en el proyecto se reflejen de inmediato
ln -sf "$SCRIPT_DIR/valet" "$BIN_DIR/valet"
chmod +x "$SCRIPT_DIR/valet"

# Shim de PHP: intercepta llamadas a `php` y resuelve la versión
# correcta según .php-version del proyecto (compatible con cualquier IDE)
cat > "$BIN_DIR/php" <<'SHIM'
#!/bin/bash
# Valet PHP shim — resuelve la versión de PHP según .php-version del proyecto

resolve_binary() {
  local version="$1"
  local ver="${version#php@}"
  local short="${ver/./}"
  for candidate in \
    "/usr/bin/php${short}" \
    "/opt/remi/php${short}/root/usr/bin/php"; do
    [ -x "$candidate" ] && { echo "$candidate"; return; }
  done
  echo "/usr/bin/php"
}

# Subir por los directorios buscando .php-version
dir="$PWD"
while [ "$dir" != "/" ]; do
  if [ -f "$dir/.php-version" ]; then
    exec "$(resolve_binary "$(cat "$dir/.php-version")")" "$@"
  fi
  dir=$(dirname "$dir")
done

# Sin .php-version — usar el global de valet o el sistema
valet_default="$HOME/.config/valet/default-php"
if [ -f "$valet_default" ]; then
  exec "$(resolve_binary "$(cat "$valet_default")")" "$@"
fi

exec /usr/bin/php "$@"
SHIM
chmod +x "$BIN_DIR/php"

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
echo "✅ PHP shim instalado   → $BIN_DIR/php"
echo "   Próximo paso: valet install"
echo ""
