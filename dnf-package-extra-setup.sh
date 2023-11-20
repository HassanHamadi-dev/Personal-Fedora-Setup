#!/bin/bash

# Install openrazer & polychromatic for razer mouse
sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/hardware:/razer/Fedora_$(rpm -E %fedora)/hardware:razer.repo
sudo dnf install polychromatic
sudo dnf install kernel-devel
sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/hardware:/razer/Fedora_$(rpm -E %fedora)/hardware:razer.repo
sudo dnf install openrazer-meta

# Installing Virtual Machine
sudo dnf install libvirt-devel virt-top libguestfs-tools
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

    # Check the status of libvirtd
    status=$(sudo systemctl status libvirtd | grep active | awk '{print $2}')

    # Check if libvirtd is active
    if [ "$status" = "active" ]; then
        notify-send "libvirtd Status" "libvirtd is currently active."
    else
        notify-send "libvirtd Status" "libvirtd is not active."
    fi

# Installing Visual Studio Code from Microsoft
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code

# Installing and Setting Up Wine
sudo dnf install wine
sudo dnf groupinstall "C Development Tools and Libraries"
sudo dnf groupinstall "Development Tools"
sudo dnf install wine-dxvk 
sudo dnf install winetricks
