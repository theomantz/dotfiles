# Codex Dotfiles

This directory contains the stable parts of `~/.codex` that are worth keeping in version control.

Managed by Nix:

- `config.toml`
- `AGENTS.md`
- `LESSONS.md`
- `rules/default.rules`
- `skills/`

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
