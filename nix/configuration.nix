{ pkgs, lib, ... }:

{
	nix.useDaemon = true;
	users.users.theo.home = "/Users/theo";
	users.users.theo.shell = pkgs.zsh;
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
		pkgs.spotify
		pkgs.slack
		pkgs.discord
		pkgs.obsidian
		pkgs.python3
		pkgs.awscli2
		pkgs.go
	];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "steam"
    "steam-original"
    "steam-run"
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
	nix-index.enable = true;
	zsh.enable = true;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
  };

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
			autohide = true;
		};
		finder = {
			AppleShowAllFiles = true;
			CreateDesktop = false;
			QuitMenuItem = true;
			ShowStatusBar = true;
			FXPreferredViewStyle = "Nlsv";
			ShowPathbar = true;
		};
		loginwindow = {
			GuestEnabled = false;
		};
		".GlobalPreferences" = {
			"com.apple.mouse.scaling" = "0.0";
		};
		menuExtraClock.ShowSeconds = true;
		NSGlobalDomain = {
			InitialKeyRepeat = 10;
			KeyRepeat = 1;
			ApplePressAndHoldEnabled = false;
			AppleShowAllExtenions = true;
			NSAutomaticCapitalizationEnabled = false;
			"com.apple.sound.beep.volume" = 0.000;
		};
	};
  };

  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
}
