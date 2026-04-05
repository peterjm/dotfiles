# Neovim Cheatsheet

## File Navigation
  Ctrl-P          Find files (Telescope)
  ,f              Grep with quickfix (ripgrep)
  Ctrl-D          Toggle file tree
  Ctrl-F          Find current file in tree

## Testing (vim-test)
  t Ctrl-n        Test nearest
  t Ctrl-f        Test file
  t Ctrl-s        Test suite
  t Ctrl-l        Test last
  t Ctrl-g        Test visit

## LSP (when language server is active)
  gd              Go to definition
  gr              Find references
  K               Hover docs
  ,ca             Code action
  ,rn             Rename symbol

## Completion
  Tab             Next completion
  Shift-Tab       Previous completion
  Enter           Accept completion
  Ctrl-Space      Trigger completion

## Comments (Comment.nvim)
  gcc             Toggle comment (line)
  gc              Toggle comment (visual)

## Git (fugitive)
  :G              Git status
  :Gblame         Git blame

## Editing
  ,h              Ruby hash convert (hashrocket to modern)
  ,jt             Pretty-print JSON
  ,n              Toggle line numbers
  ,r              Refresh buffer
  space           Play @q macro
  .               Dot repeat in visual mode

## Plugin Management
  :Lazy           Plugin manager UI

## Per-project Config
  .nvim.lua       Lua config (or .exrc for vimscript)
