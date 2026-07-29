# LESSONS

### 2026-07-29 - Home Manager Neovim needs the LazyVim entrypoint
- Context: dotfiles Home Manager Neovim config
- Symptom: `~/.config/nvim/init.lua` was replaced by a Home Manager-generated file that only set provider globals, so Neovim started without loading the LazyVim config under `nvim/lua`.
- Root cause: enabling `programs.neovim` makes Home Manager own `nvim/init.lua`; the existing standalone `nvim/init.lua` entrypoint was backed up and no longer loaded.
- Fix: put `require("config.lazy")` in `programs.neovim.initLua` so Home Manager's generated init keeps provider setup and loads the repo's LazyVim config tree.
- Prevention: when adding Home Manager ownership for tools that already have config under this repo, check whether Home Manager generates the same target files and include any required local entrypoints in the generated config.
