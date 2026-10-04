#!/usr/bin/env sh

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/zed"
ZED_CONFIG_DIR="${ZED_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zed}"
BACKUP_ROOT="${ZED_BACKUP_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/zed-dotfiles}"
BACKUP_DIR="$BACKUP_ROOT/backup-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$ZED_CONFIG_DIR"

backup_if_exists() {
    path="$1"

    if [ -e "$path" ] || [ -L "$path" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -R "$path" "$BACKUP_DIR/"
        echo "Backed up: $path"
    fi
}

install_file() {
    name="$1"
    source_path="$SOURCE_DIR/$name"
    destination_path="$ZED_CONFIG_DIR/$name"

    if [ ! -f "$source_path" ]; then
        echo "Skipped missing repository file: $source_path"
        return
    fi

    backup_if_exists "$destination_path"
    cp "$source_path" "$destination_path"
    chmod 600 "$destination_path"

    echo "Installed: $destination_path"
}

install_file "settings.json"
install_file "keymap.json"
install_file "tasks.json"
install_file "debug.json"

echo

case "$(uname -s)" in
    Darwin)
        echo "Detected macOS."

        if command -v brew >/dev/null 2>&1; then
            if ! brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
                echo "Installing JetBrains Mono Nerd Font..."
                brew install --cask font-jetbrains-mono-nerd-font
            else
                echo "JetBrains Mono Nerd Font is already installed."
            fi
        else
            echo "Homebrew is not installed."
            echo "Install the font manually or install Homebrew first:"
            echo "  https://brew.sh"
        fi
        ;;

    Linux)
        echo "Detected Linux."
        echo "JetBrains Mono Nerd Font is not installed automatically."
        echo "Install it using your distribution package manager or Nerd Fonts."
        ;;

    *)
        echo "Unsupported OS for font installation: $(uname -s)"
        ;;
esac

echo
echo "Zed configuration installed."

if [ -f "$SOURCE_DIR/extensions.txt" ]; then
    echo
    echo "Expected extensions:"
    sed 's/^/  - /' "$SOURCE_DIR/extensions.txt"
    echo
    echo "Extensions listed in auto_install_extensions will be installed by Zed."
fi

if [ -d "$BACKUP_DIR" ]; then
    echo
    echo "Previous configuration backup:"
    echo "  $BACKUP_DIR"
fi

echo
echo "Restart Zed to apply all settings."

