# Global Subagent Rules

These rules apply to all subagents working under `/Users/theo`.
If a repo has its own `AGENTS.md`, follow the stricter rule when there is overlap.

## Mandatory Workflow

1. Start every task with a discussion message before doing implementation work.
   Minimum: restate the request, confirm intended approach, and call out assumptions.
2. Create a fresh git worktree for every new task.
   Do not implement tasks directly in a primary checkout.
3. Avoid sharing a working directory with another agent.
   Prefer one task per worktree and one active agent per worktree.
4. Every task must end with a PR.
   Do not consider work complete until a PR exists.
5. Perform a thorough self-review before opening/submitting the PR.
   Fix issues found in self-review before requesting external review.
6. Run all required tests and linters before submitting the PR, and ensure they pass.
   If anything fails, fix it first and rerun.
7. PR descriptions must be high quality and complete.
   Include: what changed, why it changed, expected impact, risks, validation performed, and follow-ups.
8. Use Nix-managed tooling.
   If a dependency/tool is unavailable in the current shell, use `nix develop` and retry.
9. Review lessons files before starting and update them when you learn something reusable.
   Check both `~/.codex/LESSONS.md` and the repo-local `LESSONS.md` (if present).

## PR Review and Merge Workflow

1. Fetch and sync with the latest `main` (rebase or merge), ensure there are no conflicts, then rerun required local tests/linters.
2. Address all review comments; reply in-thread with what changed for each thread, then resolve.
3. Perform a thorough self-review.
4. Ensure the PR description matches the final diff (what changed, why, impact, validation, and rollback notes).
5. Ensure CI/CD is passing.
6. Merge the PR.
7. After merge, delete the task branch/worktree and capture any follow-up actions.

## Operational Defaults

- Worktree naming: `wt_<short-task-name>_<YYYYMMDD>`.
- Branch naming: `feat/<short-task-name>`, `fix/<short-task-name>`, or `chore/<short-task-name>`.
- Never commit directly to `main`; always use a branch and PR.
- Keep PRs focused: one logical change per PR unless explicitly coordinating a stacked series.
- Before opening a PR, verify the branch is up to date with its base and conflict-free.
- CI must be green before merge.
- Risky changes must include rollback/backout notes in the PR description.
- After merge, clean up the task worktree and branch unless retention is explicitly needed.
