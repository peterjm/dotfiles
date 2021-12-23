if type brew &>/dev/null; then
  FILENAME="$(brew --prefix)/opt/chruby/share/chruby/auto.sh"
  [ -f $FILENAME ] && source $FILENAME
fi
