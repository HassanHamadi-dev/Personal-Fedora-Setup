# Personal-Fedora-Setup

# Some of the following applies to Gnome, but most is for KDE.

## Script Usage

For KDE desktop environments run:
```bash
chmod +x kde-setup.sh
./kde-setup.sh
```

For Gnome desktop environments run:
```bash
chmod +x gnome-setup.sh
./gnome-setup.sh
```

## Post Script

### Move the fonts, alacritty, walls files with the following commands and install proper fonts for terminal
```bash
mv .local/share/fonts ~/.local/share/
fc-cache --force
```
```bash
mv walls ~/Pictures/
```
#### install the following fonts (provided from the [powerlevel10k github](https://github.com/romkatv/powerlevel10k)):
[MesloLGS NF Regular.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
[MesloLGS NF Bold.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
[MesloLGS NF Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
[MesloLGS NF Bold Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)

```bash
fc-cache --force
```

```bash
mv .config/alacritty ~/.config/
```

### Settings to Change 
Global: Andromeda
Application Style:  Lightly (Transparency -> Menu -> Second to last setting / Sidebars -> Last setting)
Plasma Style: Andromeda
Colors: Andromeda
Window Decorations: Andromeda
Icons: ePapirus-Dark
Cursor: Vimix Cusrsors
Splash Screen: None for faster loading time (at least it feels like it, worth a try)



# Credit
Ideas and foundation from [smittix](https://github.com/smittix/fedora-setup)
