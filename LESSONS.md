# LESSONS

### 2026-11-11 - Codex 0.167.0 needs the full Cargo system-library set
- Context: dotfiles flake refresh on aarch64-darwin
- Symptom: `darwin-rebuild switch` failed while building Codex because `aws-lc-sys` required a system AWS-LC but found only OpenSSL.
- Root cause: nixpkgs' generic Cargo hook forces supported crates to use system libraries, while the Codex 0.167.0 derivation omitted AWS-LC, Oniguruma, SQLite, and Zstandard from `buildInputs`.
- Fix: add the four missing libraries with a version-gated Codex overlay that becomes a no-op at 0.167.1, matching the upstream nixpkgs dependency fix.
- Prevention: when a Rust build fails after the Cargo system-library hook runs, compare the derivation's native inputs with nixpkgs' current package definition and validate the complete build so the next missing library is not hidden by the first failure.

### 2026-08-19 - Audit third-party Actions beyond their README workflow
- Context: replacing Copilot review with the Kimi Code Review marketplace action
- Symptom: the documented workflow checked out private repositories with a token, but the Docker action ignored that checkout and cloned the PR branch again using an unauthenticated HTTPS URL.
- Root cause: the action's runtime behavior diverged from its setup example, and the README's private-repository claim did not cover the second clone.
- Fix: inspect the pinned action source, remove the unused checkout steps, and pass a process-scoped Git URL rewrite so the action's internal clone uses `github.token` without persisting credentials.
- Prevention: before rolling a third-party Action across repositories, inspect its action definition and execution path for extra network access, mutable dependencies, secret handling, and untrusted-event behavior; do not validate only the marketplace snippet.

### 2026-08-19 - Keep OpenCode OAuth credentials out of dotfiles
- Context: dotfiles OpenCode installation and ChatGPT subscription authentication
- Symptom: declarative package setup and live account authentication are easy to conflate.
- Root cause: Home Manager owns the CLI package, while OpenCode stores `/connect` credentials in `~/.local/share/opencode/auth.json` and bootstraps runtime files under `~/.config/opencode`.
- Fix: declare only the `opencode` package in Nix, ignore the generated `/opencode/` tree, and complete ChatGPT Plus/Pro OAuth interactively after activation.
- Prevention: never add OpenCode's live config state, auth file, or OAuth tokens to this repository.

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
