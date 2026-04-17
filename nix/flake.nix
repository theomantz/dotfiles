{
	description = "nix flake configuration for theo's macbook pro";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager"; # ...
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		darwin.url = "github:lnl7/nix-darwin";
		darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
		brew-src = {
			url = "github:Homebrew/brew";
			flake = false;
		};
		nix-homebrew = {
			url = "github:zhaofengli-wip/nix-homebrew";
			inputs.brew-src.follows = "brew-src";
		};
		homebrew-core = {
			url = "github:homebrew/homebrew-core";
			flake = false;
		};
		homebrew-cask = {
			url = "github:homebrew/homebrew-cask";
			flake = false;
		};
		dotnet-sdk-versions = {
			url = "github:isen-ng/homebrew-dotnet-sdk-versions";
			flake = false;
		};
	};

	outputs = { self, nixpkgs, home-manager, darwin, brew-src, nix-homebrew, homebrew-core, homebrew-cask, dotnet-sdk-versions }: {
			darwinConfigurations.theo = darwin.lib.darwinSystem {
					system = "aarch64-darwin";
					modules = [ 
						nix-homebrew.darwinModules.nix-homebrew {
						nix-homebrew = {
							enable = true;
							user = "theo";
								taps = {
									"homebrew/homebrew-core" = homebrew-core;
									"homebrew/homebrew-cask" = homebrew-cask;
									"isen-ng/homebrew-dotnet-sdk-versions" = dotnet-sdk-versions;
								};
							};
					}
					home-manager.darwinModules.home-manager {
						home-manager = {
							useGlobalPkgs = true;
							useUserPackages = true;
							backupFileExtension = "backup";
							users = {
								theo = import ./home.nix;
							};
						};
						}
						./configuration.nix
						./hosts/theo.nix
					];
			};
		};
}
