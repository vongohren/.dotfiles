#/bin/bash

if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/paulirish/git-open.git ~/.oh-my-zsh/custom/plugins/git-open

brew install --cask iterm2
brew install z
brew install nvm
mkdir ~/.nvm


ln -s ~/.dotfiles/.zshrc ~/.zshrc
source $ZSH/oh-my-zsh.sh