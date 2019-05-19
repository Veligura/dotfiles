# Lazy-loading functionality
source ~/.zsh/sandboxd.zsh
autoload -Uz compinit
compinit
kitty + complete setup zsh | source /dev/stdin

# Load environment variables
source ~/.zsh/environment.zsh

# Load plugins
source ~/.zsh/antigen.zsh

# Load custom configurations
source ~/.zsh/aliases.zsh
source ~/.zsh/fzf.zsh
source ~/.zsh/git.zsh
source ~/.zsh/ssh.zsh
source ~/.zsh/pacman.zsh
source ~/.zsh/mse.zsh

# Load machine-specific configurations
if [[ "$HOST" =~ "desktop-" ]]; then
  source ~/.zsh/autorun-tmux.zsh
elif [[ "$HOST" =~ "crmdevvm-" ]]; then
  source ~/.zsh/autorun-same-tmux.zsh
fi


# The following lines were added by compinstall


# End of lines added by compinstall
