#!/bin/bash
set -e

SSHD_CFG="/etc/ssh/sshd_config"

backup() {
  cp "$SSHD_CFG" "$SSHD_CFG.bak.$(date +%F_%H-%M-%S)"
}

set_cfg() {
  local key="$1"
  local val="$2"
  if grep -qE "^#?$key" "$SSHD_CFG"; then
    sed -i "s|^#\?$key.*|$key $val|" "$SSHD_CFG"
  else
    echo "$key $val" >> "$SSHD_CFG"
  fi
}

echo "[*] Backup sshd_config"
backup

set_cfg "PasswordAuthentication" "yes"
set_cfg "PermitRootLogin" "yes"

echo "[*] Restarting SSH"
systemctl restart ssh || systemctl restart sshd
