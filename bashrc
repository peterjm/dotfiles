export HISTSIZE=10000 # Store 10,000 history entries
export HISTCONTROL=erasedups # Don't store duplicates
shopt -s histappend # Append to history file

### aliases
alias top="top -o cpu"
alias ll="ls -sail"
alias rt="ruby -Itest"

### environment variables
EDITOR="vim -f"
VISUAL="$EDITOR"
BUNDLER_EDITOR="mvim"

### Setting up PATH -- lower lines are higher in precedence
PATH="/usr/local/share/npm/bin:$PATH" # node.js packages
PATH="/usr/local/mysql/bin:$PATH" # MySQL
PATH="/usr/local/bin:$PATH" # Homebrew
PATH="$HOME/bin:$PATH" # personal bin directory

LSCOLORS=gxgxcxdxbxegedabagacad
NODE_PATH="$NODE_PATH:/usr/local/lib/node:/usr/local/lib/node_modules"
export VISUAL EDITOR BUNDLER_EDITOR GIT_EDITOR PATH LSCOLORS NODE_PATH

# from https://gist.github.com/burke/1688857
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_FREE_MIN=200000

### additional functions stored here to keep .bashrc clean
[ ! -f "$HOME/.bashrc.extras" ] || . "$HOME/.bashrc.extras"

### prompt
# If I am root, set the prompt to bright red
if [ ${UID} -eq 0 ]; then PROMPT_COLOUR='31m' ; else PROMPT_COLOUR='33m' ; fi
# This sets the prompt to: "hostname top-level-directory[git_info] $"
PS1='\[\033[01;${PROMPT_COLOUR}\]\h \[\033[01;${PROMPT_COLOUR}\]\W$(git_prompt_info '[%s]') \$ \[\033[00m\]'
PS2='> '
PS4='+ '
export PS1 PS2 PS4

if which brew > /dev/null
then
  if [ -f `brew --prefix`/etc/bash_completion ]; then source `brew --prefix`/etc/bash_completion ; fi
fi

# .bashrc.local is not kept in version control -- intended for machine specific  changes
[ ! -f "$HOME/.bashrc.local" ] || . "$HOME/.bashrc.local"

if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi
