## What changed

- replaces automatic GitHub Copilot review with the Kimi Code Review action
- automatically reviews new, reopened, and updated same-repository pull requests
- supports trusted collaborators' `/review`, `/ask`, and `/help` commands
- pins the third-party Kimi action to an immutable commit

## Why

Kimi is now the standard automated reviewer across the owned repositories. The workflow includes the Git authentication required for private repositories and prevents untrusted commenters from consuming Kimi API credits.

## Expected impact

After merge, eligible pull requests will receive Kimi reviews and trusted collaborators can use Kimi's PR commands. Fork pull requests and Dependabot pull requests are intentionally skipped because GitHub does not expose repository secrets to those runs.

## Risks and rollback

The workflow sends pull-request diffs and repository code to Moonshot AI through a third-party, GitHub-uncertified action. The action runs its agent with automatic tool approval in an ephemeral runner, so automatic runs are limited to branches in the repository and command triggers are limited to trusted collaborators. The action is commit-pinned, but its container installs two Python dependencies from version ranges at build time. To roll back, revert this pull request or remove `.github/workflows/kimi-review.yml` and the `KIMI_API_KEY` repository secret.

## Validation

- `actionlint github/workflows/kimi-review.yml`
- `shellcheck scripts/rollout-kimi-reviewer`
- rollout script dry-run with a stubbed GitHub CLI

## Follow-up

After this pull request merges, rerun the rollout command. It detects the workflow on the default branch and removes any repository-owned `copilot_code_review` rules while preserving every other ruleset field and rule.
