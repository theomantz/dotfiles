{ pkgs, ... }:

{
  system.stateVersion = 5;
  ids.gids.nixbld = 30000;
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.theo = {
    home = "/Users/theo";
    shell = pkgs.zsh;
  };

  system.primaryUser = "theo";
}
