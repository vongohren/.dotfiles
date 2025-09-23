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
ZSH_THEME="re5et"
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
# Sourcing - source ~/.zshrc and aliases
# 🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠🧠
################################################################################

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

export PATH="$PATH:$HOME/.cargo/bin"

# Java
export JAVA_HOME="/Users/vongohren/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

# Android
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"
export ANDROID_SDK_ROOT=$ANDROID_HOME

# Protobuff dependencies
export PATH="$PATH":"$HOME/.pub-cache/bin"

################################################################################
# Aliases
setupcodeeditoraliases() {
  echo "Setting up code editor aliases"
  alias code="code-insiders"
  alias codeold="code"
  alias surf="windsurf"
  alias curs="cursor"
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

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

lum() { lumen --config ~/code/.lumen/lumen.config.json "$@"; }

################################################################################
# Setup functions for wanted dependencies
################################################################################

# Languages

setuppython() {
  brew install openssl readline sqlite3 xz zlib
  brew install pyenv
  pyenv install 3.10.0
  pyenv global 3.10.0
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

setuprust() {
  # Install rust with version management
  # You can uninstall at any time with rustup self uninstall and these changes will be reverted.
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# General tools

## Mac App Store from command line
setupmas() {
  brew install mas
}

setuphammerspoon () {
  # Create the .hammerspoon directory in dotfiles if it doesn't exist
  mkdir -p $DOTFILE_LOCATION/.hammerspoon
  # Remove existing hammerspoon directory if it exists
  rm -rf ~/.hammerspoon
  # Create the symbolic link
  ln -s $DOTFILE_LOCATION/.hammerspoon ~/.hammerspoon
  # Install hammerspoon
  brew install --cask hammerspoon
} 

setupdocker() {
  brew install --cask docker
  etc=/Applications/Docker.app/Contents/Resources/etc
  ln -s $etc/docker.bash-completion $(brew --prefix)/etc/bash_completion.d/docker
  ln -s $etc/docker-compose.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-compose
}

setupaws() {
  brew install awscli
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

downloadAndInstallExtension() {
    local extension=$1
    local cmd=$2
    local temp_dir=$(mktemp -d)
    local publisher=$(echo $extension | cut -d. -f1)
    local name=$(echo $extension | cut -d. -f2)
    
    echo "Downloading $extension..."
    # Get latest version and download URL
    local json_data=$(curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/latest/vspackage")
    
    if [ $? -eq 0 ]; then
        local vsix_path="$temp_dir/$name.vsix"
        curl -L -o "$vsix_path" "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/latest/vspackage"
        
        if [ -f "$vsix_path" ]; then
            echo "Installing $extension from VSIX..."
            $cmd --install-extension "$vsix_path" 2>&1 || {
                echo "⚠️  Failed to install $extension from VSIX"
                return 1
            }
        else
            echo "⚠️  Failed to download VSIX for $extension"
            return 1
        fi
    else
        echo "⚠️  Failed to get version info for $extension"
        return 1
    fi
    
    rm -rf "$temp_dir"
}

installExtensions() {
    local editor=$1
    local cmd
    
    # Map editor name to its command
    case $editor in
        "code-insiders")
            cmd="code-insiders"
            ;;
        "windsurf")
            cmd="windsurf"
            ;;
        "cursor")
            cmd="cursor"
            ;;
        *)
            echo "❌ Unsupported editor: $editor"
            echo "Supported editors: code-insiders, windsurf, cursor"
            return 1
            ;;
    esac
    
    echo "🔄 Installing extensions for $editor..."
    
    # Create a temporary directory for downloads
    local temp_dir=$(mktemp -d)
    
    # Read extensions line by line and install
    while IFS= read -r extension || [ -n "$extension" ]; do
        if [ -n "$extension" ]; then
            downloadAndInstallExtension "$extension" "$cmd" || {
                echo "---"
                continue
            }
        fi
    done < "$DOTFILE_LOCATION/vscode/extensions.txt"
    
    # Cleanup
    rm -rf "$temp_dir"
    
    echo "✨ Extensions installation completed for $editor"
}

setupdoppler() {
  # Prerequisite. gnupg is required for binary signature verification
  brew install gnupg
  # Not using brew to support auto update features
  curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sudo sh
}

# Java

setupjavamanager() {
  if command -v java &> /dev/null; then
    echo "Java is already installed on your system. Please clean up and remove any existing Java installations before running this."
    java -version
    which java
    return
  fi

  # For managing JAVA, this is the shitnizz
  curl -s "https://get.sdkman.io" | bash
  source "/Users/vongohren/.sdkman/bin/sdkman-init.sh"
}

setupjava() {
  if ! command -v sdk &> /dev/null; then
    echo "sdk (Java Version Manager) is not installed. Please install it first, see setupjavamanager function."
    return
  fi

  sdk install java
}

# Mobile development

setupandroidsdk() {
  brew install --cask android-commandlinetools
  sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34"
  yes | sdkmanager --licenses
}

setupflutter() {
  brew install --cask flutter
  flutter doctor
}

setupc() {
  brew install cmake
}

setupprotoc() {
  brew install protobuf
  protoc --version
  dart pub global activate protoc_plugin
}

setuptemporal() {
  echo "Installing Temporal CLI..."
  brew install temporal
}

setuppnpm() {
  echo "Installing pnpm via Volta..."
  volta install pnpm
}

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

################################################################################
# END OF FILE PROGRAMS
################################################################################

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="/Users/vongohren/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# Go when installing with the installer from https://go.dev/dl/
export GOROOT=/usr/local/go/
export PATH=$PATH:$GOROOT/bin

# add Pulumi to the PATH
export PATH=$PATH:/Users/vongohren/.pulumi/bin

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# bun completions
[ -s "/Users/vongohren/.bun/_bun" ] && source "/Users/vongohren/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

