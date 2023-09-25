{
	description = "nix flake configuration for theo's macbook pro";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin"; 
		home-manager.url = "github:nix-community/home-manager/release-23.05"; # ...
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		darwin.url = "github:lnl7/nix-darwin";
		darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
		nix-homebrew = {
			url = "github:zhaofengli-wip/nix-homebrew";
		};
		homebrew-core = {
			url = "github:homebrew/homebrew-core";
			flake = false;
		};
		homebrew-cask = {
			url = "github:homebrew/homebrew-cask";
			flake = false;
		};
		homebrew-cask-versions = {
			url = "github:homebrew/homebrew-cask-versions";
			flake = false;
		};
	};

	outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, homebrew-core, homebrew-cask, homebrew-cask-versions }: {
		darwinConfigurations.Theos-MacBook-Pro = darwin.lib.darwinSystem {
				system = "x86_64-darwin";
				modules = [ 
					nix-homebrew.darwinModules.nix-homebrew {
						nix-homebrew = {
							enable = true;
							user = "theomantz";
							taps = {
								"homebrew/homebrew-core" = homebrew-core;
								"homebrew/homebrew-cask" = homebrew-cask;
								"homebrew/homebrew-cask-versions" = homebrew-cask-versions;
							};
						};
					}
					home-manager.darwinModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.theomantz = import ./home.nix;
					}
					./configuration.nix
				];
		};
	};
}
