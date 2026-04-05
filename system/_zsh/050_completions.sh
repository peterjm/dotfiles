FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$FPATH

autoload -Uz compinit
compinit

# gh completions
if command -v gh > /dev/null; then
  eval "$(gh completion -s zsh)"
fi

