#!/bin/bash

# Package installation wrapper that handles CONFIRM_AUR environment variable
# This function replaces direct yay -S calls to provide AUR package confirmation

omarchy_install_packages() {
  local packages=("$@")
  local aur_packages=()
  local official_packages=()
  
  # If CONFIRM_AUR is not set or not equal to 1, use normal yay command
  if [[ "${CONFIRM_AUR}" != "1" ]]; then
    yay -S --noconfirm --needed "${packages[@]}"
    return $?
  fi
  
  # Separate AUR packages from official packages
  for pkg in "${packages[@]}"; do
    # Check if package is available in official repositories first
    # Use pacman to check official repos (including chaotic-aur if enabled)
    if pacman -Ssq "^${pkg}$" >/dev/null 2>&1; then
      official_packages+=("$pkg")
    else
      # Check if it's available in AUR using yay
      if yay -Ssq --aur "^${pkg}$" >/dev/null 2>&1; then
        aur_packages+=("$pkg")
      else
        # Package not found in either, let yay handle the error
        # Add to official packages so yay can give proper error message
        official_packages+=("$pkg")
      fi
    fi
  done
  
  # Install official packages without confirmation
  if [[ ${#official_packages[@]} -gt 0 ]]; then
    echo "Installing official packages: ${official_packages[*]}"
    yay -S --noconfirm --needed "${official_packages[@]}"
    local official_exit_code=$?
    if [[ $official_exit_code -ne 0 ]]; then
      echo "Warning: Some official packages failed to install"
    fi
  fi
  
  # Handle AUR packages with confirmation
  for pkg in "${aur_packages[@]}"; do
    echo "========================================="
    echo "About to install AUR package: $pkg"
    echo "========================================="
    
    # Show PKGBUILD
    echo "PKGBUILD for $pkg:"
    echo "-------------------------------------"
    
    # Create temporary directory for downloading PKGBUILD
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    if yay -G "$pkg" --noconfirm >/dev/null 2>&1 && [[ -d "$pkg" ]]; then
      cat "$pkg/PKGBUILD" 2>/dev/null || echo "Could not display PKGBUILD for $pkg"
    else
      echo "Could not retrieve PKGBUILD for $pkg"
    fi
    echo "-------------------------------------"
    
    # Ask for confirmation
    while true; do
      read -p "Do you want to install $pkg? (y/n): " yn
      case $yn in
        [Yy]* ) 
          echo "Installing $pkg..."
          cd - >/dev/null
          yay -S --noconfirm --needed "$pkg"
          break
          ;;
        [Nn]* ) 
          echo "Skipping $pkg"
          cd - >/dev/null
          break
          ;;
        * ) 
          echo "Please answer yes or no."
          ;;
      esac
    done
    
    # Clean up temp directory
    rm -rf "$temp_dir"
  done
}