#!/bin/bash

if [ -z "$OMARCHY_BARE" ]; then
  omarchy_install_packages \
    gnome-calculator gnome-keyring signal-desktop \
    obsidian-bin libreoffice obs-studio kdenlive \
    xournalpp localsend-bin

  # Packages known to be flaky or having key signing issues are run one-by-one
  for pkg in pinta typora spotify zoom; do
    omarchy_install_packages "$pkg" ||
      echo -e "\e[31mFailed to install $pkg. Continuing without!\e[0m"
  done

  omarchy_install_packages 1password-beta 1password-cli ||
    echo -e "\e[31mFailed to install 1password. Continuing without!\e[0m"
fi

# Copy over Omarchy applications
source omarchy-refresh-applications || true
