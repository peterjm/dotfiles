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
precmd () {
  local git_status
  git_status="$(__git_ps1 '%s')"
  if [[ ! -z "$git_status" ]]; then
    git-frozen && git_status+='~'
    git_status="[$git_status]"
  fi

  PS1="$LAST_COMMAND_STATUS $PROMPT_COLOUR%B%2~%b$git_status %#%f "
}
