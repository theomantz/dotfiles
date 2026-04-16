{ config, pkgs, lib, ...}:
{

	programs.home-manager = {
    enable = true;
  };
	home.stateVersion = "22.05";
	home.sessionPath = [
		"$HOME/go/bin"
	];
	home.file = {
		".codex/AGENTS.md".source = ../codex/AGENTS.md;
		".codex/LESSONS.md".source = ../codex/LESSONS.md;
		".codex/config.toml".source = ../codex/config.toml;
		".codex/rules/default.rules".source = ../codex/rules/default.rules;
		".codex/skills" = {
			source = ../codex/skills;
			recursive = true;
		};
	};

	home.file.".codex/config.toml".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/codex/config.toml";
	home.file.".config/gh/config.yml".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/gh/config.yml";
	home.file.".config/git/config".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/git/config";
	home.file.".config/git/ignore".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/git/ignore";
	home.file.".config/git/work.gitconfig".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/git/work.gitconfig";
	home.file.".config/htop/htoprc".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/htop/htoprc";
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
			nix-direnv = {
				enable = true;
			};
		};
		neovim = {
			enable = true;
			defaultEditor = true;
			withPython3 = true;
			withRuby = true;
		};
		zsh = {
			enable = true;
			autocd = true;
			autosuggestion.enable = true;
			enableCompletion = true;
			shellAliases = {
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
