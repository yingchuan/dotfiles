#!/bin/bash
set -euo pipefail

# --- Configurable paths ---
CONFIG_DIR="$HOME/.tmux"
SOURCE_FILE="$CONFIG_DIR/.tmux.conf"
TARGET_FILE="$HOME/.tmux.conf"

# --- Ensure the source directory and file exist ---
if [ ! -d "$CONFIG_DIR" ]; then
  echo "[✗] Directory '$CONFIG_DIR' not found. Skipping tmux config link."
  exit 1
fi

if [ ! -f "$SOURCE_FILE" ]; then
  echo "[✗] Source file '$SOURCE_FILE' not found. Skipping tmux config link."
  exit 1
fi

# --- Create or update the symlink ---
if [ -L "$TARGET_FILE" ]; then
  # Already a symlink — check target
  if [ "$(readlink "$TARGET_FILE")" = "$SOURCE_FILE" ]; then
    echo "[✓] Symlink '$TARGET_FILE' already points to '$SOURCE_FILE'."
  else
    echo "[~] Updating symlink '$TARGET_FILE' to point to '$SOURCE_FILE'."
    ln -sf "$SOURCE_FILE" "$TARGET_FILE"
  fi

elif [ -e "$TARGET_FILE" ]; then
  # Something exists (regular file or directory) — back it up
  echo "[!] Regular file or directory '$TARGET_FILE' exists; backing up to '${TARGET_FILE}.bak'."
  mv "$TARGET_FILE" "${TARGET_FILE}.bak"
  echo "[+] Creating symlink '$TARGET_FILE' → '$SOURCE_FILE'."
  ln -s "$SOURCE_FILE" "$TARGET_FILE"

else
  # Nothing exists — create the symlink
  echo "[+] Creating symlink '$TARGET_FILE' → '$SOURCE_FILE'."
  ln -s "$SOURCE_FILE" "$TARGET_FILE"
fi
