################################################################################
# zshrc — clean, no oh-my-zsh
#
# Setup/install functions live in scripts/setup-functions.sh
# Source manually when bootstrapping a new machine.
################################################################################

export DOTFILE_LOCATION=~/code/.dotfiles

################################################################################
# Homebrew (Apple Silicon)
################################################################################
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "⚠️ Homebrew (brew) not found at /opt/homebrew/bin/brew"
fi

################################################################################
# History settings (Warp has its own, but these help with shell history)
################################################################################
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

################################################################################
# Completions (Warp has built-in, but these help with CLI tools)
################################################################################
# Full compinit (with security audit + dump rebuild) runs at most once every 24h.
# Other shells use the cached ~/.zcompdump via -C. This is the dominant startup cost.
autoload -Uz compinit bashcompinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
bashcompinit

################################################################################
# Language version managers
################################################################################

# Pyenv - https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Rbenv - https://github.com/rbenv/rbenv
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# SDKMAN (Java) - must be near end of file
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

################################################################################
# PATH additions
################################################################################

# Volta (Node.js)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Go
export GOROOT=/usr/local/go/
export PATH="$GOROOT/bin:$PATH"

# Java
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

# Android
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Yarn global
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Dart/Flutter pub cache
export PATH="$HOME/.pub-cache/bin:$PATH"

# Pulumi
export PATH="$HOME/.pulumi/bin:$PATH"

# MySQL client
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# MongoDB CLI
export PATH="$HOME/code/utils/mongocli_2.0.7_macos_arm64/bin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# .NET 9 (must be after brew shellenv to override /opt/homebrew/bin/dotnet which points to .NET 10)
export DOTNET_ROOT="/opt/homebrew/opt/dotnet@9/libexec"
export PATH="/opt/homebrew/opt/dotnet@9/bin:$PATH"

################################################################################
# Google Cloud SDK
################################################################################
if command -v pyenv >/dev/null 2>&1; then
  export CLOUDSDK_PYTHON="$(pyenv root)/shims/python"
else
  echo "⚠️ pyenv not found on PATH – CLOUDSDK_PYTHON not set"
