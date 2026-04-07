# Dotfiles

Personal dotfiles repo that configures a macOS dev environment (zsh, neovim, git, Ruby). `rake` runs the full setup. See README.md for details.

## Key conventions

- Files in `system/` use `_` prefix in place of `.` — the linker converts them (e.g. `_gitconfig` → `~/.gitconfig`).
- Shell config numbered prefixes control load order (`005_` loads before `050_`).
- `src/` is Ruby helpers for the Rakefile, not dotfiles.

## Testing changes

No automated tests. Run `rake` to verify nothing errors out.
