#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION ---
OSRELEASE="${CHEZMOI_KERNEL_OSRELEASE:-}"

# --- Step 1: Patch SSH port on WSL kernels ---
if [[ "$OSRELEASE" == *[Ww][Ss][Ll]* || "$OSRELEASE" == *[Mm]icrosoft* ]]; then
  echo "[+] Detected WSL kernel: $OSRELEASE"
  SSHD_CONF="/etc/ssh/sshd_config"

  if grep -qE '^Port 2222' "$SSHD_CONF"; then
    echo "[✓] SSH port already set to 2222."
  elif grep -qE '^#Port 22' "$SSHD_CONF"; then
    echo "[+] Setting SSH port to 2222..."
    sudo sed -i 's/^#Port 22/Port 2222/' "$SSHD_CONF"
    echo "[✓] SSH port updated."
  else
    echo "[!] SSH port line not found or already customized; skipping."
  fi
else
  echo "[*] Non-WSL kernel detected; skipping SSH port patch."
fi

# --- Step 2: Ensure sshd service is active ---
if command -v systemctl &>/dev/null; then
  if systemctl is-active --quiet ssh; then
    echo "[~] Restarting ssh service..."
    sudo systemctl restart ssh
    echo "[✓] ssh service restarted."
  else
    echo "[+] Enabling and starting ssh service..."
    sudo systemctl enable --now ssh
    echo "[✓] ssh service enabled and started."
  fi
else
  echo "[!] systemctl not found; please ensure sshd is running manually."
fi
