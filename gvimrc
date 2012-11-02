if has("gui_macvim")
  " map Command-T to the Command-T plugin
  macmenu &File.New\ Tab key=<nop>
  "map <D-t> <Plug>PeepOpen
  map <D-t> :CtrlP<CR>

  " map Command-Shift-T to refresh the Command-T plugin
  "macmenu &File.Open\ Tab\.\.\. key=<nop>
  "nmap <D-T> :CommandTFlush<CR>

  " use Cmd-Shift-F to start Ack
  nmap <D-F> :Ack<space>
endif

set guifont=Monaco:h12

set guioptions-=T " Start without the toolbar
set guioptions-=L " Don't use a left-hand scrollbar
