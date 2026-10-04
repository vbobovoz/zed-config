# Zed dotfiles

Portable Zed configuration for a Go/DevOps workflow on macOS and Linux.

## Included

- Kanagawa Wave dark theme and colored icons
- JetBrains Mono Nerd Font
- Go, YAML, Docker, Docker Compose, Helm, Kubernetes, GitLab CI, SQL and Terraform extensions
- AI edit predictions
- Rainbow brackets and indentation guides
- Project tree on the left, agent panel on the right and terminal at the bottom
- Custom split and tab shortcuts

## Install

```sh
git clone <repository-url> ~/zed-dotfiles
cd ~/zed-dotfiles
chmod +x install.sh export.sh
./install.sh
```

Restart Zed after installation. Zed installs extensions declared in `zed/settings.json` automatically. Sign in to Zed and external AI providers separately on each machine; credentials are not stored here.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| `Ctrl+Shift+Left` | Split editor left |
| `Ctrl+Shift+Right` | Split editor right |
| `Cmd+0..9` on macOS | Activate tab by position |
| `Ctrl+0..9` on Linux/Windows | Activate tab by position |

## Export current configuration

```sh
./export.sh
```

Review changes before committing:

```sh
git diff --check
git diff
```

## Safe installation test

The install destination can be overridden so the real Zed configuration is not touched:

```sh
rm -rf .test-home
ZED_CONFIG_DIR="$PWD/.test-home/.config/zed" \
ZED_BACKUP_DIR="$PWD/.test-home/backups" \
./install.sh

diff -u zed/settings.json .test-home/.config/zed/settings.json
diff -u zed/keymap.json .test-home/.config/zed/keymap.json
rm -rf .test-home
```

## Notes

- Existing configuration files are backed up under `~/.local/state/zed-dotfiles` by default.
- JetBrains Mono Nerd Font is installed automatically on macOS when Homebrew is available.
- Install the Nerd Font separately on Linux if it is not already present.
- Do not commit API keys, tokens, decrypted SOPS files or provider credentials.
