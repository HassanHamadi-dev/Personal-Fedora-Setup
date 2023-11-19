#!/bin/bash

flatpak install flathub org.signal.Signal -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub com.github.GradienceTeam.Gradience -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub com.getmailspring.Mailspring -y
flatpak install flathub com.brave.Browser -y
flatpak install flathub me.hyliu.fluentreader -y
flatpak install flathub com.heroicgameslauncher.hgl -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.stremio.Stremio -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub net.davidotek.pupgui2 -y

notify-send "Flatpak apps have been installed" --expire-time=10 --icon=dialog-information --urgency=low --category=system