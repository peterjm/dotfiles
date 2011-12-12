if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
  "map <D-t> <Plug>PeepOpen
  map <D-t> :CommandT<CR>
endif

set guifont=Monaco:h12
