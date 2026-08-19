# LESSONS

### 2026-08-19 - Keep OpenCode OAuth credentials out of dotfiles
- Context: dotfiles OpenCode installation and ChatGPT subscription authentication
- Symptom: declarative package setup and live account authentication are easy to conflate.
- Root cause: Home Manager owns the CLI package, while OpenCode stores `/connect` credentials separately in `~/.local/share/opencode/auth.json`.
- Fix: declare only the `opencode` package in Nix and complete ChatGPT Plus/Pro OAuth interactively after activation.
- Prevention: never add OpenCode's live auth file or OAuth tokens to this repository.

### 2026-07-29 - Home Manager Neovim needs the LazyVim entrypoint
- Context: dotfiles Home Manager Neovim config
- Symptom: `~/.config/nvim/init.lua` was replaced by a Home Manager-generated file that only set provider globals, so Neovim started without loading the LazyVim config under `nvim/lua`.
- Root cause: enabling `programs.neovim` makes Home Manager own `nvim/init.lua`; the existing standalone `nvim/init.lua` entrypoint was backed up and no longer loaded.
- Fix: put `require("config.lazy")` in `programs.neovim.initLua` so Home Manager's generated init keeps provider setup and loads the repo's LazyVim config tree.
- Prevention: when adding Home Manager ownership for tools that already have config under this repo, check whether Home Manager generates the same target files and include any required local entrypoints in the generated config.

### 2026-07-29 - Do not track Home Manager generated live targets
- Context: dotfiles repo located at `~/.config`
- Symptom: after `darwin-rebuild switch`, files such as `gh/config.yml`, `git/config`, `htop/htoprc`, and `nvim/init.lua` showed as type changes because Home Manager replaced tracked files with store symlinks and wrote `.backup` files.
- Root cause: the repo tracked live paths that Home Manager also manages under `$HOME/.config`; in this layout those live paths are inside the repo checkout.
- Fix: keep source files under Nix-owned source paths such as `nix/files/...`, untrack the generated live targets, and ignore the generated symlinks plus activation backups.
- Prevention: before adding a tracked dotfile under this repo root, check whether Home Manager will manage the same `$HOME/.config/...` target.
