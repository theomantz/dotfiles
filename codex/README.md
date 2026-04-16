# Codex Dotfiles

This directory contains the stable parts of `~/.codex` that are worth keeping in version control.

The live file at `~/.codex/config.toml` is symlinked to [config.toml](/Users/theo/.config/codex/config.toml), so edits here take effect immediately without a Nix rebuild.

Managed from this repo:

- `config.toml`
- `AGENTS.md`
- `LESSONS.md`
- `rules/default.rules`
- `skills/`

Machine-specific project trust settings are intentionally not versioned here. Codex can prompt to trust local worktrees as needed on each machine.

Left mutable on purpose:

- `auth.json`
- `history.jsonl`
- `state_*.sqlite`
- `logs_*.sqlite`
- `sessions/`
- `archived_sessions/`
- `memories/`
- `tmp/`
- `vendor_imports/`
- other runtime caches and local state
