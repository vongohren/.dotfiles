# dotfiles

Inspiration: https://dotfiles.github.io/

## Quick start (fresh Mac)

```bash
# 1. Clone this repo (first time, use HTTPS — no SSH keys yet)
git clone https://github.com/<you>/dotfiles.git ~/code/.dotfiles

# 2. Run bootstrap
~/code/.dotfiles/scripts/bootstrap.sh
```

The bootstrap script installs: Xcode CLI tools, Homebrew, git, gh, Chrome, Bitwarden, the terminal stack (Ghostty, Zellij, Yazi), and symlinks `.zshrc` and the Ghostty config.

## After bootstrap: AI-driven setup

Once Claude Code is installed, it handles everything else. Ask it to set up any tool and it reads the setup guide:

```
> set up Flutter
> install Docker
> configure Python with pyenv
```

The setup knowledge lives in [`it-management/docs/my-setup.md`](https://github.com/<you>/it-management/blob/main/docs/my-setup.md) — an AI-navigable reference organized by category with install commands, config, and verification steps.

## File structure

| File | Purpose |
|------|---------|
| `.zshrc.warp` | Active config, symlinked to `~/.zshrc`. Runtime-only: PATH, aliases, shell plugins |
| `.zshrc.iterm-full` | Archived legacy config with all setup functions (reference only) |
| `scripts/bootstrap.sh` | Fresh Mac bootstrap — run this first |
| `scripts/setupos.sh` | Legacy OS setup script (still works, superseded by bootstrap + AI) |
| `scripts/setup-current-work-needs.sh` | Legacy work deps script (still works, superseded by AI) |
| `scripts/github-add-keys.sh` | SSH key setup for GitHub |
| `scripts/swap-githubrepo-to-ssh.sh` | Switch this repo from HTTPS to SSH after keys are set up |
| `vscode/` | Shared settings, keybindings, snippets, extensions for VS Code / Windsurf / Cursor |
| `ghostty/` | Ghostty terminal config, symlinked to `~/Library/Application Support/com.mitchellh.ghostty/config`. See [`ghostty/README.md`](ghostty/README.md) for adjustment knobs and failure diagnosis. |

## SSH setup

After bootstrap, set up SSH keys for GitHub:

```bash
~/code/.dotfiles/scripts/github-add-keys.sh
~/code/.dotfiles/scripts/swap-githubrepo-to-ssh.sh
```

## VS Code / Windsurf / Cursor

All editors share settings via symlinks from `vscode/`. See the setup guide (`my-setup.md` > Code editors) for the symlink commands.

Extension list at `vscode/extensions.txt` — merge from all editors with the export snippet documented in the setup guide.
