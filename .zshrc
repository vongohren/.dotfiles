



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
nvm use v14.19.2 --silent

setupdocker()

#Setting begining of java
jabba use openjdk@1.17.0 

################################################################################
#Functions to handle my environment
################################################################################

export FASTLANE="$HOME/.fastlane"
export PATH=${PATH}:${FASTLANE}/bin

export EXECUTABLES="$HOME/code/executables"
export PATH=${PATH}:${EXECUTABLES}

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT:$GOPATH:$GOBIN

# Google cloud sdk python version and setup
export CLOUDSDK_PYTHON=$(pyenv root)/shims/python
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# Rbenv - https://github.com/rbenv/rbenv
eval "$(rbenv init -)"

# Pyenv - https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; 
then eval "$(pyenv init -)" 
fi

# Needed because of this: https://github.com/pyenv/pyenv/issues/1764#issuecomment-819395442
pyenvinstall () {
  LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib" CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include" pyenv install $1
}

# Fastlane
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Global yarn modules
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Div stuff
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

################################################################################
# Initializing All the things
################################################################################
startsetup () {
  setupos
  setupcoding
}

################################################################################
# Initializing All things I need to install via brew
################################################################################

setupos () {
  brew update

  echo "Installing brew updates and defaults"
  brew tap homebrew/dupes
  brew install coreutils

  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
  brew install findutils

  # Install Bash 4
  brew install bash

  echo "Installing packages I want"

  # Utilties
  brew install defaultbrowser

  # General tools for mac
  brew install --cask raycast
  brew install --cask slack
  brew install --cask google-chrome
  osascript ~/.dotfiles/scripts/setdefaultbrowserauto.scpt chrome

  # Coding CLI tools for being able to develop as I want
  brew tap homebrew/cask-fonts
  brew install --cask font-fira-code
  brew install rust
  brew install diff-so-fancy
  brew install postgresql
  brew install deno
  brew install tfenv
  
  brew install kubectl
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True

  brew install cocoapods
  brew install --cask google-cloud-sdk
  brew install --cask adoptopenjdk
  brew install jq
  brew install redis

  # Hammerspoon setup
  setuphammerspoon
  
  # Android development setup
  setupandroid

  # Docker setup
  setupdocker
  
  # Python setup
  setuppython

  # Ruby setup
  setupruby

  # Setup Visual Code
  setupvisualcode
  
  # Coding tools
  brew install --cask github
  brew install --cask postman
  brew install --cask dbeaver-community

  export JABBA_VERSION=0.11.2                                                                                                      ~/.dotfiles(master✗)@Snorres-MacBook-Pro.local
  curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
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

setupandroid() {
  # Need the tools to connect to the phone, adb comes with platform tools
  # If you are using something like android studio, you need to point it to this sdk
  # Output can be seen with $(brew --prefix)/share/android-sdk/
  # Other direct tools such as abd & android are added to $(brew --prefix)/bin
  brew install --cask android-sdk
  brew install --cask android-platform-tools
}

setupvisualcode() {
  brew install --cask visual-studio-code
  brew tap homebrew/cask-versions
  brew install visual-studio-code-insiders
  mkdir ~/Library/Application\ Support/Code/User/
  mkdir ~/Library/Application\ Support/Code\ -\ Insiders/User/
  ln -s ~/.dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
  ln -s ~/.dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
  ln -s ~/.dotfiles/vscode/snippets/ ~/Library/Application\ Support/Code/User 
  ln -s ~/.dotfiles/vscode/settings.json ~/Library/Application\ Support/Code - Insiders/User/settings.json
  ln -s ~/.dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code - Insiders/User/keybindings.json
  ln -s ~/.dotfiles/vscode/snippets/ ~/Library/Application\ Support/Code\ -\ Insiders/User
}

setuppython() {
  brew install openssl readline sqlite3 xz zlib
  brew install pyenv
  pyenvinstall 3.8.6
  pyenv global 3.8.6
}

setuphammerspoon () {
  ln -s ~/.dotfiles/.hammerspoon ~/.hammerspoon
  brew install --cask hammerspoon
  
} 

setupdocker() {
  brew install docker
  etc=/Applications/Docker.app/Contents/Resources/etc
  ln -s $etc/docker.bash-completion $(brew --prefix)/etc/bash_completion.d/docker
  ln -s $etc/docker-compose.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-compose
}

symlinks () {

}

setupruby () {
  brew install rbenv
  RUBY_GEMS=(
      bundler
      filewatcher
  )

  echo "Installing Ruby gems"
  sudo gem install ${RUBY_GEMS[@]}
}

setupgitkeys() {
  # Inspo
  # https://gist.github.com/juanique/4092969
  # Updated api: https://docs.github.com/en/rest/users/keys?apiVersion=2022-11-28#create-a-public-ssh-key-for-the-authenticated-user

  read "email?What's your githubemail? " 
  echo "Using email $email"
  if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -C "$email"
    ssh-add ~/.ssh/id_rsa
  fi
  pub=`cat ~/.ssh/id_rsa.pub`

  read "token?Enter github personal token, fetch it here https://github.com/settings/tokens: "
  echo "Using otp $token"
  echo

  curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/keys \
  -d "{\"title\":\"`hostname`\",\"key\":\"$pub\"}"

}

################################################################################
# Aliases
################################################################################
alias reload='source ~/.zshrc' #Reload the source
port () {lsof -i :"$1";}
alias f='open -a Finder ./'
alias size='du -sh'
alias linked='( ls -l node_modules ; ls -l node_modules/@* ) | grep ^l'
alias bundletools='java -jar ~/code/scripts/bundletool.jar'
alias itj='/usr/local/bin/idea'
alias code='code-insiders'
alias codeold='code'

################################################################################
# Aliases for code project start
################################################################################
getEditorConfig () {
  cp ~/.dotfiles/personal/.editorconfig $1
}
getTsFiles () {
  cp ~/.dotfiles/coding/scripts/startTypeScript.sh $1
  cp ~/.dotfiles/coding/templates/tsconfig.json $1
  cp ~/.dotfiles/coding/templates/.NODEgitignore $1/.gitignore
}
getCoreCodingFiles () {
  cp ~/.dotfiles/coding/scripts/prepGit.sh $1
  cp ~/.dotfiles/coding/templates/README.md $1
} 
kickstart () {
  mkdir $1 && cd $1
  
  getCoreCodingFiles $(pwd)
  getEditorConfig $(pwd)
  getTsFiles $(pwd)
  
  yarn init --yes
  ./startTypeScript.sh
  code .

  rm startTypeScript.sh
  ./prepGit.sh
  rm prepGit.sh
  
  echo "You're fricking awesome 🤘 ✌️ 🤙"
}

pruneGitLocal () {
  git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}

source /Users/vongohren/.docker/init-zsh.sh || true # Added by Docker Desktop

[ -s "/Users/vongohren/.jabba/jabba.sh" ] && source "/Users/vongohren/.jabba/jabba.sh" # Added by Jabba
jabba use openjdk@1.17.0