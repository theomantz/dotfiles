{pkgs ? import <nixpkgs>, ...}:
{
	nix = { 
		settings = { 
			trusted-users = ["@admin"]; 
			substituters = ["https://cache.nixos.org/"]; 
			trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="]; 
		}; 
		 configureBuildUsers = true;
	};
	system.stateVersion = 4;
	services.nix-daemon.enable = true;
	programs.zsh.enable = true;
} 
