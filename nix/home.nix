{ config, pkgs, lib, configurationName, ...}:
{

	programs.home-manager = {
    enable = true;
  };
	home.stateVersion = "22.05";
	home.sessionPath = [
		"$HOME/go/bin"
		"/run/current-system/sw/bin"
	];
	home.file = {
		".codex/AGENTS.md".source = ../codex/AGENTS.md;
		".codex/LESSONS.md".source = ../codex/LESSONS.md;
		".codex/skills" = {
			source = ../codex/skills;
			recursive = true;
		};
	};

	home.file.".codex/config.toml".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/codex/config.toml";
	home.file.".codex/rules/default.rules".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/codex/rules/default.rules";
	home.file.".config/gh/config.yml" = {
		source = ./files/gh/config.yml;
		force = true;
	};
	home.file.".config/git/config" = {
		source = ./files/git/config;
		force = true;
	};
	home.file.".config/git/ignore" = {
		source = ./files/git/ignore;
		force = true;
	};
	home.file.".config/git/work.gitconfig" = {
		source = ./files/git/work.gitconfig;
		force = true;
	};
	home.file.".config/htop/htoprc" = {
		source = ./files/htop/htoprc;
		force = true;
	};
	home.file."Library/Application Support/Code/User/settings.json".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/vscode/settings.json";


	home.packages = with pkgs; [
		awscli2
		bat
		claude-code
		codex
		coreutils
		curl
		docker
		docker-compose
		gh
		git
		go
		htop
		poppler
		purescript
		ripgrep
		sqlite
		sshfs
		tmux
		wget
		xc
	] ++ lib.optionals pkgs.stdenv.isDarwin [
		m-cli
	];

	nix = {
		settings.experimental-features = ["nix-command" "flakes"];
	};

	programs = {
		fzf.enable = true;
		jq.enable = true;
		direnv = {
			enable = true;
			package = pkgs.direnv.overrideAttrs (_: {
				doCheck = false;
			});
			nix-direnv = {
				enable = true;
			};
		};
		neovim = {
			enable = true;
			defaultEditor = true;
			withPython3 = true;
			withRuby = true;
			initLua = ''
				require("config.lazy")
			'';
		};
		zsh = {
			enable = true;
			autocd = true;
			autosuggestion.enable = true;
			enableCompletion = true;
			shellAliases = {
				drs = "sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ${config.home.homeDirectory}/.config/nix#${configurationName}";
				ls = "ls -la";
				vim = "nvim";
				vi = "nvim";
			};
			oh-my-zsh= {
				enable = true;
				plugins = [ "git" ];
				theme = "robbyrussell";
			};
			initContent = ''
				eval "$(/opt/homebrew/bin/brew shellenv)"
			'';
		};
	};
}
