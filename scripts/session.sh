#!/usr/bin/env bash

# NAME
#     session - Create and switch to tmux development sessions
#
# SYNOPSIS
#     session [favorite]
#
# DESCRIPTION
#     Creates and manages tmux sessions for development projects. Each session
#     contains three panes: nvim (editor), claude-code (AI assistant), and a
#     shell/REPL. If a session already exists, switches to it instead of
#     creating a new one.
#
#     The script searches predefined directories for projects and allows
#     selection via fzf. It can also jump directly to favorite projects using
#     shortcuts.
#
#     Session features:
#       - Automatically restores vim sessions (Session.vim) if available
#       - Detects project type and starts appropriate REPL (sbt, python, etc.)
#       - Labels panes for easy identification
#       - Uses project directory basename as session name
#
# ARGUMENTS
#     favorite    Optional shortcut name to jump directly to a favorite project.
#                 Available shortcuts: dotfiles, neovim, active
#
# EXAMPLES
#     # Launch fuzzy finder to select a project
#     session
#
#     # Jump directly to the 'dotfiles' favorite
#     session dotfiles
#
#     # Jump to active project
#     session active
#
# CONFIGURATION
#     Edit SEARCH_DIRS to add directories to search for projects.
#     Edit FAVORITES associative array to add shortcut aliases.
#
# NOTES
#     This script is bundled in 'home.packages'; see file 'home.nix'.
#     See 'initContent' in 'home.programs.zsh' for keybindings; see file 'home.nix'

set -euo pipefail

# --- CONFIGURATION ---

# Directories to search
SEARCH_DIRS=(
  "$HOME/code/soma/"
  "$HOME/code/work/"
  "$HOME/code/personal/"
)

# Favorite shortcuts
declare -A FAVORITES=(
  [dotfiles]="$HOME/code/personal/dots"
  [neovim]="$HOME/.config/nvim"
  [active]="$HOME/code/soma/prairie"
)

# --- FUNCTIONS ---

create_session() {
  local session_name=$1
  local dir=$2

  tmux new-session -ds "$session_name" -c "$dir"

  # Pane 1: Neovim (auto-restore session if available)
  if [[ -f "$dir/Session.vim" ]]; then
    tmux send-keys -t "$session_name":0.0 'nvim -S' C-m
  else
    tmux send-keys -t "$session_name":0.0 'nvim' C-m
  fi

  # Pane 2: Claude-code
  tmux split-window -h -p 20 -t "$session_name":0 -c "$dir"
  tmux send-keys -t "$session_name":0.1 'claude .' C-m

  # Pane 3: Shell / REPL
  tmux split-window -v -t "$session_name":0.1 -c "$dir"

  # Label panes for clarity
  tmux select-pane -t "$session_name":0.0 -T "nvim"
  tmux select-pane -t "$session_name":0.1 -T "claude"
  tmux select-pane -t "$session_name":0.2 -T "shell"

  # Detect and start useful tools
  if [[ -f "$dir/build.sbt" ]] && command -v sbt &>/dev/null; then
    tmux send-keys -t "$session_name":0.2 'sbt' C-m
  elif [[ -f "$dir/pyproject.toml" ]]; then
    tmux send-keys -t "$session_name":0.2 'uv sync' C-m
  fi

  tmux display-message "Created new tmux session: $session_name"
}

launch_session() {
  local dir=$1
  local session_name
  session_name=$(basename "$dir")

  if ! tmux has-session -t="$session_name" 2>/dev/null; then
    create_session "$session_name" "$dir"
  fi

  tmux display-message "Switching to session: $session_name"

  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

# --- MAIN EXECUTION ---

if [[ -n "${1:-}" ]]; then
  key=$1
  if [[ -n "${FAVORITES[$key]}" ]]; then
    launch_session "${FAVORITES[$key]}"
    exit 0
  fi
fi

# Fallback: fuzzy picker
selected=$(
  find "${SEARCH_DIRS[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null |
  fzf --prompt="Select project: " --height=40% --reverse
)

[[ -z "$selected" ]] && exit 0
launch_session "$selected"

