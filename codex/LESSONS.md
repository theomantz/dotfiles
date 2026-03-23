# LESSONS

Use this file to capture repeat issues, root causes, and proven fixes across repos.
Read this before starting new work, and add to it after incidents or notable mistakes.

## How to Add an Entry

Use this format:

```md
### YYYY-MM-DD - Short title
- Context: repo/task
- Symptom: what went wrong
- Root cause: why it happened
- Fix: what resolved it
- Prevention: checks or workflow changes to avoid recurrence
```

## Global Lessons

### 2026-03-23 - Codex persistent approvals live in `rules/default.rules`
- Context: dotfiles task to version-control Codex approvals and settings
- Symptom: `config.toml` did not contain the approved command prefix history that actually controlled prompt behavior
- Root cause: Codex stores persistent exec approval rules separately under `~/.codex/rules/default.rules`
- Fix: manage `config.toml` and `rules/default.rules` together, and treat the rules file as the durable source of truth for allow/deny behavior
- Prevention: when migrating or backing up Codex settings, always include the `rules/` directory rather than assuming approvals are embedded in `config.toml`

### 2026-03-15 - Quote extras specifiers in zsh pip installs
- Context: prediction_markets_poc backend validation from a disposable venv
- Symptom: `python -m pip install -e /path/to/backend[dev]` failed with `zsh: no matches found`
- Root cause: zsh treated `[dev]` as a glob pattern before pip saw the requirement string
- Fix: quote editable install targets that include extras, for example `python -m pip install -e '/path/to/backend[dev]'`
- Prevention: when running pip commands with extras from zsh, default to quoting the full requirement argument

### 2026-03-15 - Local OpenAPI generation can drift with newer FastAPI/Pydantic toolchains
- Context: prediction_markets_poc contract-artifact validation on macOS Python 3.14
- Symptom: regenerating OpenAPI changed `ValidationError` schemas (`ctx`/`input`) without any repo code changes
- Root cause: local dependency versions/toolchain behavior differed from the repo's CI baseline, altering FastAPI/Pydantic schema output
- Fix: treat unexpected generated OpenAPI diffs as a toolchain mismatch first, verify against the repo's pinned CI environment, and revert artifact churn if the task did not intentionally change API contracts
- Prevention: for contract artifact checks, prefer the repo's pinned toolchain path and be cautious about trusting locally regenerated OpenAPI on newer Python/FastAPI stacks

### 2026-03-01 - Worktree without flake.nix
- Context: prediction_markets_poc task worktree validation
- Symptom: `nix develop` failed in a task worktree with “path ... is not part of a flake.”
- Root cause: the task worktree did not include `flake.nix`; the flake lives in the shared parent workspace.
- Fix: run `nix develop <parent-flake-path> -c ...` when operating from nested worktrees.
- Prevention: verify flake root before running Nix commands and prefer explicit flake paths in automation scripts.

### 2026-03-01 - Nix shell startup stalls without useful output
- Context: prediction_markets_poc PR validation in a fresh task worktree
- Symptom: `nix develop <flake-path> -c ...` consumed CPU for minutes with no streamed output.
- Root cause: first-time shell materialization can run for a while without emitting logs in non-TTY runs.
- Fix: if the shell does not become usable promptly, run `poetry install` in `backend/` and continue with the same CI-equivalent `poetry run ...` checks.
- Prevention: attempt the Nix path first, but keep a local Poetry fallback ready so validation is not blocked.

### 2026-03-02 - Backend quality CI checks changed-file formatting and typing
- Context: prediction_markets_poc PR follow-up fixes
- Symptom: local `ruff check` and full `pytest` passed, but `backend_quality` failed in CI.
- Root cause: CI enforces `ruff format --check` and `mypy --follow-imports=skip` on changed Python files, which can fail independently of `ruff check`.
- Fix: run `poetry run ruff format --check <changed_py_files>` and `poetry run mypy --follow-imports=skip --pretty --show-error-codes <changed_py_files>` before pushing.
- Prevention: include these two commands in the local pre-push validation checklist whenever backend Python files change.

### 2026-03-04 - `docker compose config` still requires service `env_file` paths
- Context: prediction_markets_poc compose hardening validation
- Symptom: `docker compose config` failed with `.env not found` even when `--env-file .env.example` was passed.
- Root cause: service-level `env_file: .env` must exist on disk; CLI `--env-file` only provides interpolation values.
- Fix: create a temporary `.env` (for example from `.env.example`) before running `docker compose config`, then remove it.
- Prevention: keep a local `.env` present for compose validation commands or script temporary creation/cleanup.

## Repo-Specific Lessons

Track repo-specific lessons in each repo's local `LESSONS.md`.

## Pre-Task Quick Check

