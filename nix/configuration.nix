{ pkgs, lib, ... }:

{
	nix.useDaemon = true;
	users.users.theomantz.home = "/Users/theomantz";
	users.users.theomantz.shell = pkgs.zsh;
	environment.shells = with pkgs; [ zsh ];
	environment.systemPackages = [
		pkgs.xc # Task executor (from Flake).
		# Java development.
		pkgs.jdk # Development.
		pkgs.openjdk19 # Development.
		pkgs.jre # Runtime.
		pkgs.gradle # Build tool
		pkgs.neovim
		pkgs.home-manager
		pkgs.gh
	];

  nixpkgs.config.allowUnfreePackages = ["vscode"];
  nixpkgs.hostPlatform = "x86_64-darwin";

  programs.nix-index.enable = true;
  programs.zsh.enable = true;

  fonts = {
	fontDir.enable = true;
	fonts = with pkgs; [
		recursive
		(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
	];
  };

  system = {
	keyboard = {
		enableKeyMapping = true;
		remapCapsLockToEscape = true;
	};
	defaults = {
		dock = {
			orientation = "right";
			show-recents = false;
		};
		finder = {
			AppleShowAllFiles = true;
			CreateDesktop = false;
			QuitMenuItem = true;
			ShowStatusBar = true;
		};
		loginwindow = {
			GuestEnabled = false;
		};
		menuExtraClock.ShowSeconds = true;
		NSGlobalDomain = {
			InitialKeyRepeat = 10;
			KeyRepeat = 1;
		};
	};
  };

  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
}
