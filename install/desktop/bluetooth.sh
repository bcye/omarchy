#!/bin/bash

# Install bluetooth controls
omarchy_install_packages blueberry

# Turn on bluetooth by default
sudo systemctl enable --now bluetooth.service
