#!/bin/bash
################################################################################
# Fresh Mac Bootstrap
# Gets you to the point where Claude Code works.
# After this, use Claude Code + docs/my-setup.md for everything else.
################################################################################

set -e

echo "=== Fresh Mac Bootstrap ==="
echo "This installs the minimum needed to get Claude Code running."
echo ""

# 1. Xcode CLI tools (needed for git, compilers)
if ! xcode-select -p &>/dev/null; then
  echo "--- Installing Xcode Command Line Tools ---"
  xcode-select --install
  echo "Press Enter after Xcode CLI tools finish installing..."
  read -r
else
  echo "--- Xcode CLI tools already installed ---"
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "--- Installing Homebrew ---"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "--- Homebrew already installed ---"
fi

# 3. Essentials
echo "--- Installing essentials (git, gh, Chrome, Bitwarden) ---"
brew install git gh
brew install --cask google-chrome bitwarden

# 4. Terminal stack (for Claude Code workflow)
echo "--- Installing terminal stack ---"
brew install ghostty zellij yazi glow
brew install fzf zsh-autosuggestions zsh-syntax-highlighting z

# 5. Claude Code
if ! command -v claude &>/dev/null; then
  echo "--- Installing Claude Code ---"
  echo "Follow: https://docs.anthropic.com/en/docs/claude-code/overview"
  echo "Typically: npm install -g @anthropic-ai/claude-code"
  echo "Or use the native installer from Anthropic."
  echo ""
  echo "Skipping automatic install — do this manually after Node is set up."
else
  echo "--- Claude Code already installed ---"
fi

# 6. Symlink .zshrc
echo "--- Symlinking .zshrc ---"
if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
  echo "Backing up existing .zshrc to ~/.zshrc.backup"
  mv ~/.zshrc ~/.zshrc.backup
fi
ln -sf ~/code/.dotfiles/.zshrc.warp ~/.zshrc
echo "Symlinked ~/.zshrc -> ~/code/.dotfiles/.zshrc.warp"

# 7. Symlink Ghostty config
echo "--- Symlinking Ghostty config ---"
GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
mkdir -p "$GHOSTTY_DIR"
GHOSTTY_CONFIG="$GHOSTTY_DIR/config"
if [ -f "$GHOSTTY_CONFIG" ] && [ ! -L "$GHOSTTY_CONFIG" ]; then
  echo "Backing up existing Ghostty config to $GHOSTTY_CONFIG.backup"
  mv "$GHOSTTY_CONFIG" "$GHOSTTY_CONFIG.backup"
fi
ln -sf ~/code/.dotfiles/ghostty/config "$GHOSTTY_CONFIG"
echo "Symlinked Ghostty config -> ~/code/.dotfiles/ghostty/config"

echo ""
echo "=== Bootstrap complete ==="
echo "Next steps:"
echo "  1. Open a new terminal (or: source ~/.zshrc)"
echo "  2. Install Node via Volta: curl https://get.volta.sh | bash -s -- --skip-setup && volta install node"
echo "  3. Install Claude Code: npm install -g @anthropic-ai/claude-code"
echo "  4. Ask Claude Code to set up anything else — it reads docs/my-setup.md"
