{ config, pkgs, lib, profile ? "personal", ... }:

let
  greedyCask = name: {
    inherit name;
    greedy = true;
  };

  alwaysInstalledCasks = [
    "iterm2"
    "bitwarden"
    "1password"
    "google-chrome"
    "warp"
    "arc"
    "amethyst"
    "obsidian"
    "docker-desktop"
    "postman"
    "figma"
    "sf-symbols"
    "macfuse"
    "ghostty"
    "slack"
    "claude"
    "chatgpt"
    "codex"
  ];

  personalOnlyCasks = [
    "signal"
    "opera"
    "discord"
    "protonvpn"
  ];

  autoUpgradeCasks =
    alwaysInstalledCasks
    ++ lib.optionals (profile != "work") personalOnlyCasks;

  trustedCaskConfig = ''
    # nix-darwin does not expose Homebrew Bundle's `trusted` cask option yet.
    cask "isen-ng/dotnet-sdk-versions/dotnet-sdk8-0-300", greedy: true, trusted: true
  '';
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
    casks = map greedyCask autoUpgradeCasks;
    extraConfig = trustedCaskConfig;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
  };

  system.activationScripts.homebrew.text = lib.mkOrder 750 ''
    if [ -f "${config.homebrew.prefix}/bin/brew" ]; then
      PATH="${config.homebrew.prefix}/bin:$PATH" \
      sudo \
        --preserve-env=PATH \
        --user=${lib.escapeShellArg config.homebrew.user} \
        --set-home \
        env \
        brew trust --quiet --tap isen-ng/dotnet-sdk-versions
    fi
  '';

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
