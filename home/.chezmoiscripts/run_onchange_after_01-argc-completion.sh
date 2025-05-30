#!/bin/bash
set -euo pipefail

# --- CONFIGURATION ---
# Directory where the official argc-completions repo is cloned
ARGC_COMPLETIONS_DIR="$HOME/.config/argc-completions"
# Directory for local custom completion scripts
ARGC_COMPLETIONS_LOCAL_DIR="$HOME/.config/argc-completions.local"
# Git repository URL for the official argc-completions
ARGC_COMPLETIONS_REPO="https://github.com/sigoden/argc-completions.git"
# Output file to store the generated Zsh completion snippet
OUTPUT_FILE="$HOME/.argc-completion.zsh"

# --- 1. Clone or update the official completions repository ---
if [ -d "$ARGC_COMPLETIONS_DIR/.git" ]; then
  echo "[chezmoi:argc] Updating official argc-completions..."
  git -C "$ARGC_COMPLETIONS_DIR" pull --ff-only
else
  echo "[chezmoi:argc] Cloning official argc-completions..."
  git clone "$ARGC_COMPLETIONS_REPO" "$ARGC_COMPLETIONS_DIR"
fi

# --- 2. Generate the base completion snippet using setup-shell.sh ---
TMP_LOG="$(mktemp)"
(
  cd "$ARGC_COMPLETIONS_DIR"
  # Execute upstream setup-shell.sh to emit Zsh completion code
  ./scripts/setup-shell.sh zsh > "$TMP_LOG" 2>&1
)
# Extract only the code between ``` fences into the output file
sed -n '/^```$/,/^```$/{/^```$/d;p}' "$TMP_LOG" > "$OUTPUT_FILE"
rm -f "$TMP_LOG"

# --- 3. Override ARGC_COMPLETIONS_PATH to include local scripts ---
# Replace the existing ARGC_COMPLETIONS_PATH line to append the local directory
sed -i \
  "s|^export ARGC_COMPLETIONS_PATH=.*|export ARGC_COMPLETIONS_PATH=\"${ARGC_COMPLETIONS_DIR}/completions/linux:${ARGC_COMPLETIONS_DIR}/completions:${ARGC_COMPLETIONS_LOCAL_DIR}\"|" \
  "$OUTPUT_FILE"

# --- 4. Rebuild the list of scripts from both official and local directories ---
# Use mapfile to read script names into an array (_scripts)
mapfile -t _scripts < <(
  ls -p -1 \
    "$ARGC_COMPLETIONS_DIR/completions/linux" \
    "$ARGC_COMPLETIONS_DIR/completions" \
    "$ARGC_COMPLETIONS_LOCAL_DIR" 2>/dev/null \
  | sed -n 's/\.sh$//p'
)
# Join array elements into a single space-separated string for compdef
_scripts_str="${_scripts[*]}"

# --- 5. Replace the argc_scripts block with the merged list ---
# Overwrite the existing argc_scripts block (from its start line to the closing parenthesis)
sed -i "/^argc_scripts=(/,/)/c\\
argc_scripts=( ${_scripts_str} )" "$OUTPUT_FILE"

# --- 6. Ensure source invocation is present ---
# Remove any existing source line to avoid duplicates
sed -i '/^source <(argc --argc-completions zsh/ d' "$OUTPUT_FILE"
# Append correct source invocation using single quotes to avoid escaping issues
printf '%s\n' 'source <(argc --argc-completions zsh "${argc_scripts[@]}")' >> "$OUTPUT_FILE"
