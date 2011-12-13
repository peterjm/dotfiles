set nocompatible
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation
colorscheme koehler
set number

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
"set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

"" Filetypes
au BufRead,BufNewFile *.rabl setf ruby
au BufRead,BufNewFile *.god setf ruby

"" Plugins
call pathogen#infect()          " loads all plugins
call pathogen#helptags()        " generates the helptags
