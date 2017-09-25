if which ag > /dev/null
then
  export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --path-to-ignore ~/.ignore_for_fzf -g ""'
fi
