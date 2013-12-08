# If I am root, set the prompt to bright red
if [ ${UID} -eq 0 ]; then PROMPT_COLOUR=$Red ; fi
# Default to yellow if the colour isn't already set
if [[ -z "$PROMPT_COLOUR" ]]; then PROMPT_COLOUR=$Yellow ; fi
# This sets the prompt to: "hostname top-level-directory[git_info] $"
PS1="\[$PROMPT_COLOUR\]\h \W\$(git_prompt_info '[%s]') \$ \[$Color_Off\]"
PS2='> '
PS4='+ '
export PS1 PS2 PS4
