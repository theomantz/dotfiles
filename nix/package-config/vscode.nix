{ pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];
  environment.systemPackages = with pkgs; [ 
    vscode
  ];
}