fi
[[ -f "$HOME/code/utils/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/code/utils/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/code/utils/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/code/utils/google-cloud-sdk/completion.zsh.inc"

################################################################################
# Locale
################################################################################
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

################################################################################
# Shell enhancements (fzf, autosuggestions, syntax highlighting)
################################################################################

# fzf - fuzzy finder (upgrades ctrl+r history search)
source <(fzf --zsh)
# Rebind fzf widgets to avoid Zellij conflicts (Zellij captures ctrl+t for tab mode)
bindkey -r '^T'
bindkey '^Y' fzf-file-widget    # ctrl+y = fuzzy file finder (was ctrl+t)
bindkey '\ec' fzf-cd-widget     # alt+c = fuzzy cd (re-ensure after fzf source)

# zsh-autosuggestions - inline ghost text from history (right arrow to accept)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting - valid commands green, invalid red (must be last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

################################################################################
# Tool completions
################################################################################
complete -o nospace -C /usr/local/bin/terraform terraform

# z command - directory jumping
if command -v brew >/dev/null 2>&1; then
  Z_PREFIX="$(brew --prefix)"
  if [ -f "$Z_PREFIX/etc/profile.d/z.sh" ]; then
    . "$Z_PREFIX/etc/profile.d/z.sh"
  else
    echo "⚠️ z.sh not found under $Z_PREFIX/etc/profile.d"
  fi
else
  echo "⚠️ Homebrew (brew) not found on PATH – z command not enabled"
fi

################################################################################
# General aliases & functions
################################################################################
alias reload="source ~/.zshrc"
alias f="open -a Finder ./"
alias size="du -sh"
alias linked="( ls -l node_modules ; ls -l node_modules/@* ) | grep ^l"
port() { lsof -i :"$1"; }
pruneGitLocal() {
  git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}

# Tools
alias gcloud="$HOME/code/utils/google-cloud-sdk/bin/gcloud"
alias bundletools="java -jar $HOME/code/scripts/bundletool.jar"
alias itj="/usr/local/bin/idea"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
lum() { lumen --config ~/code/.lumen/lumen.config.json "$@"; }

# Dotfiles
alias setupos="$DOTFILE_LOCATION/scripts/setupos.sh"
alias setupcurrentwork="$DOTFILE_LOCATION/scripts/setup-current-work-needs.sh"

################################################################################
# Terminal multiplexer (Zellij & tmux)
################################################################################
alias zclaw="zellij --layout claude"
alias 6claw="zellij --layout claude-6"
alias ta="tmux attach"
alias tls="tmux list-sessions"
alias tks="tmux kill-session -t"

# tmux workspace launcher: attach to existing session or create with 2x3 grid layout
# Usage: twork <session-name> <directory>
twork() {
  local name="$1" dir="$2"
  if [ -z "$name" ] || [ -z "$dir" ]; then
    echo "Usage: twork <session-name> <directory>"
    return 1
  fi
  dir="${dir/#\~/$HOME}"
  # Attach if session exists
  if tmux has-session -t "$name" 2>/dev/null; then
    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$name"
    else
      tmux attach -t "$name"
    fi
    return
  fi
  # Create new session with 2x3 grid (matches zellij claude-6 layout)
  tmux new-session -d -s "$name" -c "$dir"
  tmux split-window -h -t "$name" -c "$dir"
  tmux split-window -h -t "$name" -c "$dir"
  tmux select-layout -t "$name" even-horizontal
  tmux split-window -v -t "${name}:.1" -c "$dir"
  tmux split-window -v -t "${name}:.3" -c "$dir"
  tmux split-window -v -t "${name}:.5" -c "$dir"
  tmux select-pane -t "${name}:.6"
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$name"
  else
    tmux attach -t "$name"
  fi
}

################################################################################
# Infrastructure & servers
################################################################################
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
# Tailnet SSH aliases (beast, beastwin, clawd) live in ~/.local-aliases
[[ -f ~/.local-aliases ]] && source ~/.local-aliases

################################################################################
# AI tools
################################################################################
alias claude-tts="~/.claude/hooks/claude-tts.sh"
export PATH="$HOME/.mux/bin:$PATH"

# Added by @synth1s/cloak
eval "$(cloak init)"

# Parent-directory cloak binding: auto-switch profile based on $PWD prefix.
# Wraps the cloak-installed claude() so its existing behavior (.cloak files,
# -a flag, account subcommand) keeps working.
functions[_cloak_claude_wrapped]=$functions[claude]
claude() {
  case "$PWD" in
    "$HOME/code/Mobai"|"$HOME/code/Mobai"/*)
      eval "$(command cloak switch --print-env mobai 2>/dev/null)"
      ;;
    "$HOME/code/personal-projects"|"$HOME/code/personal-projects"/*|\
    "$HOME/code/ctoroundtable"|"$HOME/code/ctoroundtable"/*|\
    "$HOME/code/dao/PengeFix"|"$HOME/code/dao/PengeFix"/*)
      eval "$(command cloak switch --print-env mine 2>/dev/null)"
      ;;
  esac
  _cloak_claude_wrapped "$@"
}

################################################################################
# Personal projects
################################################################################

# Project launchers — Zellij
alias itmg='cd ~/code/personal-projects/it-management && (zellij attach "IT Management" 2>/dev/null || zellij -n claude-6 -s "IT Management")'
alias lifemngt='cd ~/code/personal-projects/lifemanagement && (zellij attach lifemngt 2>/dev/null || zellij -n claude-6 -s lifemngt)'
alias ctohq='cd ~/code/ctoroundtable/ctoroundtable-hq && (zellij attach ctohq 2>/dev/null || zellij -n claude-6 -s ctohq)'

# Project launchers — tmux
alias titmg='twork itmg ~/code/personal-projects/it-management'
alias tlifemngt='twork lifemngt ~/code/personal-projects/lifemanagement'
alias tctohq='twork ctohq ~/code/ctoroundtable/ctoroundtable-hq'

# Secrets — personal
[[ -f ~/.fpl/secrets.env ]] && source ~/.fpl/secrets.env
[[ -f ~/.babyname/env ]] && source ~/.babyname/env

# Secrets — CTO Roundtable
source /Users/vongohren/code/ctoroundtable/ctoroundtable-hq/infrastructure/slack-mcp/credentials.env
source /Users/vongohren/code/ctoroundtable/ctoroundtable-hq/infrastructure/coda-mcp/credentials.env
[[ -f "/Users/vongohren/code/ctoroundtable/ctoroundtable-hq/infrastructure/linkedin-mcp/credentials.env" ]] && source "/Users/vongohren/code/ctoroundtable/ctoroundtable-hq/infrastructure/linkedin-mcp/credentials.env"
[[ -f "/Users/vongohren/code/ctoroundtable/ctoroundtable-hq/infrastructure/neon/credentials.env" ]] && source "/Users/vongohren/code/ctoroundtable/ctoroundtable-hq/infrastructure/neon/credentials.env"
[[ -f "/Users/vongohren/code/ctoroundtable/ctoroundtable-hq/infrastructure/forwardemail/credentials.env" ]] && source "/Users/vongohren/code/ctoroundtable/ctoroundtable-hq/infrastructure/forwardemail/credentials.env"

################################################################################
# Work — Mobai
################################################################################
alias az-mobai="AZURE_CONFIG_DIR=~/.azure-mobai az"
alias mobaihq='cd ~/code/Mobai/mobai-hq && (zellij attach mobaihq 2>/dev/null || zellij -n claude-6 -s mobaihq)'
alias tmobaihq='twork mobaihq ~/code/Mobai/mobai-hq'
[ -f ~/.mobai/mcp-env ] && source ~/.mobai/mcp-env
export PATH=$PATH:$HOME/.maestro/bin

################################################################################
# Work — PengeFix
################################################################################
alias pengework='cd ~/code/dao/PengeFix/pengefix-hq && (zellij attach pengefix 2>/dev/null || zellij -n claude-6 -s pengefix)'
alias tpengework='twork pengefix ~/code/dao/PengeFix/pengefix-hq'
[[ -f ~/.pengefix/secrets.env ]] && source ~/.pengefix/secrets.env
[[ -f ~/.pengefix/mcp-env ]] && source ~/.pengefix/mcp-env

################################################################################
# End of config
# NOTE: For setup instructions, see it-management/docs/my-setup.md
# For legacy functions, see .zshrc.iterm-full
################################################################################

# Resend CLI
export PATH="$HOME/.resend/bin:$PATH"
