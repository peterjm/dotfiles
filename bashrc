export HISTSIZE=10000 # Store 10,000 history entries
export HISTCONTROL=erasedups # Don't store duplicates
shopt -s histappend # Append to history file

### aliases
alias be="bundle exec"
alias cucumber="bundle exec cucumber"
alias rspec="bundle exec rspec"
alias top="top -o cpu"

### environment variables
VISUAL=mvim
EDITOR="$VISUAL"
PATH="$PATH:/usr/local/mysql/bin"
LSCOLORS=gxgxcxdxbxegedabagacad
export VISUAL EDITOR GIT_EDITOR PATH LSCOLORS

export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/:

### prompt
# If I am root, set the prompt to bright red
if [ ${UID} -eq 0 ]; then PROMPT_COLOUR='31m' ; else PROMPT_COLOUR='33m' ; fi
PS1='\[\033[01;${PROMPT_COLOUR}\]\h \[\033[01;${PROMPT_COLOUR}\]\W$(git_prompt_info '[%s]') \$ \[\033[00m\]'
PS2='> '
PS4='+ '
export PS1 PS2 PS4

if [ -f `brew --prefix`/etc/bash_completion ]; then source `brew --prefix`/etc/bash_completion ; fi
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then source "$HOME/.rvm/scripts/rvm" ; fi

[ ! -f "$HOME/.bashrc.local" ] || . "$HOME/.bashrc.local"

[[ -r $rvm_path/scripts/completion ]] && source $rvm_path/scripts/completion
