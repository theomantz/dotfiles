{ pkgs, ... }:
{

	# Make sure the nix daemon always runs
	services.nix-daemon.enable = true;
	# Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
	# services.nix-daemon.package = pkgs.nixFlakes;
	nix = {
		package = pkgs.nix;
		settings.experimental-features = [ "nix-command" "flakes" ];
	};
	
	users.users.theo = {
		name = "theo";
		home = "/Users/theo";
	};

	# if you use zsh (the default on new macOS installations),
	# you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
	programs.zsh.enable = true;
	# bash is enabled by default

	homebrew = {
		enable = true;
		onActivation.upgrade = true;

		casks = [
			"amethyst"
			"bitwarden"
			"git-credential-manager" 
			"intellij-idea"
			"iterm2"
			"obsidian"
			"slack"
			"spotify"
			"visual-studio-code"
			"signal"
			"adobe-creative-cloud"
		];
	};
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users."theo" = { pkgs, ... }: {

	home.stateVersion = "22.05";
	  programs = {
		tmux = { # my tmux configuration, for example
		    enable = true;
		    keyMode = "vi";
		    clock24 = true;
		    historyLimit = 10000;
		    plugins = with pkgs.tmuxPlugins; [
		      vim-tmux-navigator
		      gruvbox
		    ];
		    extraConfig = ''
		      new-session -s main
		      bind-key -n C-a send-prefix
		    '';
		};
		neovim = {
			enable = true;
			defaultEditor = true;
		};
		vscode = {
			enable = true;
			package = pkgs.vscodium;
			extensions = with pkgs.vscode-extensions; [
				dracula-theme.theme-dracula
				vscodevim.vim
				yzhang.markdown-all-in-one
			];      
		};

	};
      };
}
