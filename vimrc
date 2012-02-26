set nocompatible
syntax enable                   " enable syntax highlighting
set encoding=utf-8
colorscheme vividchalk
set background=dark             " indicates that I use a dark background
set visualbell                  " disable audible bell
let mapleader = ","             " map <Leader> to command

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
set showbreak=+                 " symbol to display in front of wrapped lines
set textwidth=120               " number of columns before linewrap
set tabstop=2 shiftwidth=2      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set nohlsearch                  " don't highlight search matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

set wildignore+=*.gif,*.png,*.jpg,*.jpeg,*.bmp

if has("autocmd")
  "" Filetypes
  autocmd BufRead,BufNewFile *.rabl setf ruby
  autocmd BufRead,BufNewFile *.god setf ruby
  autocmd BufRead,BufNewFile *.json setf javascript
  autocmd BufRead,BufNewFile *.ejs setf javascript
  " File types that require tabs, not spaces
  autocmd FileType make set noexpandtab
  autocmd FileType python set noexpandtab

  " Manage whitespace on save, maintaining cursor position
  function ClearTrailingWhitespace()
    let save_cursor = getpos(".")
    :silent! %s/\s\+$//e " clear trailing whitespace at the end of each line
    :silent! %s/\($\n\)\+\%$// " clear trailing newlines
    call setpos('.', save_cursor)
  endfunction
  autocmd FileType ruby,haml autocmd BufWritePre <buffer> call ClearTrailingWhitespace()

  " Remember last location in file, but not for commit messages. (see :help last-position-jump)
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

"" Plugins
call pathogen#infect()          " loads all plugins
call pathogen#helptags()        " generates the helptags

" Command T
let g:CommandTMaxHeight=20
map :ctf :CommandTFlush

" NERDTree
nmap <silent> <C-D> :NERDTreeToggle<CR>

" localvimrc
let g:localvimrc_ask=0
let g:localvimrc_sandbox=0

" replace all hashrocket 1.8 style ruby hashes with 1.9 style
map :RubyHashConvert :s/\v:([^ ]+)\s*\=\>/\1:/g
nmap <leader>h :RubyHashConvert<CR>
