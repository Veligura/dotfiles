export TERMINAL='alacritty'
export EDITOR='nvim'
export VISUAL='nvim'
export DIFFPROG='nvim -d'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export WORDCHARS='*?_.[]~&!#$%^(){}<>'

# Use gpg-agent as ssh-agent
if [[ "$HOST" =~ "desktop-" ]]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"
fi

# FZ configuration
export FZ_CMD=j
export FZ_SUBDIR_CMD=jj

# Pass configuration
export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9~!@#$%^&*()-_=+[]{};:,.<>?'
export PASSWORD_STORE_GENERATED_LENGTH=40

# Java configuration
export JAVA_HOME="/usr/lib/jvm/java-12-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"

# Maven configuration
export MAVEN_OPTS="-Xms1g -Xmx12g -XX:PermSize=1g"
export M3_HOME="/usr/share/maven3"
export PATH="$M3_HOME/bin:$PATH"

# Android configuration
export ANDROID_SDK_ROOT="$HOME/Android/sdk"

export ANDROID_HOME="$HOME/Android/Sdk"
# Haskell configuration
export PATH="$HOME/.cabal/bin:$PATH"

# Ruby configuration
if hash ruby 2>/dev/null; then
  export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
  export PATH="$GEM_HOME/bin:$PATH"
fi

# RVM configuration
sandbox_init_rvm() {
  if [ -f /usr/share/rvm/scripts/rvm ]; then
     source /usr/share/rvm/scripts/rvm
  fi
}
sandbox_hook rvm rvm
sandbox_hook rvm eyaml

# Go configuration
export GOPATH=/home/alex/.go
export PATH="$GOPATH/bin:$PATH"

# NPM configuration
export PATH="$HOME/.node_modules/bin:$PATH"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
