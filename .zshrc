



################################################################################
# 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀 
# To start the ball, please call init script!!
# 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
################################################################################



################################################################################
#Initializing zsh with plugins
################################################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="random"
plugins=(git npm brew osx zsh-syntax-highlighting zsh-autosuggestions git-open)
#https://github.com/zsh-users/zsh-autosuggestions
#https://github.com/zsh-users/zsh-syntax-highlighting
source $ZSH/oh-my-zsh.sh

################################################################################
# Keybindings for Mac usage
################################################################################
# https://stackoverflow.com/a/16411270
bindkey -e
# Giving me alt left and right options to move the cursor
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word


################################################################################
#Theme powerlevel9k variables and methods
################################################################################
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"

################################################################################
#Setting up my bash history setup
################################################################################

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
autoload -U promptinit; promptinit
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.

################################################################################
#Sourcing and env variables
################################################################################
#z command https://github.com/rupa/z installed by brew
. `brew --prefix`/etc/profile.d/z.sh
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

################################################################################
#Functions to handle my environment
################################################################################

setjdk() {
  export JAVA_HOME=$(/usr/libexec/java_home -v $1)
}

#Set java version. Depends on what you have installed. /usr/libexec/java_home -V
#https://stackoverflow.com/questions/21964709/how-to-set-or-change-the-default-java-jdk-version-on-os-x
export JAVA_HOME=`/usr/libexec/java_home`
export ANDROID_HOME="$HOME/code/android"
export PATH=${PATH}:${ANDROID_HOME}
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/tools/bin
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

export FASTLANE="$HOME/.fastlane"
export PATH=${PATH}:${FASTLANE}/bin

export EXECUTABLES="$HOME/code/executables"
export PATH=${PATH}:${EXECUTABLES}

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT:$GOPATH:$GOBIN

export CLOUDSDK_PYTHON=/Users/snorre/.pyenv/shims/python

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/code/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/code/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/code/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/code/google-cloud-sdk/completion.zsh.inc"; fi

# Rbenv - https://github.com/rbenv/rbenv
eval "$(rbenv init -)"

# Pyenv - https://github.com/pyenv/pyenv
eval "$(pyenv init -)"

# Fastlane
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

################################################################################
# Initializing All the things
################################################################################
startsetup () {
  setupcoding
  setuposwithbrew
  setupruby
}

################################################################################
# Initializing All things I need to install via brew
################################################################################

setuposwithbrew () {
  brew update

  echo "Installing brew updates and defaults"
  brew tap homebrew/dupes
  brew install coreutils

  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
  brew install findutils

  # Install Bash 4
  brew install bash

  echo "Installing packages I want"
  brew install rust
  brew install diff-so-fancy
  brew install deno
  brew install rbenv
  brew install terraform
  brew install kubectl
  brew install pyenv
  brew install cocoapods
  brew install --cask google-cloud-sdk
  brew install --cask adoptopenjdk
  brew install --cask google-chrome
  brew install --cask visual-studio-code
  brew install --cask slack
  brew install postgresql
}

################################################################################
# Setup ready for coding
################################################################################

setupcoding () {
  echo "Setup some code related vars and simple executables"
  mkdir "$HOME/code"
  mkdir "$HOME/code/executables"
  cd "$HOME/code/executables"
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && chmod +x minikube
  cd "$HOME"
}

RUBY_GEMS=(
    bundler
    filewatcher
)

setupruby () {
  echo "Installing Ruby gems"
  sudo gem install ${RUBY_GEMS[@]}
}

################################################################################
#Aliases
################################################################################
alias reload='. ~/.zshrc' #Reload the source
port () {lsof -i :"$1";}
alias f='open -a Finder ./'
alias size='du -sh'
alias bundletools='java -jar ~/code/scripts/bundletool.jar'
getEditorConfig () {
  cp ~/.dotfiles/personal/.editorconfig $1
}
kickstart () {
  mkdir $1 && cd $1 && git init && yarn init --yes && code .
  touch .gitignore
  getEditorConfig $(pwd)
  echo "You're fricking awesome 🤘 ✌️ 🤙"
}
