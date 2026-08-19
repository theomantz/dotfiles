
# Nix managed macOS configuration using Nix, Home Manager, and nix-darwin

### Bootstrap
 1. Clone the repository into `~/.config`.
        
    ```shell
    git clone git@github.com:theomantz/dotfiles.git ~/.config
    ```

 2. Run the bootstrap script with the desired profile.

    ```shell
    cd ~/.config
    ./scripts/bootstrap-macos --profile personal
    ```

    For a work machine that should omit personal casks such as `discord`, use:

    ```shell
    cd ~/.config
    ./scripts/bootstrap-macos --profile work
    ```

    The script will:
    - install Xcode command line tools if needed
    - install Nix if needed
    - detect the current macOS username and home directory
    - generate a local bootstrap host descriptor
    - build the selected nix-darwin profile
    - switch the machine to that configuration

### Profiles
- `personal`: full app set
- `work`: excludes personal-only casks such as `discord`, `steam`, `signal`, `opera`, and `protonvpn`

### Manual rebuild
If the target machine does not match the values currently checked in, edit the configuration first.

    ```shell
    # in nix/flake.nix
    darwinConfigurations.<name> = darwin.lib.darwinSystem {
        system = "<system_architecture>"
        ... remaining configuration
    }

    # in nix/hosts/<name>.nix
    username = "<user>"
    homeDirectory = "<user_home_dir>"
    hostPlatform = "<system_architecture>"

    # in nix/configuration.nix
    # keep system defaults and GUI apps here
    ```
    CLI tools and user programs live in `nix/home.nix` while GUI apps and macOS defaults live in `nix/configuration.nix`.

    Repo-owned config under `~/.config` is edited directly here and linked into place by Home Manager where needed. That includes `codex/`, `git/`, `gh/config.yml`, `htop/`, and `vscode/settings.json`. Machine-local state such as `gh/hosts.yml` stays ignored.
Build the system from the repo root or point Nix at the `nix/` flake explicitly.

    ```shell
    cd ~/.config
    nix build --stack-trace --extra-experimental-features 'nix-command flakes' ./nix#darwinConfigurations.theo.system
    ```
    If you are already in `~/.config/nix`, the equivalent command is:

    ```shell
    nix build --stack-trace --extra-experimental-features 'nix-command flakes' .#darwinConfigurations.theo.system
    ```

    Note: `--extra-experimental-features` only needs to be added until Nix has been configured with `nix-command` and `flakes`.

Apply the configuration from `~/.config/nix`.

    ```shell
    cd ~/.config/nix
    ./result/sw/bin/darwin-rebuild switch --flake .
    ```

After the first successful activation, new shells include nix-darwin's current-system bin path and provide:

    ```shell
    drs
    ```

which runs `sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ~/.config/nix#<configuration-name>`.

### Kimi reviewer rollout

The managed reviewer workflow lives at `github/workflows/kimi-review.yml`. The
rollout script targets owned, non-archived, non-empty source repositories,
stores `KIMI_API_KEY` as a repository secret, and opens one focused PR per
repository.

Authenticate the Nix-managed GitHub CLI and preview the scope first:

```shell
gh auth login --hostname github.com
./scripts/rollout-kimi-reviewer --dry-run
```

For the live rollout, put the Kimi key in the current shell without adding it
to shell history, then run the script:

```shell
read -rsp "Kimi API key: " KIMI_API_KEY
echo
export KIMI_API_KEY
./scripts/rollout-kimi-reviewer
unset KIMI_API_KEY
```

The first live run creates the workflow PRs without disabling Copilot review.
After those PRs merge, rerun the same command. Repositories whose Kimi workflow
is active then have only the `copilot_code_review` rule removed from their
repository-owned rulesets; all other rules and ruleset fields are preserved.

The workflow intentionally skips fork and Dependabot pull requests because
GitHub does not make repository secrets available to those runs. Kimi is a
third-party, GitHub-uncertified action, so pull-request diffs and repository code
are sent to Moonshot AI. Its agent automatically approves tool use inside the
ephemeral runner, which is why automatic runs are limited to same-repository
branches and commands are limited to trusted collaborators. The action is pinned
to an immutable commit rather than a mutable branch; its relevant event, clone,
and agent-execution paths were inspected as part of this rollout.


    
