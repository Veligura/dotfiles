# Lazy-loading functionality
source ~/.zsh/sandboxd.zsh

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
