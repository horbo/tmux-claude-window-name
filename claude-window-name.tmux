#!/usr/bin/env bash

HOOK_INDEX=42

get_option() {
  local value
  value="$(tmux show-option -gqv "$1")"
  echo "${value:-$2}"
}

command_pattern="$(get_option "@claude-window-name-command" "claude")"
case "$command_pattern" in
  '' | *[!A-Za-z0-9._*?-]*) command_pattern="claude" ;;
esac

keep_icon="$(get_option "@claude-window-name-keep-icon" "off")"
case "$keep_icon" in
  on | yes | true | 1) name_format='#{pane_title}' ;;
  *) name_format='#{s/^[^ -~]+ //:pane_title}' ;;
esac

condition="#{&&:#{&&:#{m:${command_pattern},#{pane_current_command}},#{pane_active}},#{!=:#{window_name},${name_format}}}"
rename="rename-window -- \"${name_format}\""

for hook in pane-title-changed window-pane-changed; do
  tmux set-hook -g "${hook}[${HOOK_INDEX}]" "if-shell -F '${condition}' '${rename}'"
done

for pane in $(tmux list-panes -a -F '#{pane_id}'); do
  tmux if-shell -t "$pane" -F "$condition" "rename-window -t $pane -- \"${name_format}\""
done
