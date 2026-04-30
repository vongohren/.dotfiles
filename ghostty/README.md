# Ghostty

Symlinked to `~/Library/Application Support/com.mitchellh.ghostty/config`.

Reload after edits: **Cmd+Shift+,** (most keys). A few changes still require a full app restart.

## Adjustment knobs

| Knob | Setting | Effect | Tradeoff |
|------|---------|--------|----------|
| Option key | `macos-option-as-alt = left` | Left Option = Alt/Meta for Vim/readline escapes. Right Option = macOS keyboard layout (Norwegian chars). | `true` breaks every Norwegian Option-combo (`~ @ { } [ ] \| €`). `false` loses Meta sequences in shell/Vim. `left`/`right` is best of both — pick the side that matches muscle memory. |
| Theme | `theme = Catppuccin Mocha` | Color scheme. | List installed themes: `ghostty +list-themes`. Mocha is dark; switch to `Catppuccin Latte` for light. |
| Font size | `font-size = 14` | Text size in pt. | Machine-dependent. 14 is fine on a 14" MBP; bump to 16 on a 4K/6K external if squinting. If you swap displays often, this is the one knob worth overriding per-machine — see "Per-machine overrides" below. |
| Window padding | `window-padding-x/y = 8` | Inner padding around the terminal grid. | Pure taste. 0 = maximum density, 8–12 = breathable. |
| URL hover | `link-url = true` | Underline URLs on hover so Cmd/Shift+Click works. | Off saves a few ms per redraw on huge scrollback. Not worth disabling. |
| Mouse capture | `mouse-shift-capture = false` | Shift bypasses the terminal app's (tmux/zellij) mouse capture so Ghostty handles link clicks. | This is Ghostty's default, but worth pinning explicitly because tmux configs sometimes flip it. Without it, Shift+Click inside tmux does nothing. |

## Per-machine overrides

If `font-size` (or anything else) needs to differ per machine, drop a `config.local` next to `config`:

```
# In ~/Library/Application Support/com.mitchellh.ghostty/config (the symlinked one):
config-file = ?config.local

# Then create ~/Library/Application Support/com.mitchellh.ghostty/config.local
# with the overrides — that file is NOT tracked in dotfiles.
```

The leading `?` makes the include optional, so machines without a local file still load cleanly.

## Diagnosing failures

### 1. Norwegian chars don't work (`~`, `@`, `{`, `}`, `[`, `]`, `\|`, `€`…)

**Symptom:** Pressing Option+¨ then Space gives nothing or an escape code instead of `~`.

**Cause:** `macos-option-as-alt = true` — Ghostty is intercepting Option as Meta before macOS's keyboard layout sees it.

**Fix:** Set `macos-option-as-alt = left` (or `right`, or remove the line entirely). Reload with Cmd+Shift+,.

**Note on dead keys:** `¨/^/~` is a dead key on Norwegian Mac. Standalone `~` is `Option+¨` then `Space`. `Option+¨` then a vowel composes (`ã`, `õ`). `~/foo` works directly because `/` doesn't combine. This is macOS, not Ghostty.

### 2. URL clicking inside tmux/zellij does nothing

**Symptom:** URLs appear underlined on hover outside tmux but are dead inside a tmux pane.

**Cause:** tmux is capturing mouse events before Ghostty sees them.

**Fix:** Hold **Shift** (or Cmd+Shift) while clicking — that bypasses the capture. Requires `mouse-shift-capture = false` in this config (already set) and `link-url = true`.

If still dead, check tmux: `set -g mouse on` should be set, and your tmux version should be ≥ 3.3.

### 3. Config edits don't seem to apply

**Symptom:** Changed a setting, hit Cmd+Shift+, and nothing happens.

**Cause:** Some Ghostty settings only apply to *new* windows or require a full app restart (font-family, some macOS-specific settings). Reload only re-reads the file; it can't retro-apply window-creation settings to an open window.

**Fix:** Open a new window/tab (Cmd+N / Cmd+T), or quit and relaunch Ghostty (Cmd+Q, then reopen). If a setting still won't take, run `ghostty +show-config` to confirm Ghostty actually parsed the file you expect — when the symlink is missing or pointing at the wrong place, Ghostty silently falls back to defaults.
