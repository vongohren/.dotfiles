################################################################################
# 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀 
# To start the ball, please call init script!!
# 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
################################################################################

export DOTFILE_LOCATION=~/code/.dotfiles
export APPLICATION_SUPPORT=~/Library/Application\ Support


################################################################################
#Initializing zsh with plugins
################################################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="random"
plugins=(git npm brew zsh-syntax-highlighting zsh-autosuggestions git-open)
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
# 🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠
# Sourcing - source ~/.zshrc
# 🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠
################################################################################
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT:$GOPATH:$GOBIN

# Google cloud sdk python version and setup
export CLOUDSDK_PYTHON=$(pyenv root)/shims/python
source "$HOME/code/utils/google-cloud-sdk/path.zsh.inc"
source "$HOME/code/utils/google-cloud-sdk/completion.zsh.inc"

# Rbenv - https://github.com/rbenv/rbenv
eval "$(rbenv init -)"

# Pyenv - https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; 
then eval "$(pyenv init -)" 
fi

# Added by Windsurf
export PATH="/Users/vongohren/.codeium/windsurf/bin:$PATH"

#z command https://github.com/rupa/z installed by brew
. `brew --prefix`/etc/profile.d/z.sh

# Needed because of this: https://github.com/pyenv/pyenv/issues/1764#issuecomment-819395442
pyenvinstall () {
  LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib" CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include" pyenv install $1
}

# Fastlane
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Global yarn modules
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export VOLTA_HOME="$HOME/.volta"
export PATH=$PATH:"$VOLTA_HOME/bin"

# Div stuff
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

################################################################################
# Setup functions for wanted dependencies
################################################################################

setuppython() {
  brew install openssl readline sqlite3 xz zlib
  brew install pyenv
  pyenv install 3.10.0
  pyenv global 3.10.0
}

setuphammerspoon () {
  ln -s $DOTFILE_LOCATION/.hammerspoon ~/.hammerspoon
  brew install --cask hammerspoon
  
} 

