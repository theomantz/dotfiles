{ pkgs, lib, ... }:

let
  greedyCask = name: {
    inherit name;
    greedy = true;
  };

  autoUpgradeCasks = [
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
    "macfuse"
    "ghostty"
    "slack"
    "claude"
    "chatgpt"
    "codex"
  ];

  pinnedCasks = [
    "dotnet-sdk8-0-300"
  ];
in

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
    brews = [
      "gemini-cli"
    ];
    casks =
      # Regular apps that should stay current even when the cask disables
      # upgrades by default.
      (map greedyCask autoUpgradeCasks)
      ++
      # Versioned or intentionally pinned casks that should only change when
      # edited here.
      pinnedCasks;
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
