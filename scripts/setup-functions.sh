#!/usr/bin/env zsh
################################################################################
# Setup functions — bootstrap helpers for installing toolchains
#
# Not sourced by .zshrc anymore. Source manually when setting up a new machine:
#   source ~/code/.dotfiles/scripts/setup-functions.sh
#   setupjava
#
# Many of these functions reference things that may have moved on; treat them
# as a starting point, not a guaranteed working installer.
################################################################################

export DOTFILE_LOCATION=~/code/.dotfiles
export APPLICATION_SUPPORT=~/Library/Application\ Support

################################################################################
# Languages
################################################################################

# Pyenv install workaround for OpenSSL/zlib issues
# https://github.com/pyenv/pyenv/issues/1764#issuecomment-819395442
pyenvinstall () {
  LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib" CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include" pyenv install $1
}

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

setupdotnet() {
  # Install .NET SDK via Homebrew (formula, not cask - no sudo required)
  # Install both .NET 9 (current) and latest stable
  brew install dotnet@9
  brew install dotnet

  # Add to PATH and set DOTNET_ROOT (already in .zshrc typically, but ensure it's available)
  export DOTNET_ROOT="/opt/homebrew/opt/dotnet@9/libexec"
  export PATH="/opt/homebrew/opt/dotnet@9/bin:$PATH"

  # Verify installation
  echo ""
  echo "=== .NET SDK Installation Complete ==="
  echo ""
  echo "Installed SDKs:"
  dotnet --list-sdks
  echo ""
  echo "Default dotnet version:"
  dotnet --version
  echo ""
  echo "To install additional SDK versions, run: brew install dotnet@<version>"
  echo "Note: .NET 9 projects will automatically use the correct SDK version"
}

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

################################################################################
# General tools
################################################################################

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

setupdoppler() {
  # Prerequisite. gnupg is required for binary signature verification
  brew install gnupg
  # Not using brew to support auto update features
  curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sudo sh
}

setuptemporal() {
  echo "Installing Temporal CLI..."
  brew install temporal
}

setuppnpm() {
  echo "Installing pnpm via Volta..."
  volta install pnpm
}

setupc() {
  brew install cmake
}

setupprotoc() {
  brew install protobuf
  protoc --version
  dart pub global activate protoc_plugin
}

################################################################################
# Code editors (VS Code / Windsurf / Cursor) — install + sync settings
################################################################################

setupcodeeditoraliases() {
  echo "Setting up code editor aliases"
  alias code="code-insiders"
  alias codeold="code"
  alias surf="windsurf"
  alias curs="cursor"
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

################################################################################
# Mobile development
################################################################################

setupandroidsdk() {
  brew install --cask android-commandlinetools
  sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34"
  yes | sdkmanager --licenses
}

setupflutter() {
  brew install --cask flutter
  flutter doctor
}

################################################################################
# Project scaffolding (TypeScript starter)
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
