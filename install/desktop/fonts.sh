#!/bin/bash

omarchy_install_packages ttf-font-awesome ttf-cascadia-mono-nerd ttf-ia-writer noto-fonts noto-fonts-emoji

if [ -z "$OMARCHY_BARE" ]; then
  omarchy_install_packages ttf-jetbrains-mono noto-fonts-cjk noto-fonts-extra
fi
