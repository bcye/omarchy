#!/bin/bash

if ! command -v tzupdate &>/dev/null; then
  omarchy_install_packages tzupdate
  sudo tee /etc/sudoers.d/omarchy-tzupdate >/dev/null <<EOF
%wheel ALL=(root) NOPASSWD: /usr/bin/tzupdate, /usr/bin/timedatectl
EOF
  sudo chmod 0440 /etc/sudoers.d/omarchy-tzupdate
fi
