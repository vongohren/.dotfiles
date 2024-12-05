#/bin/bash

# Check if ~/code directory exists, if not, create it
if [ ! -d "$HOME/code" ]; then
    echo "Creating ~/code directory..."
    mkdir -p "$HOME/code"
fi

if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/paulirish/git-open.git ~/.oh-my-zsh/custom/plugins/git-open

brew install --cask iterm2
brew install z

rm ~/.zshrc
ln -s ~/code/.dotfiles/.zshrc ~/.zshrc
source $ZSH/oh-my-zsh.sh

setupvisualcode() {
  brew install --cask visual-studio-code@insiders
  mkdir ~/Library/Application\ Support/Code\ -\ Insiders/User/
  ln -s ~/code/.dotfiles/vscode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
  ln -s ~/code/.dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
  ln -s ~/code/.dotfiles/vscode/snippets/ ~/Library/Application\ Support/Code\ -\ Insiders/User
}

setupvisualcode
