{ pkgs, lib, ... }:

{
	environment.shells = with pkgs; [ zsh ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "steam"
    "steam-original"
    "steam-run"
  ];

  programs = {
    nix-index.enable = true;
    zsh = {
      enable = true;
    };
  };

  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask"
      "homebrew/core"
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
      {
        name = "docker-desktop";
        greedy = true;
      }
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
      "chatgpt"
      "codex"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

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
