# git-wt-go: navigate or create worktrees in the current repo.
#
#   git-wt-go              cd to the main working tree (repo root)
#   git-wt-go <name>       cd to the worktree matching <name>.
#                          <name> can be either the worktree dir name
#                          (e.g. feat-bar) or the branch name (e.g. feat/bar).
#   git-wt-go -c <branch>  create a new worktree for <branch> and cd into it
#
# Implemented as a shell function (not a script) so cd affects the current shell.

git-wt-go() {
  if [[ "$1" == "-c" ]]; then
    if [[ -z "$2" ]]; then
      echo "Usage: git-wt-go -c <branch>"
      return 1
    fi
    local branch=$2
    git-wt-new "$branch" || return $?
    cd "$(git-wt-path "$branch")"
    return
  fi

  local root wt_base
  root=$(git-repo-root 2>/dev/null) || { echo "Not in a git repo"; return 1; }
  wt_base=$(git-wt-base)

  # No args: cd to the main working tree.
  if [[ $# -eq 0 ]]; then
    cd "$root"
    return
  fi

  local name=$1

  # 1. Interpret <name> as a branch or worktree dir name. git-wt-path handles both
  #    (a slash-free name passes through unchanged; slashes become hyphens).
  local candidate
  candidate=$(git-wt-path "$name")
  if [[ -d "$candidate" ]]; then
    cd "$candidate"
    return
  fi

  # 2. Fall back: match against the branch currently checked out in each worktree.
  #    Catches edge cases like a worktree whose dir name doesn't follow the
  #    slash-to-hyphen convention.
  if [[ -d "$wt_base" ]]; then
    local wt wt_branch
    for wt in "$wt_base"/*/; do
      [[ -d "$wt" ]] || continue
      wt_branch=$(git -C "$wt" rev-parse --abbrev-ref HEAD 2>/dev/null)
      if [[ "$wt_branch" == "$name" ]]; then
        cd "${wt%/}"
        return
      fi
    done
  fi

  echo "No worktree matching '$name' (see: git-wt-list)"
  return 1
}

# Completion: offer worktree dir names + their branches, plus the -c flag.
# compinit runs in 050_completions.sh, which sorts before this file.
_git-wt-go() {
  (( CURRENT == 2 )) || return 0

  local wt_base wt br
  local -a candidates

  wt_base=$(git-wt-base 2>/dev/null) || return 0
  if [[ -d "$wt_base" ]]; then
    for wt in "$wt_base"/*(N/); do
      # Prefer the branch name (it's what the user thinks in); fall back to
      # the dir name if we can't read HEAD or it's detached.
      br=$(git -C "$wt" rev-parse --abbrev-ref HEAD 2>/dev/null)
      if [[ -n "$br" && "$br" != "HEAD" ]]; then
        candidates+=("$br")
      else
        candidates+=("${wt:t}")
      fi
    done
  fi

  _describe -t worktrees 'worktree' candidates
}
compdef _git-wt-go git-wt-go
