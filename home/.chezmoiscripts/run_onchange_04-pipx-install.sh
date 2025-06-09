#!/bin/bash
set -euo pipefail

# --- Ensure pipx is available ---
if ! command -v pipx >/dev/null 2>&1; then
  echo "[✗] ERROR - pipx not found. Please install it via Homebrew first."
  exit 1
fi

# --- Ensure ~/.local/bin is in PATH for current session ---
export PATH="$HOME/.local/bin:$PATH"

	# --- Install function ----------------------------------
	# Usage: install_with_pipx <source> [<override_name>] [<flags>...]
	#   <source>        : argument passed to `pipx install`, e.g. "poetry" or "git+https://..."
	#   [<override_name>]: optional name to search for in `pipx list` (defaults to basename of source)
	#   [<flags>...]    : additional flags to pass to `pipx install`
	install_with_pipx() {
	  local source="$1"
	  shift
	  local override_name=""
	  local flags=()

	  if [[ $# -eq 1 && ! "$1" =~ ^- ]]; then
	    override_name="$1"
	  elif [[ $# -gt 0 ]]; then
	    flags=("$@")
	  fi

	  local name
	  if [[ -n "$override_name" ]]; then
	    name="$override_name"
	  else
	    if [[ "$source" == git+* ]]; then
	      name="$(basename "${source%.git}")"
	    else
	      name="$source"
	    fi
	  fi

	  if pipx list | grep -qE "^package $name\b"; then
	    echo "[✓] pipx package '$name' is already installed."
	  else
	    echo "[+] Installing pipx package '$name' from '$source'..."
	    if pipx install "$source" "${flags[@]}"; then
	      echo "[✓] Successfully installed '$name'."
	    else
	      echo "[✗] Failed to install '$name'."
	    fi
	  fi
	}

# --- pipx Packages to Install --------------------------
install_with_pipx poetry
install_with_pipx ruff
install_with_pipx uv
install_with_pipx pre-commit
install_with_pipx yt-dlp
install_with_pipx openai-whisper
install_with_pipx openai
install_with_pipx pylatexenc
install_with_pipx pylatexenc
install_with_pipx netron
install_with_pipx git+https://github.com/openai/whisper.git whisper
install_with_pipx aider-chat --python 3.12
