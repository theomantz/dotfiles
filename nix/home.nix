{ config, pkgs, ...}:

{
	programs.direnv.enable = true;
	programs.direnv.nix-direnv.enable = true;

	programs.htop.enable = true;
	programs.htop.settings.show_program_path = true;

	programs.home-manager.enable = true;
	home.stateVersion = "22.05";


	home.packages = with pkgs; [
		coreutils
		curl
		wget
		jq
		nodePackages.typescript
		nodePackages.node2nix
		nodePackages.prettier
		nodejs
		purescript
		htop
		ripgrep
		gh
		zsh
		oh-my-zsh
		bitwarden-cli
		gitAndTools.gh
	] ++ lib.optionals stdenv.isDarwin [
		m-cli
	];


	programs = {
		git = {
			enable = true;
			userName = "theomantz";
			userEmail = "theo@mantz.nyc";
			ignores = [".DS_Store" "node_modules"];
			extraConfig = {
				credential.helper = "${
					pkgs.git.override {withLibsecret = true;}
				}/bin/git-credential-libsecret";
			};

		};
		neovim = {
			enable = true;
			defaultEditor = true;
		};
		vscode = {
			enable = true;
			extensions = with pkgs.vscode-extensions; [
				dracula-theme.theme-dracula
				vscodevim.vim
				yzhang.markdown-all-in-one
				github.copilot
				eamodio.gitlens
			];
			enableUpdateCheck = true;
			enableExtensionUpdateCheck = true;
		};
		zsh = {
			enable = true;
			autocd = true;
			enableAutosuggestions = true;
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