- Read `~/.codex/AGENTS.md`.
- Read `~/.codex/LESSONS.md`.
- Read repo-local `AGENTS.md` and `LESSONS.md` if present.
- Start in a fresh worktree.

### 2026-03-04 - Bash changed-file loop can fail on deleted paths under `-e`
- Context: prediction_markets_poc CI `backend_quality` changed-file checks
- Symptom: CI exited with code `1` before running `ruff format --check` even after filtering out deleted files.
- Root cause: loop body used `[ -f "$path" ] && printf ...`; on missing files this returned non-zero, and `bash -e` treated the command substitution as failure.
- Fix: use an explicit `if [ -f "$path" ]; then printf ...; fi` loop body so missing files do not produce a failing status.
- Prevention: when filtering changed/deleted paths inside `bash -e` scripts, avoid short-circuit predicates that can return non-zero for expected conditions.

### 2026-03-04 - Large changed-file argument lists should use `xargs`
- Context: prediction_markets_poc repo-wide namespace migration touched ~100 Python tests/modules.
- Symptom: commands like `ruff format --check $changed_py` and `perl -pi ... $files` failed with `File name too long` or treated the full list as one path.
- Root cause: shell-expanded argument strings exceeded practical limits or had unsafe splitting.
- Fix: pipe newline-delimited file lists into `xargs` (for example, `git diff --name-only -- '*.py' | xargs poetry run ruff format --check`).
- Prevention: default to `xargs` for bulk file rewrites/checks whenever changed-file lists can be large.

### 2026-03-04 - Use heredocs for `gh pr comment` bodies containing backticks
- Context: prediction_markets_poc PR workflow comment updates.
- Symptom: `gh pr comment --body "..."` posted a mangled comment and executed unexpected shell fragments.
- Root cause: unescaped backticks in a double-quoted shell string triggered command substitution before `gh` received the body text.
- Fix: pass comment text with `--body-file - <<'EOF' ... EOF` (or single-quote/escape backticks) so markdown code spans are preserved literally.
- Prevention: never send markdown with backticks via double-quoted shell strings in CLI commands.

### 2026-03-06 - SSE clients can block until first flush if headers are not written
- Context: novig-take-home core/replica SSE replication.
- Symptom: replica stream `GET /stream` appeared disconnected because `Do(req)` did not return promptly.
- Root cause: SSE handler set headers but did not write/flush any bytes until first business event or delayed heartbeat.
- Fix: write an initial SSE comment frame (for example `:connected\n\n`) and flush immediately after setting headers.
- Prevention: in SSE endpoints, always flush an initial frame at connection setup so clients establish the stream deterministically.

### 2026-03-06 - zsh does not split newline-delimited vars like bash
- Context: prediction_markets_poc PR workflow changed-file lint/typecheck commands.
- Symptom: `ruff format --check $changed` treated multiple newline-delimited file paths as one invalid path.
- Root cause: default zsh does not perform `sh`-style word splitting on unquoted parameter expansion.
- Fix: pass newline-delimited file lists through `xargs` (or explicit arrays) instead of relying on unquoted `$var` splitting.
- Prevention: for changed-file command lists in zsh, use `printf '%s\n' "$files" | xargs ...` as the default pattern.

### 2026-03-07 - PR review replies need GraphQL node IDs, not REST numeric IDs
- Context: novig-take-home PR thread resolution workflow.
- Symptom: replying to review comments via `POST /repos/{owner}/{repo}/pulls/comments/{id}/replies` failed with `404` when using `PRRC_...` identifiers from GraphQL.
- Root cause: REST reply endpoint expects numeric comment IDs, while GraphQL returns opaque node IDs.
- Fix: use GraphQL `addPullRequestReviewComment` with `inReplyTo` set to the `PRRC_...` node ID, then resolve threads via `resolveReviewThread`.
- Prevention: when IDs originate from GraphQL review thread queries, stay in GraphQL for replies/resolution instead of mixing REST endpoints.

### 2026-03-07 - Avoid running `nix develop` commands in parallel in one workspace
- Context: novig-take-home validation (`go test` + `go vet`) run concurrently via parallel tool calls.
- Symptom: one command emitted `SQLite database ... eval-cache ... is busy`.
- Root cause: concurrent `nix develop` invocations contended on Nix eval cache DB locks.
- Fix: rerun validation commands serially when using `nix develop`.
- Prevention: default to sequential `nix develop -c ...` checks in the same repo/worktree.

