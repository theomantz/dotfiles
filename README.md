
# Nix managed macOS Configuration using nix, home-manager, and nix-darwin

### Steps to rebuild
 1. Create a directory within the user home directory which will house the configuration files and clone the repository.
        
    ```shell
    cd ~ && mkdir .config && gh repo clone dotfiles ~/.config
    ```

 2. If the computer being set up is completely fresh `xcode-select` may need to be installed.
   
    ```shell
    xcode-select --install
    ```

3. Download and install [nix](https://nixos.org/download#nix-install-macos):
    ```shell
    sh <(curl -L https://nixos.org/nix/install)
    ```

4. Edit the files within the configurations so that the configured system architecture matches the actual architecture of the system, the configured system name matches matches the actual system name, and the configured user home directory matches the actual user home directory.

    ```shell
    # make sure the following example parameters match the system attributes
    # in flake.nix
    darwinConfigurations.<name> = darwin.lib.system {
        system = "<system_architecture>"
        ... remaining configuration
    }

    # in configuration.nix
    {...}: 
    {
        users.user.<user>.home = "<user_home_dir>"
    }
    ```
    and so on.
5. Run nix build from the configuraiton directory or the nix subdirectory of the configuration directory.

    ```shell
    nix build --stack-trace --extra-experimental-features 'nix-command flakes' .#darwinConfigurations.theo.system
    ```
    **note**: `--extra-experimental-features` will only need to be added once. After the first build, its added to `nix.conf` and is no longer needed as a flag to the `nix build` command.

5. Run `./result/sw/bin/darwin-rebuild switch --flake .` from within the `nix` subdirectory of the `~/.config` directory.
6. Enjoy!


    