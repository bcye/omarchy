#!/bin/bash

omarchy_install_packages \
  brightnessctl playerctl pamixer wiremix wireplumber \
  fcitx5 fcitx5-gtk fcitx5-qt wl-clip-persist \
  nautilus sushi ffmpegthumbnailer gvfs-mtp \
  slurp satty \
  mpv evince imv \
  chromium

# Add screen recorder based on GPU
if lspci | grep -qi 'nvidia'; then
  omarchy_install_packages wf-recorder
else
  omarchy_install_packages wl-screenrec
fi
