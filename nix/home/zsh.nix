{ pkgs }:
{
  enable = true;
  enableCompletion = false;

  completionInit = "autoload -U compinit && compinit -u";

  initContent = pkgs.lib.mkBefore ''
    ZSH_DISABLE_COMPFIX="true"
  '';

  package = pkgs.zsh;
  autosuggestion = {
    enable = true;
    strategy = [
      "history"
      "completion"
      "match_prev_cmd"
    ];
  };
  shellAliases = {
    switch = "darwin-rebuild switch --flake ~/dotfiles/nix/darwin";

    b = "bat --paging=never";
    l = "eza";
  };

  oh-my-zsh = {
    enable = true;
    package = pkgs.oh-my-zsh;
    theme = "robbyrussell";
  };

}
