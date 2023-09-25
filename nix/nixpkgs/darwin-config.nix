{pkgs ? import <nixpkgs>, ...}:
{
	nix = { 
		package = pkgs.nixFlakes;
		settings = { 
			trusted-users = ["@admin"]; 
			substituters = ["https://cache.nixos.org/"]; 
			trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="]; 
			experimental-features = ["nix-command" "flakes"]; 
		}; 
		 configureBuildUsers = true;
	};
	system.stateVersion = 4;
} 
