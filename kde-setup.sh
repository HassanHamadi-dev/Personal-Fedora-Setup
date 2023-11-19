#!/bin/bash

# Get the directory where the script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change the working directory to the script's directory
cd "$script_dir" || exit 1

MY_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

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
                   1 "Enable RPM Fusion" \
                   2 "Speed Up DNF (Package Manager)" \
                   3 "Update System Firmware" \
                   4 "Set up flatpak" \
                   5 "Install Software" \
                   6 "Set Up Oh-My-Zsh & Starship" \
                   7 "Install Themes/Fonts/Codecs" \
                   8 "Install Nvidia Drivers Akmod-Nvidia" \
                   9 "exit" \
                   3>&1 1>&2 2>&3)


    case $choice in
        1)
            echo "Enabling RPM Fusion..."
            sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
            sudo dnf upgrade --refresh
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
            notify-send "RPM Fusion Enabled" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;
        2)
            echo "Speeding up DNF..."
            echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
            sudo dnf install deltarpm
            echo fastestmirror=true | sudo tee -a /etc/dnf/dnf.conf
            echo deltarpm=true | sudo tee -a /etc/dnf/dnf.conf
            sudo dnf clean all
            sudo dnf install dnf-plugins-core
            sudo dnf config-manager --setopt=fastestmirror=true --save
            notify-send "DNF has been sped up" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;
        3)
            echo "Updating System Firmware..."
            sudo fwupdmgr get-devices
            sudo fwupdmgr refresh --force
            sudo fwupdmgr get-updates
            sudo fwupdmgr update
            notify-send "System firmware has been updated" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;
        4)
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

            notify-send "Flatpak has been set up" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;
        5)
            echo "Installing Software..."
            read -rp "This will install packages listed in kde-dnf-packages.txt. Do you want to proceed? (y/n): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    sudo dnf install -y $(grep -v '^#' kde-dnf-packages.txt | xargs -n 1 dnf list installed | awk '{print $1}' | sort | uniq)
            else
                echo "Installation aborted."
            fi
            source dnf-package-extra-setup.sh
            notify-send "software has been installed w/ DNF" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;
        6)
            echo "Setting Up Oh-My-Zsh & Starship..."
            sudo dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            chsh -s "$(which zsh)"
            curl -sS https://starship.rs/install.sh | sh
            echo "eval "$(starship init zsh)"" >> ~/.zshrc
            notify-send "Oh-My-Zsh & Starship are ready to go" --expire-time=10 --icon=dialog-information --urgency=low --category=system
            ;;

        7)
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

        8)
            echo "Installing Nvidia Drivers Akmod-Nvidia..."
            sudo dnf install -y akmod-nvidia
            # Check if the NVIDIA kernel module is loaded
            if lsmod | grep -q "^nvidia "; then
                notify-send "Kernel Module Loaded" "The NVIDIA kernel module is loaded. It's safe to reboot." --expire-time=10 --icon=dialog-information --urgency=low --category=system
            else
                notify-send "Kernel Module Not Loaded" "The NVIDIA kernel module is not loaded yet." --expire-time=10 --icon=dialog-information --urgency=low --category=system
            fi
            ;;

        9)
            exit 0
            ;;

        *)
            echo "Invalid option"
            ;;
    esac

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


done
