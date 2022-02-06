source_if_exists "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
if [[ -f "$HOME/.ruby-version" ]]; then
  chruby `cat $HOME/.ruby-version`
fi
