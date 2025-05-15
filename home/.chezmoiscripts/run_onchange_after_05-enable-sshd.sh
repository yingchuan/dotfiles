#!/bin/bash

set -euo pipefail

# Detect kernel type from chezmoi-provided variable
osrelease="${CHEZMOI_KERNEL_OSRELEASE:-}"

# Step 1: If running in WSL (match "wsl" or "microsoft" in osrelease), patch sshd_config port
if echo "$osrelease" | grep -iqE 'wsl|microsoft'; then
  echo "[+] Detected WSL-based kernel: $osrelease"
  if sudo grep -q '^#Port 22' /etc/ssh/sshd_config; then
    echo "[+] Changing SSH port to 2222 in /etc/ssh/sshd_config"
    sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
  else
    echo "[*] Port already changed or manually modified."
  fi
else
  echo "[*] Non-WSL kernel detected. Skipping SSH port modification."
fi

# Step 2: Ensure sshd is running
if systemctl is-active --quiet ssh; then
  echo "[+] sshd is active. Restarting..."
  sudo systemctl restart ssh
else
  echo "[+] sshd is inactive. Enabling and starting..."
  sudo systemctl enable --now ssh
fi
