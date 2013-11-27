# If I am root, set the prompt to bright red
if [ ${UID} -eq 0 ]; then PROMPT_COLOUR='31m' ; fi
# Default to yellow if the colour isn't already set
if [[ -z "$PROMPT_COLOUR" ]]; then PROMPT_COLOUR='33m' ; fi
# This sets the prompt to: "hostname top-level-directory[git_info] $"
PS1='\[\033[01;${PROMPT_COLOUR}\]\h \[\033[01;${PROMPT_COLOUR}\]\W$(git_prompt_info '[%s]') \$ \[\033[00m\]'
PS2='> '
PS4='+ '
export PS1 PS2 PS4
