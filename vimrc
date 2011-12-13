set nocompatible
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation
colorscheme koehler
set number
set ruler                       " show the cursor position all the time
set list                        " show invisible characters
" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:-            " show trailing spaces as dashes
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

"" Filetypes
au BufRead,BufNewFile *.rabl setf ruby
au BufRead,BufNewFile *.god setf ruby

"" Plugins
call pathogen#infect()          " loads all plugins
call pathogen#helptags()        " generates the helptags

if has("autocmd")
  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

let g:CommandTMaxHeight=20
