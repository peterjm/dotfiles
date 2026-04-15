# Overrides prompt segments from 050_prompt.sh to mark git worktree context.

# Color applied to the whole git-info bracket when inside a worktree.
# Override to taste (see `zsh_colors` skill or `man zshmisc` "VISUAL EFFECTS").
: ${PROMPT_WORKTREE_BRACKET_COLOUR:='%F{12}'}

# Marker prefixed inside the bracket. Set to '' to show just the color change.
: ${PROMPT_WORKTREE_MARKER:='⎇ '}

prompt_path() {
  # At a worktree root (.../.worktrees/<name>): show the main repo's path, as
  # if we were in the main working tree. Matches zsh's %2~ (last 2 components,
  # $HOME abbreviated to ~).
  if [[ "$PWD" =~ /\.worktrees/[^/]+$ ]]; then
    local repo=${PWD%/.worktrees/*}
    repo=${repo/#$HOME/\~}
    local parts
    parts=("${(@s:/:)repo}")
    if (( ${#parts[@]} >= 2 )); then
      echo "${parts[-2]}/${parts[-1]}"
    else
      echo "$repo"
    fi
    return
  fi
  echo '%2~'
}

prompt_git_info() {
  local s
  s=$(__git_ps1 '%s')
  [[ -z "$s" ]] && return
  git-frozen && s+='~'
  if [[ "$PWD" == *"/.worktrees/"* ]]; then
    echo "${PROMPT_WORKTREE_BRACKET_COLOUR}[${PROMPT_WORKTREE_MARKER}$s]${PROMPT_COLOUR}"
  else
    echo "[$s]"
  fi
}
