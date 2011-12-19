set nocompatible
syntax enable                   " enable syntax highlighting
set encoding=utf-8
colorscheme vividchalk
set background=dark             " indicates that I use a dark background

set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation
set number
set ruler                       " show the cursor position all the time
set list                        " show invisible characters

"" List chars
set listchars=""                " Reset the listchars
set listchars=tab:\ \           " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:-          " show trailing spaces as dashes
set listchars+=extends:>        " The character to show in the last column when wrap is
                                " off and the line continues beyond the right of the screen
set listchars+=precedes:<       " The character to show in the last column when wrap is
                                " off and the line continues beyond the right of the screen

"" Whitespace
set wrap
set linebreak                   " soft-wrap lines at word boundaries
set textwidth=120               " number of columns before linewrap
set tabstop=2 shiftwidth=2      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set nohlsearch                  " don't highlight search matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

"" Filetypes
autocmd BufRead,BufNewFile *.rabl setf ruby
autocmd BufRead,BufNewFile *.god setf ruby
" File types that require tabs, not spaces
autocmd FileType make set noexpandtab
autocmd FileType python set noexpandtab

autocmd FileType ruby autocmd BufWritePre <buffer> :%s/\s\+$//e " clear trailing whitespace in ruby files

" Remember last location in file, but not for commit messages. (see :help last-position-jump)
autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g`\"" | endif

"" Plugins
call pathogen#infect()          " loads all plugins
call pathogen#helptags()        " generates the helptags

let g:CommandTMaxHeight=20
