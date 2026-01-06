{
  config,
  pkgs,
  lib,
  ...
}:
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
      workshop-runner
      # fcast-client
      # fcast-receiver
      ollama
      # open-webui

    ];
    stateVersion = "25.05";

    # Preload Ollama models, equivalent to `services.ollama.loadModels`
    activation.loadOllamaModels = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Wait for Ollama server to be ready
      until "${pkgs.ollama}/bin/ollama" ps >/dev/null 2>&1; do sleep 1; done

      # Pull models
      ${pkgs.ollama}/bin/ollama pull mistral
      ${pkgs.ollama}/bin/ollama pull codestral

      # Warm up models in the background
      ${pkgs.ollama}/bin/ollama run mistral "warmup" >/dev/null 2>&1 &
      ${pkgs.ollama}/bin/ollama run codestral "warmup" >/dev/null 2>&1 &
    '';
  };

  launchd = {
    enable = true;
    # agents.open-webui.enable = true;
    agents.ollama.enable = true;
    agents.ollama.config = {
      ProgramArguments = [
        "${pkgs.ollama}/bin/ollama"
        "serve"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
    # agents.open-webui.config = {
    #   ProgramArguments = [ "${pkgs.open-webui}/bin/open-webui" ];
    #   EnvironmentVariables.OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    #   RunAtLoad = true;
    #   KeepAlive = true;
    # };
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
