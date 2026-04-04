# Dotfiles

Personal configuration for zsh, vim, git, and related tools.

## Install

Requires [Homebrew](https://brew.sh/).

```sh
git clone git@github.com:peterjm/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
rake
```

This will:

1. Install Homebrew packages (see `Brewfile`)
2. Install [git-freeze](https://github.com/peterjm/git-freeze)
3. Install the latest Ruby via ruby-install
4. Generate git config
5. Symlink dotfiles from `system/` to `~/` (e.g. `_vimrc` becomes `~/.vimrc`)
6. Install vim-plug and vim plugins
7. Install Ruby gems

## Update

Running `rake` again will update everything — Homebrew packages, vim plugins, and gems.

## Uninstall

```sh
rake clean
```

Removes gems, downloaded scripts, vim plugins, and symlinks.

## Structure

```
system/          Dotfiles — underscore prefix becomes a dot when symlinked
system/bin/      Scripts added to PATH (test-that, git-*, related-files, etc.)
system/_zsh/     Zsh interactive shell config (sourced by _zshrc)
system/_zsh/env/ Zsh environment config (sourced by _zprofile)
src/             Ruby helpers for the Rakefile
gitconfigure/    Git config sources
Brewfile         Homebrew packages
```

Shell config files use numbered prefixes to control load order (e.g. `005_`, `010_`, `050_`).

## Per-machine config

Additional dotfiles can be loaded from Dropbox for per-machine or shared-secret configuration:

- `~/Dropbox/dotfiles/system/common/` — shared across all machines
- `~/Dropbox/dotfiles/system/{hostname}/` — machine-specific

These follow the same directory structure as `system/`.

## Key tools

- **zsh** — primary shell
- **vim** — editor, with fzf, vim-test, NERDTree, fugitive
- **ripgrep** — code search
- **fzf** — fuzzy finder
- **chruby** + **ruby-install** — Ruby version management
- **fnm** — Node.js version management
- **git-freeze** — stash alternative for git
- **test-that** (`tt`) — smart test runner for Ruby/Rails/RSpec/Python projects
