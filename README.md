
# Nix managed macOS configuration using Nix, Home Manager, and nix-darwin

### Steps to rebuild
 1. Clone the repository into `~/.config`.
        
    ```shell
    git clone git@github.com:theomantz/dotfiles.git ~/.config
    ```

 2. If the computer being set up is completely fresh, install the Xcode command line tools first.
   
    ```shell
    xcode-select --install
    ```

3. Download and install [Nix](https://nixos.org/download#nix-install-macos):
    ```shell
    sh <(curl -L https://nixos.org/nix/install)
    ```

4. Edit the configuration if the target machine does not match the values currently checked in.

    ```shell
    # in nix/flake.nix
    darwinConfigurations.<name> = darwin.lib.darwinSystem {
        system = "<system_architecture>"
        ... remaining configuration
    }

    # in nix/hosts/<name>.nix
    nixpkgs.hostPlatform = "<system_architecture>"
    users.users.<user>.home = "<user_home_dir>"
    system.primaryUser = "<user>"

    # in nix/configuration.nix
    # keep system defaults and GUI apps here
    ```
    CLI tools and user programs live in `nix/home.nix` while GUI apps and macOS defaults live in `nix/configuration.nix`.

    Repo-owned config under `~/.config` is edited directly here and linked into place by Home Manager where needed. That includes `codex/`, `git/`, `gh/config.yml`, `htop/`, and `vscode/settings.json`. Machine-local state such as `gh/hosts.yml` stays ignored.
5. Build the system from the repo root or point Nix at the `nix/` flake explicitly.

    ```shell
    cd ~/.config
    nix build --stack-trace --extra-experimental-features 'nix-command flakes' ./nix#darwinConfigurations.theo.system
    ```
    If you are already in `~/.config/nix`, the equivalent command is:

    ```shell
    nix build --stack-trace --extra-experimental-features 'nix-command flakes' .#darwinConfigurations.theo.system
    ```

    Note: `--extra-experimental-features` only needs to be added until Nix has been configured with `nix-command` and `flakes`.

6. Apply the configuration from `~/.config/nix`.

    ```shell
    cd ~/.config/nix
    ./result/sw/bin/darwin-rebuild switch --flake .
    ```

7. Enjoy.


    
