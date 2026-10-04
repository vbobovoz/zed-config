#!/usr/bin/env sh

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DEST_DIR="$SCRIPT_DIR/zed"

mkdir -p "$DEST_DIR"

ZED_CONFIG_DIR="${ZED_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zed}"

if [ ! -d "$ZED_CONFIG_DIR" ]; then
    echo "Zed config directory not found: $ZED_CONFIG_DIR" >&2
    exit 1
fi

copy_if_exists() {
    source_path="$1"
    destination_path="$2"

    if [ -f "$source_path" ]; then
        cp "$source_path" "$destination_path"
        echo "Exported: $source_path"
    else
        echo "Skipped missing file: $source_path"
    fi
}

copy_if_exists \
    "$ZED_CONFIG_DIR/settings.json" \
    "$DEST_DIR/settings.json"

copy_if_exists \
    "$ZED_CONFIG_DIR/keymap.json" \
    "$DEST_DIR/keymap.json"

copy_if_exists \
    "$ZED_CONFIG_DIR/tasks.json" \
    "$DEST_DIR/tasks.json"

copy_if_exists \
    "$ZED_CONFIG_DIR/debug.json" \
    "$DEST_DIR/debug.json"

case "$(uname -s)" in
    Darwin)
        EXTENSIONS_DIR="$HOME/Library/Application Support/Zed/extensions/installed"
        ;;
    Linux)
        EXTENSIONS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zed/extensions/installed"
        ;;
    *)
        EXTENSIONS_DIR=""
        ;;
esac

EXTENSIONS_FILE="$DEST_DIR/extensions.txt"

if [ -n "$EXTENSIONS_DIR" ] && [ -d "$EXTENSIONS_DIR" ]; then
    find "$EXTENSIONS_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -exec basename {} \; |
        LC_ALL=C sort -u > "$EXTENSIONS_FILE"

    echo "Exported extension IDs:"
    sed 's/^/  - /' "$EXTENSIONS_FILE"
else
    : > "$EXTENSIONS_FILE"
    echo "Extension directory not found; created empty $EXTENSIONS_FILE"
fi

echo
echo "Export complete: $DEST_DIR"
echo "Review files before committing them."

