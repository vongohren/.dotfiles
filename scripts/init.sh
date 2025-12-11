#!/bin/bash

################################################################################
# Dotfiles Init Script
# Supports both Warp (default) and iTerm setup
################################################################################

DOTFILES="$HOME/code/.dotfiles"

# Check if ~/code directory exists, if not, create it
if [ ! -d "$HOME/code" ]; then
    echo "Creating ~/code directory..."
    mkdir -p "$HOME/code"
fi

# Install Homebrew if not present
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Essential tools
brew install z

################################################################################
# Terminal Setup - Choose one
################################################################################

setup_warp() {
    echo "Setting up Warp terminal..."
    brew install --cask warp

    # Symlink Warp config directory
    if [ -d "$HOME/.warp" ]; then
        echo "Backing up existing ~/.warp to ~/.warp.backup"
        mv "$HOME/.warp" "$HOME/.warp.backup"
    fi
    ln -s "$DOTFILES/.warp" "$HOME/.warp"

    # Use the clean Warp zshrc (no oh-my-zsh)
    rm -f ~/.zshrc
    ln -s "$DOTFILES/.zshrc.warp" ~/.zshrc

    echo "Warp setup complete! Open Warp to get started."
}

setup_iterm() {
    echo "Setting up iTerm2 (legacy)..."

    # Install oh-my-zsh and plugins
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/paulirish/git-open.git ~/.oh-my-zsh/custom/plugins/git-open

    brew install --cask iterm2

    # Use full zshrc with oh-my-zsh
    rm -f ~/.zshrc
    ln -s "$DOTFILES/.zshrc.iterm-full" ~/.zshrc
    source $ZSH/oh-my-zsh.sh

    echo "iTerm setup complete!"
}

################################################################################
# VS Code Setup
################################################################################

setupvisualcode() {
    brew install --cask visual-studio-code@insiders
    mkdir -p ~/Library/Application\ Support/Code\ -\ Insiders/User/
    ln -sf "$DOTFILES/vscode/settings.json" ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
    ln -sf "$DOTFILES/vscode/keybindings.json" ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
    ln -sf "$DOTFILES/vscode/snippets/" ~/Library/Application\ Support/Code\ -\ Insiders/User/snippets
}

################################################################################
# Main
################################################################################

# Default to Warp, use --iterm flag for legacy setup
if [ "$1" = "--iterm" ]; then
    setup_iterm
else
    setup_warp
fi

setupvisualcode

echo ""
echo "Init complete! Restart your terminal or run: source ~/.zshrc"
