# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

plugins=(zsh-completions zsh-autosuggestions)

source ~/path/to/fsh/fast-syntax-highlighting.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=(path/to/zsh-completions/src $fpath)

#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#
# Alias
alias update='sudo pacman -Syu ; yay -Syu ; sudo flatpak update'
alias vim='nvim'
alias ls='eza -l --icons'
alias reboot='sudo reboot now'
alias shutdown='sudo shutdown now'
#alias weather='weather --city Windsor --country Canada'

# Auto run commands
#colorscript random
#cpufetch
#colorscript random
#neofetch
