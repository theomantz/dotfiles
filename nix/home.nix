{ config, pkgs, lib, ...}:
{

	programs.home-manager = {
    enable = true;
  };
	home.stateVersion = "22.05";


	home.packages = with pkgs; [
		awscli2
		bat
		claude-code
		codex
		coreutils
		curl
		docker
		docker-compose
		go
		nodejs
		poetry
		postgresql
		purescript
		python3
		ripgrep
		sshfs
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
		htop = {
			enable = true;
			settings = {
				show_program_path = true;
			};
		};
		direnv = {
			enable = true;
			nix-direnv = {
				enable = true;
			};
		};
			git = {
				enable = true;
			ignores = [".DS_Store" "node_modules/" ".direnv/"];
			settings = {
				credential.helper = "${
					pkgs.git.override {withLibsecret = true;}
				}/bin/git-credential-libsecret";
				init.defaultBranch = "main";
        user = {
          name = "theomantz";
          email = "theo@mantz.nyc";
        };
			};
			gh = {
				enable = true;
				settings = {
					aliases = {
						co = "pr checkout";
					};
					accessible_colors = "disabled";
					accessible_prompter = "disabled";
					color_labels = "disabled";
					git_protocol = "https";
					prefer_editor_prompt = "disabled";
					prompt = "enabled";
					spinner = "enabled";
					version = 1;
				};
			};
			includes = [
				{
					condition = "gitdir:~/work/";
					contents = {
						user = {
							name = "theomantz-luna";
							email = "theo@lead.bank";
						};
					};
				}
			];

		};
		neovim = {
			enable = true;
			defaultEditor = true;
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
