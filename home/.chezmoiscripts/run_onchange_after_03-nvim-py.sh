#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION ---
PYENV_ROOT="$HOME/.pyenv"
PYTHON_VERSIONS=("3.13.3" "3.12.10")
VENV_NAME="nvim-venv"
VENV_PATH="$HOME/.config/nvim/$VENV_NAME"
NEOVIM_PKG="pynvim"

# --- Load Homebrew environment ---
BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
load_brew_env() {
  eval "$($BREW_BIN shellenv)"
}
load_brew_env

# --- 1) Ensure pyenv installed ---
if ! command -v pyenv >/dev/null 2>&1; then
  echo "[x] Installing pyenv..."
  brew install pyenv
  echo "[+] pyenv installed."
else
  echo "[✓] pyenv already installed."
fi

# --- 2) Ensure pyenv-virtualenv plugin ---
if [[ ! -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]]; then
  echo "[x] Installing pyenv-virtualenv..."
  git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
  echo "[+] pyenv-virtualenv installed."
else
  echo "[✓] pyenv-virtualenv already present."
fi

# --- Initialize pyenv environment ---
export PYENV_ROOT="$PYENV_ROOT"
export PATH="$PYENV_ROOT/bin:$PATH"
# Initialize pyenv and virtualenv support
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# --- 3) Install Python versions ---
for version in "${PYTHON_VERSIONS[@]}"; do
  if ! pyenv versions --bare | grep -qx "$version"; then
    echo "[x] Installing Python $version..."
    brew unlink pkg-config 2>/dev/null || true
    pyenv install "$version"
    brew link pkg-config 2>/dev/null || true
    echo "[+] Python $version installed."
  else
    echo "[✓] Python $version already installed."
  fi
done

# --- 4) Create or link virtualenv ---
if ! pyenv virtualenvs --bare | grep -qx "$VENV_NAME"; then
  echo "[x] Creating virtualenv $VENV_NAME..."
  pyenv virtualenv "${PYTHON_VERSIONS[0]}" "$VENV_NAME"
  mkdir -p "$(dirname "$VENV_PATH")"
  ln -sf "$PYENV_ROOT/versions/$VENV_NAME" "$VENV_PATH"
  echo "[+] Virtualenv $VENV_NAME created at $VENV_PATH."
else
  echo "[✓] Virtualenv $VENV_NAME already exists at $VENV_PATH."
fi

# --- 5) Install Neovim Python package ---
echo "[x] Installing Neovim Python package..."
"$VENV_PATH/bin/pip" install --upgrade pip
"$VENV_PATH/bin/pip" install "$NEOVIM_PKG"
echo "[✓] Neovim Python package installed."
