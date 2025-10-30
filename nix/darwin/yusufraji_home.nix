{ config, pkgs, ... }:
{
  home = {
    username = "yusufraji";
    homeDirectory = "/Users/yusufraji";

    sessionPath = [
      #   "/usr/local/bin"
      # command line tools for calibre are located in the calibre bundle
      # this makes them available globally
      "/Applications/calibre.app/Contents/MacOS/"
    ];

    packages = with pkgs; [
      # rustup
      act
      bat
      fd
      ffmpeg
      fzf
      gibo
      delta
      rustup
      oh-my-zsh
      graphviz
      helix
      lazygit
      llvm
      marksman
      maturin
      ripgrep
      tree
      uv
      yaml-language-server
      yazi
      zellij
      zoxide
      gh

    ];
    stateVersion = "25.05";
  };

  programs.bash.enable = true;
  programs = {
    eza = {
      enable = true;
      package = pkgs.eza;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      colors = "auto";
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--color=auto"
      ];
    };
    zsh = import ../home/zsh.nix { inherit pkgs; };
    bat = import ../home/bat.nix { inherit pkgs; };
    git = import ../home/git.nix { inherit pkgs; };
    home-manager.enable = true;
  };

}
