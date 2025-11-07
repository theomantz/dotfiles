{ pkgs, lib, ... }:

{
  system.stateVersion = 5;
  ids.gids.nixbld = 30000;
	users.users.theo.home = "/Users/theo";
	users.users.theo.shell = pkgs.zsh;
	environment.shells = with pkgs; [ zsh ];
	environment.systemPackages = [
		pkgs.xc # Task executor (from Flake).
		pkgs.neovim
		pkgs.gh
		pkgs.python3
    pkgs.poetry
		pkgs.awscli2
		pkgs.go
		pkgs.docker
    pkgs.docker-compose
    pkgs.postgresql
    pkgs.sshfs
    pkgs.claude-code
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
    zsh = {
      enable = true;
    };
  };

  homebrew = {
    enable = true;
    taps = [
      "isen-ng/homebrew-dotnet-sdk-versions"
    ];
    casks = [
      "signal"
      "opera"
      "iterm2"
      "bitwarden"
      "steam"
      "google-chrome"
      "warp"
      "arc"
      "amethyst"
      "obsidian"
      "goland"
      "intellij-idea"
      "docker-desktop"
      "postman"
      "figma"
      "sf-symbols"
      "discord"
      "protonvpn"
      "dotnet-sdk8-0-300"
      "macfuse"
      "ghostty"
      "slack"
      "claude"
    ];
    onActivation = {
      upgrade = true;
      cleanup = "uninstall";
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  system = {
    primaryUser = "theo";
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
        "com.apple.mouse.scaling" = 0.3;
      };
      menuExtraClock.ShowSeconds = true;
      NSGlobalDomain = {
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        "com.apple.sound.beep.volume" = 0.000;
      };
    };
  };

  security = {
    pam = {
      services = {
        sudo_local = {
          touchIdAuth = true;
        };
      };
    };
  };
}
