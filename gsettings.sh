#!/bin/bash

#Font Settings
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 10'
gsettings set org.gnome.desktop.interface font-name 'Noto Sans 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Sans 10'

# Enable window buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Set new windows centered
gsettings set org.gnome.mutter center-new-windows true