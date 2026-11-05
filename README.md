# tmux-claude-window-name

Name tmux windows after the [Claude Code](https://claude.com/claude-code) session
running in them. When the session gets a name, or is renamed with `/rename`, the
window name follows.

```
 1:zsh  2:Fix flaky login test  3:api-timeout-investigation
```

## How it works

Claude Code sets the terminal title to `<status icon> <session name>`, for example
`✳ Fix flaky login test`. The plugin adds tmux hooks that run whenever a pane title
changes or another pane in the window becomes active. When the active pane runs
`claude`, the window is renamed to the title with the status icon removed.

- Everything runs inside tmux formats, so no shell process is started on each title
  change, even while the status icon animates.
- The window is only renamed when the name actually differs.
- Renaming turns off `automatic-rename` for that window, as `rename-window` always does.
- Windows that already run Claude Code are renamed when the plugin loads.
- When Claude Code exits, the window keeps its last name.
- A name you set by hand is replaced the next time Claude Code changes the title.

## Requirements

- tmux 3.2 or newer
- bash
- `allow-set-title` left at its default (`on`)

## Installation

### With [TPM](https://github.com/tmux-plugins/tpm)

```tmux
set -g @plugin 'horbo/tmux-claude-window-name'
```

Press `prefix` + `I` to install.

### Manually

```sh
git clone https://github.com/horbo/tmux-claude-window-name ~/.config/tmux/plugins/tmux-claude-window-name
```

```tmux
run-shell ~/.config/tmux/plugins/tmux-claude-window-name/claude-window-name.tmux
```

## Configuration

```tmux
set -g @claude-window-name-command 'claude'
set -g @claude-window-name-keep-icon 'off'
```

| Option                          | Default  | Description                                                                 |
|---------------------------------|----------|-----------------------------------------------------------------------------|
| `@claude-window-name-command`   | `claude` | Pattern matched against `pane_current_command`, `*` and `?` allowed         |
| `@claude-window-name-keep-icon` | `off`    | Keep the status icon (`✳` when idle, a spinner while working) in the name   |

If Claude Code was installed through npm, the pane command may show up as `node`.
Set `@claude-window-name-command` to `node` in that case.

Set options before the TPM `run` line.

The plugin uses index `42` of the `pane-title-changed` and `window-pane-changed` hooks.
Hooks you set without an index, or with a different one, are left alone.

## License

[MIT](LICENSE)
