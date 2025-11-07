{ config, pkgs, lib, ...}:
{

	programs.home-manager = {
    enable = true;
  };
	home.stateVersion = "22.05";


	home.packages = with pkgs; [
		coreutils
		curl
		wget
		jq
		nodePackages.typescript
		nodePackages.node2nix
		nodePackages.prettier
		nodePackages.aws-cdk
    nodePackages.yarn
		nodejs
		purescript
		htop
		ripgrep
		gh
		zsh
		oh-my-zsh
    fzf
	] ++ lib.optionals stdenv.isDarwin [
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
			user = {
				name = "theomantz";
				email = "theo@mantz.nyc";
			};
			ignores = [".DS_Store" "node_modules/" ".direnv/"];
			settings = {
				credential.helper = "${
					pkgs.git.override {withLibsecret = true;}
				}/bin/git-credential-libsecret";
				init.defaultBranch = "main";
			};

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
		gh = {
			enable = true;
			settings = {
				git_protocol = "ssh";
				hosts = ["github.com"];
				editor = "nvim";

			};
		};
	};
}
