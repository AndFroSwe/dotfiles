#!/usr/bin/env bash
echo "Starting dotfile bootstrap script for Linux/macOS..."

CONFIG_DIR="$HOME/.config"

# Create .config if missing
[[ -d $CONFIG_DIR ]] || {
  echo "Config folder does not exist at $CONFIG_DIR, creating..."
  mkdir -p "$CONFIG_DIR"
}

# Define dotfiles:  source|targetDir|targetFile   (pipe-separated)
read -r -d '' DOTFILES <<'EOF'
shared/oh-my-posh/andfro.omp.json|.config/oh-my-posh|andfro.omp.json
shared/wezterm/wezterm.lua|.config/wezterm|wezterm.lua
shared/spotify-player/app.toml|.config/spotify-player|app.toml
shared/cava/config|.config/cava|config
arch/hypr/|.config|hypr
arch/waybar|.config|waybar
EOF

read -r -p "User reset mode? This will DELETE all existing config files and replace them with symlinks! [y/n] " RESET_MODE
RESET_MODE=${RESET_MODE,,}

while IFS='|' read -r SOURCE TARGET_DIR TARGET_FILE; do
  echo -e "\nSetting up $SOURCE..."
  TARGET_PATH="$HOME/$TARGET_DIR/$TARGET_FILE"
  mkdir -p "$HOME/$TARGET_DIR"

  if [[ -e $TARGET_PATH ]]; then
    if [[ $RESET_MODE == "y" ]]; then
      echo "Dotfile already existed at $TARGET_PATH, removing..."
      rm -rf "$TARGET_PATH"
    else
      echo "Dotfile already exists at $TARGET_PATH. Remove it manually if you want to recreate the link. Skipping..."
      continue
    fi
  fi

  echo "Creating symlink: $TARGET_PATH -> $PWD/$SOURCE"
  ln -s "$PWD/$SOURCE" "$TARGET_PATH"
done <<<"$DOTFILES"

echo -e "\nDotfile setup complete!"
