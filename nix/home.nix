{ config, pkgs, lib, ...}:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });
in
{

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
		nodePackages.aws-cdk
		nodejs
		purescript
		htop
		ripgrep
		gh
		zsh
		oh-my-zsh
		bitwarden-cli
		gitAndTools.gh
		tex
	] ++ lib.optionals stdenv.isDarwin [
		m-cli
	];

	nix = {
		settings.experimental-features = ["nix-command" "flakes"];
	};


	programs = {
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
			userName = "theomantz";
			userEmail = "theo@mantz.nyc";
			ignores = [".DS_Store" "node_modules/" ".direnv/"];
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
				bbenoist.nix
				dracula-theme.theme-dracula
				yzhang.markdown-all-in-one
				vscodevim.vim
				eamodio.gitlens
				github.copilot
			];
			enableUpdateCheck = false;
			enableExtensionUpdateCheck = true;
			userSettings = import ./nixpkgs/vscode.nix;
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
