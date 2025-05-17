#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
FONT_URL="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf"
FONT_DIR="$HOME/.local/share/fonts"
FONT_FILE="$FONT_DIR/DroidSansMNerdFont-Regular.otf"
LG_BIN="$HOME/go/bin/lazygit"
YEK_CMD="yek"
PERL5_BASE="$HOME/perl5"
RUBY_GEM="neovim"

# --- CONFIG ---
BREW_PATH="/home/linuxbrew/.linuxbrew/bin"
BREW_BIN="$BREW_PATH/brew"

# --- Function to load brew environment into current shell ---
load_brew_env() {
  eval "$("$BREW_BIN" shellenv)"
}

load_brew_env

# --- 1) Nerd Font ---
echo "[x] Ensuring Nerd Font..."
mkdir -p "$FONT_DIR"
if [[ -f "$FONT_FILE" ]]; then
  echo "[✓] Nerd Font already installed."
else
  echo "[+] Downloading Nerd Font..."
  if curl -fsLo "$FONT_FILE" "$FONT_URL"; then
    echo "[✓] Nerd Font downloaded."
    fc-cache -f "$FONT_DIR"
  else
    echo "[✗] Failed to download Nerd Font."
  fi
fi

# --- 2) LazyGit via Go ---
echo "[x] Ensuring LazyGit..."
if [[ -f "$LG_BIN" ]]; then
  echo "[✓] LazyGit already installed at $LG_BIN."
else
  echo "[+] Installing LazyGit..."
  if command -v go >/dev/null 2>&1 && go install github.com/jesseduffield/lazygit@latest; then
    echo "[✓] LazyGit installed."
  else
    echo "[✗] Could not install LazyGit (is Go installed?)."
  fi
fi

# --- 3) Yek CLI ---
echo "[x] Ensuring Yek CLI..."
if command -v $YEK_CMD >/dev/null 2>&1; then
  echo "[✓] Yek CLI already installed."
else
  echo "[+] Installing Yek CLI..."
  if curl -fsSL https://bodo.run/yek.sh | bash; then
    echo "[✓] Yek CLI installed."
  else
    echo "[✗] Failed to install Yek CLI."
  fi
fi

# --- 4) Perl local::lib & Neovim::Ext ---
echo "[x] Configuring Perl local::lib..."
export PERL_LOCAL_LIB_ROOT="$PERL5_BASE"
export PERL_MB_OPT="--install_base $PERL5_BASE"
export PERL_MM_OPT="INSTALL_BASE=$PERL5_BASE"
export PERL5LIB="$PERL5_BASE/lib/perl5"
export PATH="$PERL5_BASE/bin:$PATH"

if ! command -v cpanm >/dev/null 2>&1; then
  echo "[+] Installing cpanm & local::lib..."
  if curl -L https://cpanmin.us | perl - --self-upgrade &&
    curl -L https://cpanmin.us | perl - App::cpanminus local::lib; then
    echo "[✓] cpanm & local::lib installed."
  else
    echo "[✗] Failed to install cpanm/local::lib."
  fi
else
  echo "[✓] cpanm already available."
fi

if perl -MNeovim::Ext -e1 >/dev/null 2>&1; then
  echo "[✓] Neovim::Ext already installed."
else
  echo "[+] Installing Neovim::Ext..."
  if cpanm --notest Neovim::Ext; then
    echo "[✓] Neovim::Ext installed."
  else
    echo "[✗] Failed to install Neovim::Ext."
  fi
fi

# --- 5) Ruby neovim gem ---
echo "[x] Ensuring Ruby gem '$RUBY_GEM'..."
if gem list -i "$RUBY_GEM" >/dev/null 2>&1; then
  echo "[✓] Ruby gem '$RUBY_GEM' already installed."
else
  echo "[+] Installing Ruby gem '$RUBY_GEM'..."
  if gem install "$RUBY_GEM"; then
    echo "[✓] Ruby gem '$RUBY_GEM' installed."
  else
    echo "[✗] Failed to install Ruby gem '$RUBY_GEM'."
  fi
fi
