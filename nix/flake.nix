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

	outputs = { self, nixpkgs, home-manager, darwin, brew-src, nix-homebrew, homebrew-core, homebrew-cask, dotnet-sdk-versions }:
	let
		mkDarwinConfiguration = { host, profile }:
			let
				username = host.username;
				homeDirectory = host.homeDirectory;
				hostPlatform = host.hostPlatform;
				stateVersion = host.stateVersion;
			in
			darwin.lib.darwinSystem {
				system = hostPlatform;
				specialArgs = {
					inherit profile;
				};
				modules = [
					nix-homebrew.darwinModules.nix-homebrew
					{
						nix-homebrew = {
							enable = true;
							user = username;
							taps = {
								"homebrew/homebrew-core" = homebrew-core;
								"homebrew/homebrew-cask" = homebrew-cask;
								"isen-ng/homebrew-dotnet-sdk-versions" = dotnet-sdk-versions;
							};
						};
					}
					({ pkgs, ... }: {
						system.stateVersion = stateVersion;
						ids.gids.nixbld = 30000;
						nixpkgs.hostPlatform = hostPlatform;

						users.users.${username} = {
							home = homeDirectory;
							shell = pkgs.zsh;
						};

						system.primaryUser = username;
					})
					home-manager.darwinModules.home-manager
					{
						home-manager = {
							useGlobalPkgs = true;
							useUserPackages = true;
							backupFileExtension = "backup";
							users = {
								${username} = import ./home.nix;
							};
						};
					}
					./configuration.nix
				];
			};
		theoHost = import ./hosts/theo.nix;
		workHost = import ./hosts/work.nix;
		bootstrapHost =
			if builtins.pathExists ./hosts/bootstrap.local.nix
			then import ./hosts/bootstrap.local.nix
			else import ./hosts/bootstrap.nix;
	in {
		darwinConfigurations = {
			personal = mkDarwinConfiguration {
				host = theoHost;
				profile = "personal";
			};
			theo = mkDarwinConfiguration {
				host = theoHost;
				profile = "personal";
			};
			work = mkDarwinConfiguration {
				host = workHost;
				profile = "work";
			};
			bootstrap-personal = mkDarwinConfiguration {
				host = bootstrapHost;
				profile = "personal";
			};
			bootstrap-work = mkDarwinConfiguration {
				host = bootstrapHost;
				profile = "work";
			};
		};
	};
}
