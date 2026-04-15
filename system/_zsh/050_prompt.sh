source_if_exists "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh"

# If I am root, set the prompt to bright red
if [ ${UID} -eq 0 ]; then PROMPT_COLOUR="%F{red}" ; fi
# Default to yellow if the colour isn't already set
if [[ -z "$PROMPT_COLOUR" ]]; then PROMPT_COLOUR="%F{yellow}" ; fi
# This sets the prompt to: "hostname top-2-level-directories[git_info] %"
if [[ -z "$PROMPT_HOST" ]]; then PROMPT_HOST="%m" ; fi

LAST_COMMAND_STATUS="%(?.%F{green}√.%F{red}?%?)"

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_STATESEPARATOR=''

# Prompt segments. Override these in later-numbered _zsh/*.sh files to
# customize the prompt without editing this file.
prompt_path() {
  echo '%2~'
}

prompt_git_info() {
  local s
  s=$(__git_ps1 '%s')
  [[ -z "$s" ]] && return
  git-frozen && s+='~'
  echo "[$s]"
}

precmd () {
  PS1="$LAST_COMMAND_STATUS $PROMPT_COLOUR%B$(prompt_path)%b$(prompt_git_info) %#%f "
}
