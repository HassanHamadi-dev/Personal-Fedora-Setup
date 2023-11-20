#!/bin/bash

if [ $(rpm -q dialog 2>/dev/null | grep -c "is not installed") -eq 1 ]; then
sudo dnf install -y dialog
fi

# Get the directory where the script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change the working directory to the script's directory
cd "$script_dir" || exit 1

MY_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin


move_folder() {
    source_folder_path="$1"
    target_folder_path="$2"

    if [ -d "$source_folder_path" ]; then
        echo "Moving $source_folder_path to $target_folder_path"
        mv "$source_folder_path" "$target_folder_path"
        notify-send "$source_folder_path Moved" "$source_folder_path moved to $target_folder_path" --expire-time=10 --icon=dialog-information --urgency=low --category=system
    else
        notify-send "Error" "$source_folder_path not found in the repository." --expire-time=10 --icon=dialog-information --urgency=low --category=system
    fi
}

move_folder "./.local/share/fonts" "$HOME/.local/share/"
move_folder "./walls" "$HOME/Pictures/"
move_folder "./alacritty" "$HOME/.config/"
move_folder "./.zshrc" "$HOME/"

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="Fedora Setup Tool"
TITLE="Please Make a Selection"
MENU="Choose one of the following options:"


while true; do
    choice=$(dialog --clear \
                   --backtitle "$BACKTITLE" \
                   --title "$TITLE" \
                   --menu "$MENU" \
                   $HEIGHT $WIDTH $CHOICE_HEIGHT \
                   1 "Speed Up DNF (Package Manager)" \
                   2 "Enable RPM Fusion" \
                   3 "Set up flatpak" \
                   4 "Install Software" \
                   5 "Set Up Oh-My-Zsh & Starship" \
                   6 "Install Themes/Fonts/Codecs" \
                   7 "Install Nvidia Drivers Akmod-Nvidia" \
                   8 "exit" \
                   3>&1 1>&2 2>&3)


    case $choice in
        1)
            echo "Speeding up DNF..."
            echo 'defaultyes=True' | sudo tee -a /etc/dnf/dnf.conf
            echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
            sudo dnf install deltarpm
            echo fastestmirror=true | sudo tee -a /etc/dnf/dnf.conf
            echo deltarpm=true | sudo tee -a /etc/dnf/dnf.conf
            sudo dnf clean all
            sudo dnf install dnf-plugins-core
            sudo dnf config-manager --setopt=fastestmirror=true --save
            notify-send "DNF has been sped up" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;
            
        2)
            echo "Enabling RPM Fusion..."
            sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
            sudo dnf upgrade --refresh
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
            notify-send "RPM Fusion Enabled" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;

        3)
            echo "Enabling Flatpak..."
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            flatpak update
            read -rp "Do you want to install Flatpak apps? (y/n): " install_apps

            case $install_apps in
                [Yy]|[Yy][Ee][Ss])
                    chmod +x flatpak-apps.sh
                    ./flatpak-apps.sh
                    ;;
                [Nn]|[Nn][Oo])
                    echo "Flatpak apps will not be installed."
                    ;;
                *)
                    echo "Invalid input. Flatpak apps will not be installed."
                    ;;
            esac
            ;;

        4)
            echo "Installing Software..."
            package_file="$script_dir/gnome-dnf-packages.txt"

            if [ -f "$package_file" ]; then
                # Read each line from the package file and install the package
                while IFS= read -r package; do
                     if [ -n "$package" ]; then
                        echo "Installing: $package"
                        sudo dnf install -y "$package"
                    fi
                done < "$package_file"

                echo "Installation completed."
                source dnf-package-extra-setup.sh
                notify-send "Software has been installed with DNF" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            else
                echo "Error: Package file $package_file not found."
                notify-send "Error" "Package file $package_file not found." --expire-time=10 --icon=dialog-error --urgency=low --category=system
            fi
            ;;
            
        5)
            echo "Setting Up Oh-My-Zsh & Starship..."
            sudo dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            chsh -s "$(which zsh)"
            curl -sS https://starship.rs/install.sh | sh
            echo "eval "$(starship init zsh)"" >> ~/.zshrc
            notify-send "Oh-My-Zsh & Starship are ready to go" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;

        6)
            echo "Installing Themes/Fonts/Codecs..."
            rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
            sudo dnf groupupdate -y sound-and-video
            sudo dnf install -y libdvdcss
            sudo dnf install ffmpeg ffmpeg-libs
            sudo dnf install gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer-ffmpeg
            sudo dnf install -y lame\* --exclude=lame-devel
            sudo dnf groupupdate sound-and-video sudo dnf install -y libdvdcss
            sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264
            sudo dnf config-manager --set-enabled fedora-cisco-openh264
            sudo dnf group upgrade -y --with-optional Multimedia
            sudo dnf copr enable peterwu/iosevka -y
            sudo -s dnf -y copr enable dawid/better_fonts
                sudo dnf update -y
            sudo -s dnf install -y fontconfig-font-replacements
            sudo -s dnf install -y fontconfig-enhanced-defaults
                sudo dnf update -y
            sudo dnf install -y iosevka-term-fonts jetbrains-mono-fonts-all terminus-fonts terminus-fonts-console google-noto-fonts-common mscore-fonts-all fira-code-fonts Lightly papirus-icon-theme
            mkdir Repos/
            cd Repos/
            git clone https://github.com/vinceliuice/Qogir-kde.git
            cd Qogir-kde/
            ./install.sh 

            cd Repos/
            git clone https://github.com/vinceliuice/Fluent-icon-theme.git
            cd Fluent-icon-theme/
            ./install.sh -a

            notify-send "Themes/Fonts/Codecs Complete" --expire-time=10 --icon=dialog-information --urgency=low --category=system   
            ;;

        7)
            echo "Installing Nvidia Drivers Akmod-Nvidia..."
            sudo dnf install -y akmod-nvidia
            # Check if the NVIDIA kernel module is loaded
            if lsmod | grep -q "^nvidia "; then
                notify-send "Kernel Module Loaded" "The NVIDIA kernel module is loaded. It's safe to reboot." --expire-time=10 --icon=dialog-information --urgency=low --category=system
            else
                notify-send "Kernel Module Not Loaded" "The NVIDIA kernel module is not loaded yet." --expire-time=10 --icon=dialog-information --urgency=low --category=system
            fi
            ;;

        8)
            exit 0
            ;;

        *)
            echo "Invalid option"
            ;;
    esac
done
