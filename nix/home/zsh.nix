{ pkgs }:
{
  enable = true;
  enableCompletion = true;
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

    cat = "bat --paging=never";
    ls = "eza";
  };

  oh-my-zsh = {
    enable = true;
    package = pkgs.oh-my-zsh;
    theme = "robbyrussell";
  };

}