### 2026-03-07 - SQLite INTEGER PRIMARY KEY often covers seq max/reverse lookups
- Context: novig-take-home event_log reverse-seq optimization benchmark.
- Symptom: concern that `ORDER BY seq DESC LIMIT 1` and `MAX(seq)` needed an explicit `seq DESC` index as volume grows.
- Root cause: assumption that reverse-order lookup required an additional index despite `seq INTEGER PRIMARY KEY` already backing rowid-ordered access.
- Fix: benchmark baseline vs explicit `seq DESC` index at multiple row volumes before adding schema changes.
- Prevention: for SQLite tables keyed by monotonic `INTEGER PRIMARY KEY`, require measured wins before adding extra directional indexes on the same key.

### 2026-03-07 - `gh pr merge --delete-branch` fails when branch is active in a worktree
- Context: novig-take-home bulk PR merge workflow across multiple task worktrees.
- Symptom: merge succeeded, but `gh pr merge --delete-branch` exited non-zero with "cannot delete branch ... used by worktree".
- Root cause: local branch deletion runs immediately after merge, but Git refuses deletion while that branch is checked out in any linked worktree.
- Fix: confirm merge status, remove the branch's worktree, then delete the local branch manually.
- Prevention: when using per-PR worktrees, treat local branch cleanup as a post-merge step outside `gh pr merge --delete-branch`.

### 2026-03-09 - REST PR review replies require pull-number-scoped endpoint
- Context: novig-take-home PR feedback response when GraphQL reply mutation lacked permission.
- Symptom: `POST /repos/{owner}/{repo}/pulls/comments/{comment_id}/replies` returned `404` despite a valid numeric comment ID.
- Root cause: the REST reply endpoint requires the pull number segment (`/pulls/{pull_number}/comments/.../replies`), not the shorter path.
- Fix: use `POST /repos/{owner}/{repo}/pulls/{pull_number}/comments/{comment_id}/replies` for in-thread replies, then resolve via GraphQL `resolveReviewThread`.
- Prevention: when falling back from GraphQL review replies to REST, include `pull_number` in the route and verify with one known thread first.

### 2026-03-09 - Non-interactive `git rebase --continue` can hang on editor launch
- Context: novig-take-home PR workflow rebase in a non-interactive Codex exec session.
- Symptom: `git rebase --continue` appeared stuck with no output while the worktree showed detached `HEAD` and staged changes.
- Root cause: Git launched `nvim` for the rebase commit message, but the command was not run with an interactive TTY/editor flow.
- Fix: terminate the spawned editor process and rerun `GIT_EDITOR=true git rebase --continue`.
- Prevention: for automated rebase/cherry-pick flows, set `GIT_EDITOR=true` (or `git -c core.editor=true ...`) up front.

### 2026-03-09 - GitHub blocks self-approval on PR reviews
- Context: novig-take-home open-PR review cycle using `gh pr review`.
- Symptom: `gh pr review <pr> --approve` failed with `Review Can not approve your own pull request`.
- Root cause: GitHub disallows approving reviews from the same account that authored the PR.
- Fix: skip approval for self-authored PRs; rely on explicit self-review notes plus required validation and proceed to merge when policy allows.
- Prevention: detect PR author before attempting approval and only run `--approve` when reviewer differs from author.

### 2026-03-09 - Cancel shared context before service shutdown in demos
- Context: novig-take-home `cmd/demo` cleanup flow with core/replica goroutines.
- Symptom: process shutdown produced transient heartbeat/connection errors and could look hung after successful checks.
- Root cause: shared context cancellation happened after deferred HTTP shutdown started, so background goroutines kept making dependent calls during teardown.
- Fix: call the shared cancel function before entering deferred server shutdown/close paths.
- Prevention: in multi-service demos and integration harnesses, order teardown as `cancel context -> shutdown services -> close stores`.

### 2026-03-09 - `.RECIPEPREFIX` is not portable across older `make` versions
- Context: novig-take-home Makefile migration from a shell test script.
- Symptom: `make help` failed with parse errors (`missing separator` / `multiple target patterns`) despite valid-looking recipe lines.
- Root cause: local `make` did not support `.RECIPEPREFIX` (feature introduced after GNU make 3.81), so custom `>` recipe prefixes were parsed as ordinary lines.
- Fix: switch to portable make syntax (tab-prefixed recipes or target-inline `;` recipes) and remove `.RECIPEPREFIX`.
- Prevention: avoid `.RECIPEPREFIX` unless toolchain version is pinned/verified; default to portable recipe formatting in shared repos.

### 2026-03-09 - zsh reserves `status` as a read-only shell parameter
- Context: novig-take-home PR workflow check-status polling script.
- Symptom: loop script failed immediately with `zsh: read-only variable: status`.
- Root cause: `status` is a special read-only parameter in zsh.
- Fix: use a different variable name (for example, `check_status`) or run the script under bash.
- Prevention: avoid using `status` as a variable name in zsh automation snippets.
