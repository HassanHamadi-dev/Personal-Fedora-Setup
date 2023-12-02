#!/bin/bash

# File path
file_path="$HOME/.zshrc"

# Check if the file exists
if [ -f "$file_path" ]; then
    # Append aliases to the end of the file
    cat <<EOL >> "$file_path"
# Custom Aliases
alias update='sudo pacman -Syu ; sudo flatpak update'
alias vim='nvim'
alias ls='eza -l --icons'
alias reboot='sudo reboot now'
alias shutdown='sudo shutdown now'
EOL

    echo "Aliases added to $file_path"
else
    echo "File not found: $file_path"
fi