setupdocker() {
  brew install --cask docker
  etc=/Applications/Docker.app/Contents/Resources/etc
  ln -s $etc/docker.bash-completion $(brew --prefix)/etc/bash_completion.d/docker
  ln -s $etc/docker-compose.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-compose
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

 setupgcloud() {                                                                                                                                                                                      
   local url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-arm.tar.gz"
   local download_dir="$HOME/Downloads"
   local install_dir="$HOME/code/utils/google-cloud-sdk"
   local tar_file="$download_dir/google-cloud-sdk.tar.gz"
   # Download the tar.gz file
   curl -o "$tar_file" "$url"
   # Create the install directory if it doesn't exist
   mkdir -p "$install_dir"
   # Extract the tar.gz file
   tar -xzf "$tar_file" -C "$install_dir" --strip-components=1
   # Run the install script
   bash "$install_dir/install.sh"
   # Remove the tar.gz file
   rm "$tar_file"
}

setupvscode() {
  setupVsCodeEditorFunction "Code\ -\ Insiders" "visual-studio-code@insiders" "code"
  setupcodeeditoraliases
}

setupwindsurf() {
  # https://codeium.com/windsurf 
  setupVsCodeEditorFunction "Windsurf" "windsurf" "windsurf"
  setupcodeeditoraliases
}

setupcursor() {
  # https://www.cursor.com/
  setupVsCodeEditorFunction "Cursor" "cursor" "cursor"
  setupcodeeditoraliases
}

setupVsCodeEditorFunction() {
    local APP_NAME=$1      # First argument: application name
    local INSTALL_CMD=$2   # Second argument: installation command
    local CMD_NAME=$3      # Third argument: command to install extensions
    local USER_DIR="$APPLICATION_SUPPORT/$APP_NAME/User"

    # Install the application
    brew install --cask $INSTALL_CMD

    # Create symlinks for settings, keybindings, and snippets
    # -f removes existing file/directory if it exists, no need for separate checks
    ln -sf $DOTFILE_LOCATION/vscode/settings.json "$USER_DIR/settings.json"
    ln -sf $DOTFILE_LOCATION/vscode/keybindings.json "$USER_DIR/keybindings.json"
    ln -sf $DOTFILE_LOCATION/vscode/snippets/ "$USER_DIR/snippets"

    # Install extensions in parallel using xargs
    xargs -P 4 -I {} $CMD_NAME --install-extension {} < $DOTFILE_LOCATION/vscode/extensions.txt
}

exportExtensions() {
    local temp_file=$(mktemp)
    
    # Export current extensions to temp file
    code-insiders --list-extensions > "$temp_file"
    windsurf --list-extensions >> "$temp_file"
    cursor --list-extensions >> "$temp_file"
    
    # Sort and remove duplicates, then save to extensions.txt
    sort -u "$temp_file" > "$DOTFILE_LOCATION/vscode/extensions.txt"
    
    # Clean up temp file
    rm "$temp_file"
    
    echo "✨ Extensions have been exported and merged to $DOTFILE_LOCATION/vscode/extensions.txt"
}

setupdoppler() {
  # Prerequisite. gnupg is required for binary signature verification
  brew install gnupg
  # Next, install using brew (use `doppler update` for subsequent updates)
  brew install dopplerhq/cli/doppler
}

################################################################################
# Aliases
################################################################################
setupcodeeditoraliases() {
  echo "Setting up code editor aliases"
  alias code="code-insiders"
  alias codeold="code"
  alias surf="windsurf"
  alias cur="cursor"
}

alias reload="source ~/.zshrc" #Reload the source
port () {lsof -i :"$1";}
alias f="open -a Finder ./"
alias size="du -sh"
alias linked="( ls -l node_modules ; ls -l node_modules/@* ) | grep ^l"
alias bundletools="java -jar ~/code/scripts/bundletool.jar"
alias itj="/usr/local/bin/idea"
alias gcloud="~/code/utils/google-cloud-sdk/bin/gcloud"
# alias gcloud="~/code/Diwala/gcloud-versions/google-cloud-sdk/bin/gcloud"
alias setupos="$DOTFILE_LOCATION/scripts/setupos.sh"
alias setupcurrentwork="$DOTFILE_LOCATION/scripts/setup-current-work-needs.sh"
setupcodeeditoraliases

################################################################################
# Aliases for code project start
################################################################################
getEditorConfig () {
  cp $DOTFILE_LOCATION/personal/.editorconfig $1
}
getTsFiles () {
  cp $DOTFILE_LOCATION/coding/scripts/startTypeScript.sh $1
  cp $DOTFILE_LOCATION/coding/templates/tsconfig.json $1
  cp $DOTFILE_LOCATION/coding/templates/.NODEgitignore $1/.gitignore
}
getCoreCodingFiles () {
  cp $DOTFILE_LOCATION/coding/scripts/prepGit.sh $1
  cp $DOTFILE_LOCATION/coding/templates/README.md $1
} 
ks-ts () {
  # Create a new TypeScript project using KICKSTART
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

################################################################################
# Legacy functions
################################################################################

# OSSetup function legacy
mylegacybackpackosstuff() {
  # Android development setup
  setupandroid

  # Stuff used beforefin
  brew install kubectl
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True

  brew install cocoapods
  
  brew install --cask adoptopenjdk

  # DB reader
  brew install --cask dbeaver-community

  # IF I WANT TO DO JAVA AGAIN, this is the shitnizz
  curl -s "https://get.sdkman.io" | bash
}

# Coding function legacy
legacycodingstuff () {
  echo "Setup some code related vars and simple executables"
  mkdir "$HOME/code"
  mkdir "$HOME/code/executables"
  cd "$HOME/code/executables"
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && chmod +x minikube
  cd "$HOME"
}


# Alias function legacy
setupandroid() {
  # Need the tools to connect to the phone, adb comes with platform tools
  # If you are using something like android studio, you need to point it to this sdk
  # Output can be seen with $(brew --prefix)/share/android-sdk/
  # Other direct tools such as abd & android are added to $(brew --prefix)/bin
  brew install --cask android-sdk
  brew install --cask android-platform-tools
}
